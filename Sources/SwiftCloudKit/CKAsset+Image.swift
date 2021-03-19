
import CloudKit
import Foundation

#if os(macOS)
import AppKit
public typealias CloudAssetImage = NSImage
#else
import UIKit
public typealias CloudAssetImage = UIImage
#endif

///图片数据类型转换
public enum CKAssetError: Error {
    case emptyURL
    case corruptedData
}

public extension CKAsset {
    
    convenience init(image: CloudAssetImage, fileType: ImageFileType = .JPG(compressionQuality: 100)) throws {
        
        var url: URL
        
        do {
            
            url = try image.saveToTempLocation(withFileType: fileType)
            
            self.init(fileURL: url)
            
        } catch let error {
            print("Error converting image to Data at CKAsset.init(image:,fileType:): \(error)")
            throw error
        }
    }
    
    func imageAsset() throws -> CloudAssetImage? {
        
        guard let url = fileURL else {
            throw CKAssetError.emptyURL
        }
        
        do {
            
            let data = try Data(contentsOf: url)
        
            return CloudAssetImage(data: data)
            
        } catch {
            throw CKAssetError.corruptedData
        }
    }
}
