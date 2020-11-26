//
//  ViewController.swift
//  SwiftCloudKit
//
//  Created by iOS on 2020/11/26.
//

import UIKit
import CloudKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = CloudConfig()

        let ob = BannerRecord(record: CKRecord(recordType: BannerRecord.recordType))

//        ob.delete(config: config) { (succ) in
//
//        }
//        BannerRecord.insert(object: ob, config: config) { (result) in
//
//        }
    }


}

class BannerRecord: CloudObject{
    var recordID: CKRecord.ID?
    static var recordType = className()
    
    var clickType: Int?///0无 1vc 2wk 3SF 4外链
    var clickUrl: String?
    var imageUrl: String?
    var isUrl: Bool?
    
    required init(record: CKRecord) {
        recordID = record.recordID
        
        if let click = record["clickType"] as? Int{
            clickType = click
        }
        if let url = record["clickUrl"] as? String{
            clickUrl = url
        }

        if let url = record["imageUrl"] as? String{
            imageUrl = url
        }
        
        if let isif = record["isUrl"] as? Int{
            if isif != 0 {
                isUrl = true
            }else{
                isUrl = false
            }
        }
    }
    
    func toRecord() -> CKRecord {
        return CKRecord(recordType: BannerRecord.recordType)
    }
}
