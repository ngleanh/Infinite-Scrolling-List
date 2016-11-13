//
//  DataManager.swift
//  Infinite Scrolling List View
//
//  Created by Anh Nguyen on 11/12/16.
//  Copyright © 2016 Anh Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Realm
import RealmSwift

class DataManager {
    
    // Type alias
    typealias NoDataHandler = () -> Void
    
    // Singleton
    static let shared = DataManager()
    
    // Private data
    fileprivate let APIEndPoint = "https://hook.io/syshen/infinite-list"
    fileprivate let pageSize = 20
    fileprivate var currentPage = 0
    
    // Fetch data from network
    func fetchMoreData(completionHandler: (([Item]) -> Void)?, errorHandler: ((Error) -> Void)?) {
        self.currentPage = self.currentPage + 1
        fetchData(page: currentPage, completionHandler: { items in
            completionHandler?(items)
        }, errorHandler: errorHandler)
    }
    
    func fetchData(page: Int, completionHandler: (([Item]) -> Void)?, errorHandler: ((Error) -> Void)?) {
        let parameters = ["startIndex": page * pageSize,
                          "num" : pageSize]
        Alamofire.request(APIEndPoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(queue: DispatchQueue.global(qos: .utility), options: .allowFragments, completionHandler: { [unowned self] response in
                print(response.request?.url)
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let items = self.parseData(from: json)
                    self.saveDataToCache(items: items)
                    completionHandler?(self.parseData(from: json))
                case .failure(let error):
                    errorHandler?(error)
                }
            })
    }
    
    // Remove all data
    func removeDataAndLoadFirstPage() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        fetchData(page: 0, completionHandler: nil, errorHandler: nil)
    }
}

extension DataManager {
    func key(forPage page: Int) -> String {
        return String(page)
    }
    
    func saveDataToCache(items: [Item]) {
        let realm = try! Realm()
        try! realm.write {
            for item in items {
                realm.add(item, update: true)
            }
        }
    }
}

extension DataManager {
    
    // Parse data
    fileprivate func parseData(from jsonValue: JSON) -> [Item] {
        return jsonValue.arrayValue.map { (json) -> Item in
            Item.parse(from: json)
        }
    }
}
