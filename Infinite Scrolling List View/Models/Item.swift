//
//  Item.swift
//  Infinite Scrolling List View
//
//  Created by Anh Nguyen on 11/12/16.
//  Copyright © 2016 Anh Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Item: Object {
    dynamic var id: Int = 0
    dynamic var created: Date?
    dynamic var source: Source?
    dynamic var destination: Destination?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Source: Object {
    dynamic var sender: String = ""
    dynamic var note: String = ""
}

final class Destination: Object {
    dynamic var recipient: String = ""
    dynamic var amount: Int = 0
    dynamic var currency: String = ""
}

// MARK:- Parsable

extension Item: Parsable {
    static func parse(from json: JSON) -> Item {
        let item = Item()
        item.id = json["id"].intValue
        item.created = json["created"].date
        item.source = Source.parse(from: json["source"])
        item.destination = Destination.parse(from: json["destination"])
        
        return item
    }
}

extension Source: Parsable {
    static func parse(from json: JSON) -> Source {
        let source = Source()
        source.sender = json["sender"].stringValue
        source.note = json["note"].stringValue
        
        return source
    }
}

extension Destination: Parsable {
    static func parse(from json: JSON) -> Destination {
        let destination = Destination()
        destination.recipient = json["recipient"].stringValue
        destination.amount = json["amount"].intValue
        destination.currency = json["currency"].stringValue
        
        return destination
    }
}
