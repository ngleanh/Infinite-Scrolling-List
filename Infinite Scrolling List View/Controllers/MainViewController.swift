//
//  MainViewController.swift
//  Infinite Scrolling List View
//
//  Created by Anh Nguyen on 11/12/16.
//  Copyright © 2016 Anh Nguyen. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        token = realm.addNotificationBlock { [weak self] notification, realm in
            self?.tableView.reloadData()
        }
        
        setupUI()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        token?.stop()
    }

}

extension MainViewController {
    func setupUI() {
        // Load more indicator
        let loadMoreIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadMoreIndicator.startAnimating()
        tableView.tableFooterView = loadMoreIndicator
        
        // Screen title
        title = "Infinite Scrolling List"
    }
}

extension MainViewController {
    func getData() {
        items = realm.objects(Item.self).sorted(byProperty: "id", ascending: true)
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellIdentifier", for: indexPath) as! ItemTableViewCell
        let item = items?[indexPath.row]
        
        // Fill data to cell
        let formater = DateFormatter()
        formater.dateFormat = "EEEE, MMM d, yyyy"
        var createdText = ""
        if let id = item?.id {
            createdText += String(id) + " - "
        }
        
        if let createdDate = item?.created {
            createdText += formater.string(from: createdDate)
        }
        cell.createdLabel.text = createdText
        
        cell.senderLabel.text = item?.source?.sender ?? ""
        cell.noteLabel.text = item?.source?.note ?? ""
        cell.recipientLabel.text = item?.destination?.recipient ?? ""
        
        var amountTextValue = ""
        if let amountValue = item?.destination?.amount {
            amountTextValue += String(amountValue)
        }
        
        if let currency = item?.destination?.currency {
            amountTextValue += " " + currency
        }
        cell.amountLabel.text = amountTextValue
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.items!.count - 1 {
            DataManager.shared.fetchMoreData(completionHandler: nil, errorHandler: nil)
        }
    }
}
