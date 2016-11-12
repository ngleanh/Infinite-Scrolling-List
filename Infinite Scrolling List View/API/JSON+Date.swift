//
//  JSON+Date.swift
//  Infinite Scrolling List View
//
//  Created by Anh Nguyen on 11/12/16.
//  Copyright © 2016 Anh Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    public var date: Date? {
        get {
            switch self.type {
            case .string:
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                return formater.date(from: self.object as! String)
            default:
                return nil
            }
        }
    }
}
