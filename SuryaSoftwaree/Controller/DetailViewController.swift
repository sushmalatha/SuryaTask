//
//  DetailViewController.swift
//  SuryaSoftwaree
//
//  Created by Mac on 06/12/18.
//  Copyright © 2018 Sushma. All rights reserved.
//

import UIKit
import CoreData
//import SDWebImage

class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var detailsArry = [AnyObject]()

    @IBOutlet weak var detailsTableview: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fetchData()
        detailsTableview.dataSource = self
        self.title = "Details"
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - UITableViewDelegate,UITableViewDataSourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.detailsArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
                let cell : DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailsTableViewCell
        
                cell.nameLabel.text = String(format: "%@ %@",(detailsArry[indexPath.section] as! [String : String])["firstName"]! as String,(detailsArry[indexPath.section] as! [String : String])["lastName"]! as String )
                cell.emailAddressLabel.text = (detailsArry[indexPath.section] as! [String : String])["email"]! as String
                cell.myImageView.layer.cornerRadius =  cell.myImageView.frame.height/2
                cell.myImageView.clipsToBounds = true
        
        
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.clipsToBounds = true
                cell.contentView.layer.borderWidth = 1
                cell.contentView.layer.borderColor = UIColor.black.cgColor
        
        
        //cell.myImageView.sd_setImage(with: URL(string: "https://pbs.twimg.com/profile_images/1047752972/2010-01-14-angela-merkel_property_poster.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
        
                let urlStr = URL(string: (detailsArry[indexPath.section] as! [String : String])["imageUrl"]! as String )
                getData(from: urlStr!) { (data, response, error) in

                if ((error) == nil){
                        DispatchQueue.main.async() {
                            cell.myImageView.image = UIImage(data: data!)
                        }

                }


            }

        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension ;
    }
  // MARK: - Download Image from Server..
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
  // Fetch Records from Core Data..
    func fetchData()  {
        do
        {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Detail")
            let resultData  =  try cntxt.fetch(fetchRequest)
            print("Row count is :::\(resultData.count)")
            
            if (resultData.count > 0) {
                
                    for each in resultData
                        {
                                let eachRecord = ["firstName" : each.value(forKey: "firstName"),
                                                  "lastName": each.value(forKey: "lastName"),
                                                  "email" : each.value(forKey: "email"),
                                                  "imageUrl"  : each.value(forKey: "imageUrl")
                                                ]
                                detailsArry.append(eachRecord as AnyObject)
                        }
            }
            
            DispatchQueue.main.async {
                self.detailsTableview.reloadData()
            }
            
        }
        catch{
            print("exception in fetching...")
        }
    }


}
