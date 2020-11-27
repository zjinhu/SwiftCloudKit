
import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Types of representation of an image
public enum ImageFileType {
    
    case PNG
    case JPG(compressionQuality: CGFloat)
    
    var fileExtension: String {
        
        switch self {
            
            case .JPG:
                return ".jpg"
                
            case .PNG:
                return ".png"
        }
    }
}

/// Describes errors that may occur during a image conversion
public enum ImageConversionError: Int, Error {
    case unableToConvertImageToData
    case unableToWriteDataToTemporaryFile
    
    #if os(macOS)
    
    case unableToLoadTiffRepresentation
    case unableToLoadBitMapRepresentation
    
    #endif
}

#if os(macOS)

public extension NSImage {
    
    /// PNG representation of this NSImage
    func pngData() throws -> Data? {
        
        if let tiff = self.tiffRepresentation {
            
            if let tiffData = NSBitmapImageRep(data: tiff) {
                return tiffData.representation(using: .png, properties: [:])
                
            } else {
                throw ImageConversionError.unableToLoadBitMapRepresentation
            }
            
        } else {
            throw ImageConversionError.unableToLoadTiffRepresentation
        }
    }
    
    func jpegData(compressionQuality: CGFloat) throws -> Data? {
        
        if let tiff = self.tiffRepresentation {
            
            if let tiffData = NSBitmapImageRep(data: tiff) {
                return tiffData.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
                
            } else {
                throw ImageConversionError.unableToLoadBitMapRepresentation
            }
            
        } else {
            throw ImageConversionError.unableToLoadTiffRepresentation
        }
    }
    
    func saveToTempLocation(withFileType fileType: ImageFileType) throws -> URL {
        
        let imageData: Data?
        
        switch fileType {
            
            case .JPG(let quality):
                imageData = try self.jpegData(compressionQuality: quality)
                
            case .PNG:
                imageData = try self.pngData()
                
        }
        
        guard let data = imageData else {
            throw ImageConversionError.unableToConvertImageToData
        }
        
        let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
        
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            
        } catch {
            throw ImageConversionError.unableToWriteDataToTemporaryFile
        }
        
        return url
    }
    
}

#else

public extension UIImage {
    
    func saveToTempLocation(withFileType fileType: ImageFileType) throws -> URL {
        
        let imageData: Data?
        
        switch fileType {
            
            case .JPG(let quality):
                imageData = self.jpegData(compressionQuality: quality)
                
            case .PNG:
                imageData = self.pngData()
                
        }
        
        guard let data = imageData else {
            throw ImageConversionError.unableToConvertImageToData
        }
        
        let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
                
        do {
            try data.write(to: url)
            
        } catch {
            throw ImageConversionError.unableToWriteDataToTemporaryFile
        }
        
        return url
    }
}

#endif
