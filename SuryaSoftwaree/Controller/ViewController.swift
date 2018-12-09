//
//  ViewController.swift
//  SuryaSoftwaree
//
//  Created by Mac on 06/12/18.
//  Copyright © 2018 Sushma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // emailTextField.text = "sushmalatha.ios@gmail.com"
        
        
         self.title = "Welcome"
        
        // set up activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
    
        
        let count = fetchData()
        
        // Checking Entity Count is 0 or not..
        if count != 0 {
                //   self.saveData()
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "vc_Detail", sender: nil)
                }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }

    
//MARK: Email Validation
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
//MARK: Button Action
    @IBAction func nextButtonAction(_ sender: Any) {
        
        guard emailTextField.text != nil else {

            showAlert(messageStr: "Please Enter Valid Email Addess")
            
            return
        }
        if isValidEmail(testStr: self.emailTextField.text!) {
            
            
            var dict = Dictionary<String, Any>()
            
            dict = ["emailId" :emailTextField.text!]
            var  jsonData = Data()
            
            // var dataString2 :String = ""
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) as Data
                // you can now cast it with the right type
            } catch {
                print(error.localizedDescription)
            }
            

            postrequest(urlStr: "http://surya-interview.appspot.com/list", jsonData: jsonData)
            
            
        }
        else{
            showAlert(messageStr: "Please Enter Valid Email Addess")

        }
        
        
    }
//MARK: Alert Controller
    func showAlert(messageStr : String)  {
        let alertController = UIAlertController(title: "", message: messageStr, preferredStyle: .alert)
        
        let oKButtonAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
           // print("You've pressed default");
        }
        
        alertController.addAction(oKButtonAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

extension ViewController{
    
//MARK: API Implementation
    func postrequest(urlStr: String , jsonData : Data){
        
        
        
         activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var jsonResponse = Dictionary<String, Any>()
        
        let url:URL = URL(string: urlStr)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                //print("error")
                 DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                self.showAlert(messageStr: (error? .localizedDescription)!)
                return
            }
            
            jsonResponse = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            

            //print(jsonResponse["items"] ?? "No Data")
            
             DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            let array : [[String : String]] = jsonResponse["items"] as! [[String : String]]
            
            let count = self.fetchData()
            
            // Checking Data already Saved or not..
            if count != 0 {
                //   self.saveData()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "vc_Detail", sender: nil)
                }
            }
            else{
                 self.saveData(jsonResult: array)
            }
            
            
        }
        task.resume()
      
    }
    
    
    
  //MARK: Fetch Details from Core Data
    func fetchData()-> Int  {
        
        do
        {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Detail")
            let resultData  =  try cntxt.fetch(fetchRequest)
            //print("Row count is :::\(resultData.count)")
            return resultData.count
            
        }
        catch{
            
            print("exception in fetching data...")
            return 0
            
        }
        
        
    }
    
    //MARK: Save Details In CoreData

    func saveData(jsonResult : [[String : String]]) {
        
                for dict in jsonResult {
            
                    let detailContext = Detail(context: cntxt)
                    detailContext.email = dict["emailId"]
                    detailContext.imageUrl = dict["imageUrl"]
                    detailContext.lastName = dict["lastName"]
                    detailContext.firstName = dict["firstName"]
                    print(".....\(dict)......")
            
                    appDelegate.saveContext()
                }
        
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "vc_Detail", sender: nil)
                }
     
        
         }

    
        
}
        
