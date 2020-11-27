import Foundation
import CloudKit
import UIKit

public protocol RecordModel{
    
    static var recordType: String { get }
    
    var useRecord: CKRecord { get }
    
    init(record: CKRecord)
    
    associatedtype FieldKey : RawRepresentable

}

public extension RecordModel where FieldKey.RawValue == String {

    func getField<T>(_ key: FieldKey) -> T? {
        return useRecord[key.rawValue] as? T
    }
    
    func setField<T>(_ key: FieldKey, value: T?) {
        return useRecord[key.rawValue] = value as? CKRecordValue
    }
    
    
    func getReference(_ key: FieldKey) -> String? {
        let ref: CKRecord.Reference? = getField(key)
        return ref?.recordID.recordName
    }
    
    func setReference(_ key: FieldKey, referenceIdentifier: String?) {
        let ref = referenceIdentifier.flatMap { (id: String) -> CKRecord.Reference in
            let rid = CKRecord.ID(recordName: id)
            return CKRecord.Reference(recordID: rid, action: .deleteSelf)
        }
        setField(key, value: ref)
    }
    
    
    func getAsset(_ key: FieldKey) -> UIImage? {
        let ref: CKAsset? = getField(key)
        return try? ref?.imageAsset()
    }
    
    func setAsset(_ key: FieldKey, image: UIImage?) {
        guard let im = image, let asset = try? im.saveToTempLocation(withFileType: .PNG) else {
            return
        }
        setField(key, value: asset)
    }
}

public enum DatabaseType {
    case privateDB
    case publicDB
    case sharedDB
}

public struct CloudConfig {
    ///DB所需要的参数
    ///db类型
    public var type: DatabaseType = .privateDB
    ///db id
    public var identifier: String?
    
    ///查询需要用的参数
    ///查询条件 NSPredicate(format: "creationDate > %@", date) NSPredicate(format: "creatorUserRecordID = %@", userRecordID)
    public var predicate: NSPredicate = NSPredicate(value: true)
    ///请求数
    public var resultsLimit : Int = 10
    ///排序 let sort = NSSortDescriptor(key: "creationDate", ascending: true)
    public var sortDescriptors: [NSSortDescriptor]?
    ///请求记录
    public var cursor: CKQueryOperation.Cursor?
    
    ///更新上传需要用的参数
    ///更新数据
    public var policy:  CKModifyRecordsOperation.RecordSavePolicy = .allKeys
}

public struct SwiftCloudKit {
    
    static func isCloudLogin(_ callback: @escaping (Bool) -> Void){
        CKContainer.default().accountStatus { (status, error) in
            if status == .noAccount{
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    
    ///请求认证
    static func requestPermission(completion: @escaping (Result<CKContainer_Application_PermissionStatus, Error>) -> Void) {
        
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (permission, error) in
            if let error = error {
                completion(.failure(error))
                
            } else {
                completion(.success(permission))
            }
        }
    }
    
    ///获取认证状态
    static func verifyStatus(completion: @escaping (Result<CKContainer_Application_PermissionStatus, Error>) -> Void) {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permission, error) in
            
            if let error = error {
                completion(.failure(error))
                
            } else {
                completion(.success(permission))
            }
        }
    }
    
    static func fetchUserID(completion: @escaping (CKRecord.ID?) -> Void) {
        CKContainer.default().fetchUserRecordID { (id, error) in
            if let validID = id {
                completion(validID)
            } else {
                completion(nil)
            }
        }
    }
    
    static func fetchUserInfo(userID: CKRecord.ID,
                              completion: @escaping (CKUserIdentity?) -> Void) {
        
        CKContainer.default().discoverUserIdentity(withUserRecordID: userID) { (user, error) in
            if let user = user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    static func getDatabase(_ type: DatabaseType, identifier: String? = nil) -> CKDatabase{
        
        if let idf = identifier{
            switch type {
            case .privateDB:
                return CKContainer(identifier: idf).privateCloudDatabase
            case .publicDB:
                return CKContainer(identifier: idf).publicCloudDatabase
            case .sharedDB:
                return CKContainer(identifier: idf).sharedCloudDatabase
            }
        }else{
            switch type {
            case .privateDB:
                return CKContainer.default().privateCloudDatabase
            case .publicDB:
                return CKContainer.default().publicCloudDatabase
            case .sharedDB:
                return CKContainer.default().sharedCloudDatabase
            }
        }
        
    }
}

public extension SwiftCloudKit {
    
    /// 插入
    /// - Parameters:
    ///   - object: 对象
    ///   - config: 配置器
    ///   - completion: 回调
    static func insert<T: RecordModel>(object: T,
                                       config: CloudConfig,
                                       completion: @escaping (Result<T, Error>) -> Void){
        
        let database = getDatabase(config.type, identifier: config.identifier)
        
        let record = object.useRecord
        
        database.save(record) { (savedRecord, error) in
            guard let savedRecord = savedRecord else {
                if let error = error {
                    return completion(.failure(error))
                }
                return
            }
            
            let savedObject = T(record: savedRecord)
            completion(.success(savedObject))
            
        }
    }
    
    /// 更新
    /// - Parameters:
    ///   - recordID: 需要更新的ID
    ///   - object: 对象
    ///   - config: 配置器
    ///   - completion: 回调
    static func update<T: RecordModel>(object: T,
                                       config: CloudConfig,
                                       completion: @escaping (Result<T, Error>) -> Void){
        
        let database = getDatabase(config.type, identifier: config.identifier)
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [object.useRecord], recordIDsToDelete: nil)
        modifyOperation.savePolicy = config.policy
        modifyOperation.qualityOfService = QualityOfService.userInitiated
        modifyOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in
            //   the completion block code here
            guard let savedRecords = savedRecords,
                  operationError == nil else {
                if let error = operationError{
                    return completion(.failure(error))
                }
                return
            }
            
            let object = T(record: savedRecords[0])
            completion(.success(object))
            
        }
        database.add(modifyOperation)
    }
    
    
    
    /// 删除
    /// - Parameters:
    ///   - object: 对象
    ///   - config: 配置器
    ///   - completion: 回调
    static func delete<T: RecordModel>(object: T,
                                       config: CloudConfig,
                                       completion: @escaping (Bool) -> Void) {
        
        let ID = object.useRecord.recordID
        let database = getDatabase(config.type, identifier: config.identifier)
        database.delete(withRecordID: ID) { (id, error) in
            guard let _ = id else {
                if let _ = error {
                    return completion(false)
                }
                return
            }
            completion(true)
        }
    }
    
    //    func delete() {
    //        let db = CKContainer.default().publicCloudDatabase
    //        let predicate = NSPredicate(format: "note = %@", "你好")
    //        let query = CKQuery(recordType: "Note", predicate: predicate)
    //
    //        let operation = CKQueryOperation(query: query)
    //
    //        operation.recordFetchedBlock = { (record : CKRecord?) in
    //            guard let record = record else {
    //                return
    //            }
    //
    //            db.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in
    //                if error == nil {
    //                    print("刪除成功")
    //                } else {
    //                    print("刪除失敗: \(error)")
    //                }
    //            })
    //        }
    //        operation.queryCompletionBlock = { (cursor, error) in
    //            guard error == nil else {
    //                print(error?.localizedDescription ?? "Error")
    //                return
    //            }
    //
    //            // 結束後要做什麼事情
    //        }
    //
    //        // 執行
    //        db.add(operation)
    //    }
    
    /// 获取指定的对象
    /// - Parameters:
    ///   - recordID: 对象ID
    ///   - config: 配置器
    ///   - completion: 回调
    static func fetchOne<T: RecordModel>( modelType: T.Type,
                                          recordID: CKRecord.ID,
                                          config: CloudConfig,
                                          completion: @escaping (T?) -> Void){
        
        let database = getDatabase(config.type, identifier: config.identifier)
        database.fetch(withRecordID: recordID) { record, error in
            guard let record = record else {
                if let _ = error {
                    return completion(nil)
                }
                return
            }
            completion(T(record: record))
        }
    }
    
    /// 查询全部,小剂量数据用
    /// - Parameters:
    ///   - config: 配置
    ///   - completion: 回调
    static func fetchAll<T: RecordModel>( modelType: T.Type,
                                          config: CloudConfig,
                                          completion: @escaping (Result<[T], Error>) -> Void){
        
        let database = getDatabase(config.type, identifier: config.identifier)
        let query = CKQuery(recordType: T.recordType, predicate: config.predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            var array = [T]()
            records.forEach { (r) in
                
                let object = T(record: r)
                array.append(object)
                
            }
            completion(.success(array))
        }
    }
    
    /// 请求翻页数组
    /// - Parameters:
    ///   - cursor: 上次的请求记录
    ///   - configBlock: 配置器
    ///   - completion: 请求回调
    static func fetchPageList<T: RecordModel>( modelType: T.Type,
                                               cursor: CKQueryOperation.Cursor?,
                                               config: CloudConfig,
                                               completion: @escaping (Result<([T], cursor: CKQueryOperation.Cursor?), Error>) -> Void) {
        
        let database = getDatabase(config.type, identifier: config.identifier)
        
        var objects: [T] = []
        var operation: CKQueryOperation?
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let query = CKQuery(recordType: T.recordType, predicate: config.predicate)
            if let sort = config.sortDescriptors{
                query.sortDescriptors = sort
            }
            operation = CKQueryOperation(query: query)
        }
        
        guard let op = operation else {
            return
        }
        
        op.resultsLimit = config.resultsLimit
        
        op.recordFetchedBlock = { record in
            let object = T(record: record)
            objects.append(object)
        }
        
        op.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    completion(.success((objects, cursor)))
                } else if let error = error{
                    completion(.failure(error))
                }
            }
        }
        
        database.add(op)
    }
    
    /// 插入数组
    /// - Parameters:
    ///   - objects: 对象数组
    ///   - config: 配置器
    ///   - completion: 回调
    static func insertArray<T: RecordModel>(objects: [T],
                                            config: CloudConfig,
                                            completion: @escaping (Result<Bool, Error>) -> Void){
        
        let database = getDatabase(config.type, identifier: config.identifier)
        var recordArray = [CKRecord]()
        objects.forEach { (obj) in
            recordArray.append(obj.useRecord)
        }
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: recordArray, recordIDsToDelete: nil)
        modifyOperation.savePolicy = config.policy
        modifyOperation.qualityOfService = QualityOfService.userInitiated
        modifyOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in
            //   the completion block code here
            guard let _ = savedRecords,
                  operationError == nil else {
                if let error = operationError{
                    return completion(.failure(error))
                }
                return
            }
            
            completion(.success(true))
        }
        database.add(modifyOperation)
    }
}
