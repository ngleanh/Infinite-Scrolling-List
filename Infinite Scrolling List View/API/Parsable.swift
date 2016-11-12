//
//  Parsable.swift
//  Infinite Scrolling List View
//
//  Created by Anh Nguyen on 11/12/16.
//  Copyright © 2016 Anh Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Parsable {
    static func parse(from json:JSON) -> Self
}
