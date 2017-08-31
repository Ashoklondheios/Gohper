//
//  SkillsPopoverViewController.swift
//  Gopher
//
//  Created by User on 2/18/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
protocol MySkillsProtocol: class
{
    func sendSkillsToPreviousVC(myArray:NSMutableArray)
}

class SkillsPopoverViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    //MARK:- IBOutlet Properties
    @IBOutlet weak var enterSkills: UITextField!
    //MARK:- Variables
    weak var mSkillsDelegate:MySkillsProtocol?
    var skillsList = NSMutableArray()
    var tableView = UITableView()
    var showImageIndex : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(skillsList.count)
    
        self.hideKeyBoardOnTap()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(skillsList.count)
        return skillsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell", for: indexPath)as! SkillsTableViewCell
        let skillsModel = skillsList[indexPath.row] as! SkillsModel
        cell.skillsName.text = skillsModel.skillName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
           skillsList.removeObject(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    //MARK:- IBActions Methods
    @IBAction func addSkillBtn(_ sender: Any) {
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }

        var skillModel = SkillsModel()
        skillModel.skillName = enterSkills.text!
        skillsList.add(skillModel)
        self.tableView.reloadData()
        self.enterSkills.text = ""
    }
    @IBAction func okBTn(_ sender: Any) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        mSkillsDelegate?.sendSkillsToPreviousVC(myArray: skillsList)
        print(skillsList)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Keyboard Methods
    func hideKeyBoardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // MARK: Validation Methods
    fileprivate func validateFields() -> (Bool, String?) {
    
        
        if (enterSkills.text?.isEqual(""))! {
            return (false,"Please enter skill")
        }
        
        return (true,nil)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
