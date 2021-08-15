//
//  ImageData.swift
//  PhotoGrid
//
//  Created by Mohammed Ibrahim on 15/8/21.
//

import Foundation


struct ImageData : Codable {
    var url : String
    
    init(from decoder : Decoder ) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try value.decode(String.self, forKey: .url)
    }
}

private struct DummyCodable: Codable {}

struct ImageDatatoKV: Codable {
        var imageData: [ImageData]
        
        init(from decoder: Decoder) throws {
            var imagedata = [ImageData]()
            var container = try decoder.unkeyedContainer()
            while !container.isAtEnd {
                if let route = try? container.decode(ImageData.self) {
                    imagedata.append(route)
                }
                else {
                    //This si great to break the loop when there's no properties in the payload
                    _ = try? container.decode(DummyCodable.self)
                }
            }
            self.imageData = imagedata
        }
    }

