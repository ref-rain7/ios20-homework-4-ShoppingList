//
//  Item.swift
//  ShoppingList
//
//  Created by zero on 2020/11/15.
//

import UIKit


class Item : NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var name : String
    var photo : UIImage?
    var rating : Int
    var comment : String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let comment = "comment"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo,forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
        coder.encode(comment, forKey: PropertyKey.comment)
    }
    
    init?(name : String, photo : UIImage?, rating : Int, comment : String) {
        guard !name.isEmpty, 0 <= rating, rating <= 5 else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
        self.comment = comment
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        guard let comment = coder.decodeObject(forKey: PropertyKey.comment) as? String else {
            return nil
        }
        
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name : name, photo : photo, rating : rating, comment : comment)
    }
    
//    func encode(with coder: NSCoder) {
//        <#code#>
//    }
//
//    required init?(coder: NSCoder) {
//        <#code#>
//    }
}
