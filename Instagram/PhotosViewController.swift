//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Brian Jordan on 2/4/15.
//  Copyright (c) 2015 Brian Jordan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var photos: NSArray?
    var rc: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 500
        self.rc = UIRefreshControl()
        rc?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.rc!, atIndex: 0)
        
        self.fetchInstagramData()
    }
    
    func onRefresh() {
        self.fetchInstagramData()
    }
    
    func fetchInstagramData() {
        var clientId = "ENTER CLIENT ID HERE"
        
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as? NSArray
            self.tableView.reloadData()
            
            println("response: \(self.photos)")
            self.rc?.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photoRows = self.photos {
            return photoRows.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.codepath.photocell") as PhotoTableViewCell
        cell.photoView.setImageWithURL(getPhotoURLFromRow(indexPath.row))
        return cell
    }
    
    func getPhotoURLFromRow(row: Int) -> NSURL {
        let image:NSDictionary = self.photos?[row] as NSDictionary
        let images:NSDictionary = image["images"] as NSDictionary
        let resolution:NSDictionary = images["low_resolution"] as NSDictionary
        let url:NSString = resolution["url"] as NSString
        return NSURL(string: url)!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "com.codepath.detailsegue" {
            let vc = segue.destinationViewController as PhotoDetailsViewController
            vc.photoURL = getPhotoURLFromRow(tableView.indexPathForSelectedRow()!.row)
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
