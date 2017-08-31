//
//  CategoriesViewController.swift
//  Gopher
//
//  Created by User on 2/18/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking

protocol MyProtocol: class
{
    func sendArrayToPreviousVC(myArray:NSMutableArray)
}

class CategoriesViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Variables
    weak var mDelegate:MyProtocol?
    var showImageIndex : Int?
    var isClicked = false
    var categoryList = NSMutableArray()
    var selectedCategoryList = NSMutableArray()
    var tableView = UITableView()
    
    @IBOutlet weak var indicatirView: UIActivityIndicatorView!
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //categoryList = NSMutableArray()
        if(Commons.connectedToNetwork())
        {
            
            self.getCategoriesAPICall()
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catogriesCell", for: indexPath)as! CategoryTableViewCell
        let cateogryModel = categoryList[indexPath.row] as! CategoryModel
        if (cateogryModel.isSelected)
        { // item needed - display checkmark
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else
        { // not needed no checkmark
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        cell.categoryName.text = cateogryModel.catName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catogriesCell", for: indexPath)as! CategoryTableViewCell
        
        let cateogryModel = categoryList[indexPath.row] as! CategoryModel
        if(cateogryModel.isSelected == false)
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cateogryModel.isSelected = true
            categoryList[indexPath.row] = cateogryModel
            selectedCategoryList.add(cateogryModel)
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.none
            selectedCategoryList.remove(cateogryModel)
            cateogryModel.isSelected = false
            categoryList[indexPath.row] = cateogryModel
            
        }
       
        tableView.reloadData()
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func okBTn(_ sender: Any) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        var categoryModel = CategoryModel()
        for i in 0..<selectedCategoryList.count {
          
            categoryModel = selectedCategoryList[i] as! CategoryModel
    
            // UserModel.instance.categoryList.add(categoryModel as CategoryModel)
            print(categoryModel.catID)
            print(categoryModel.catName)
        }
        mDelegate?.sendArrayToPreviousVC(myArray: selectedCategoryList)
        print(selectedCategoryList)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCategoriesAPICall()
    {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.get(Constants.GETCATEGORIESAPIURL, parameters: nil, progress: nil, success: {  requestOperation, response in
            
            let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
            self.showProgressLoader()
            print(result)
            self.parseCategoriesResponse(result as String)
        },
                    failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
        
        
    }
    fileprivate func parseCategoriesResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()

        print(code)
        
        if code == 201 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            
            let msgArray = dict?["msg"] as! NSArray
            var categoryModel = CategoryModel()
            for i in 0..<msgArray.count {
                let firstObject = msgArray[i] as! NSDictionary
                let objectval = firstObject["Category"] as! NSDictionary
                categoryModel = CategoryModel()
                categoryModel.catID = objectval["cat_id"] as! String
                categoryModel.catName = objectval["cat_name"] as! String
                categoryModel.isSelected = false
                categoryList.add(categoryModel as CategoryModel)
                print(categoryModel.catID)
                print(categoryModel.catName)
            }
            print(categoryList.count)
            self.tableView.reloadData()
        }
    }
    // MARK: - Indicator methods
//    func showProgressLoader()
//    {
//        self.indicatirView.isHidden=false
//        self.indicatirView.startAnimating()
//    }
//    
//    func hideProgressLoader()
//    {
//        self.indicatirView.isHidden=true
//        self.indicatirView.stopAnimating()
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
