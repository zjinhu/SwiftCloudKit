//
//  ViewController.swift
//  SwiftCloudKit
//
//  Created by iOS on 2020/11/26.
//

import UIKit
import CloudKit
class ViewController: UIViewController {

    var array: [BannerRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var config = CloudConfig()
        config.type = .publicDB
        
        SwiftCloudKit.fetchAll(modelType: BannerRecord.self, config: config) { (result) in
            switch result{
            case .success(let records):
                self.array = records
                let re = records.first
                let clickType = re?.clickType
                let clickUrl = re?.clickUrl
                let imageUrl = re?.imageUrl
                let isUrl = re?.isUrl
                print("\(clickType)--\(isUrl)--\(imageUrl)--\(clickUrl)")
                
                guard let model = records.last else {
                    return
                }
                SwiftCloudKit.delete(object: model, config: config) { (succ) in
                    print("\(succ)")
                }
            case . failure(let error):
                print("\(error)")
            }
        }
        
        
        var ob = BannerRecord(record: CKRecord(recordType: BannerRecord.recordType))

        ob.clickType = 4
        ob.clickUrl = "https://www.baidu.com"
        
        SwiftCloudKit.insert(object: ob, config: config) { (result) in
            switch result{
            case .success(let record):
                let clickType = record.clickType
                let clickUrl = record.clickUrl
                let imageUrl = record.imageUrl
                let isUrl = record.isUrl
                print("\(clickType)--\(isUrl)--\(imageUrl)--\(clickUrl)")
            case . failure(let error):
                print("\(error)")
            }
        }
    }


}

struct BannerRecord: RecordModel{

    var useRecord: CKRecord
    
    enum FieldKey : String {
        case clickType
        case clickUrl
        case imageUrl
        case isUrl
      }

    static var recordType = "BannerRecord"
    
    init(record: CKRecord) {
        useRecord = record
    }
    
    var clickType: Int? {
          get {
              return getField(.clickType)
          }
          set {
              setField(.clickType, value: newValue)
          }
      }
    var clickUrl: String? {
          get {
              return getField(.clickUrl)
          }
          set {
              setField(.clickUrl, value: newValue)
          }
      }
    var imageUrl: String? {
          get {
              return getField(.imageUrl)
          }
          set {
              setField(.imageUrl, value: newValue)
          }
      }
    
    var isUrl: Bool {
          get {
              return getField(.isUrl) ?? false
          }
          set {
              setField(.isUrl, value: newValue)
          }
      }

}
