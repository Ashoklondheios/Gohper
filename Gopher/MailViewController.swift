//
//  MailViewController.swift
//  Gopher
//
//  Created by User on 2/13/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage
class MailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    var listofChats = NSMutableArray()
    var listOfConversation = NSMutableArray()

    @IBOutlet weak var popView: UIView!

    var tableView = UITableView()
    //MARK:- Life Cycle Mthods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.hideProgressLoader()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if Commons.connectedToNetwork() {
            self.GetConversationsAPICall()
        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBActions Methods
    
    @IBAction func menuLargeBtn(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }

    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mailCell", for: indexPath)as! MailBoxTableViewCell
        let convoDetail = listofChats[indexPath.row] as! ConversationModel
        cell.lastMesageLabel.text = convoDetail.message
        cell.nameLabel.text = convoDetail.first_name + " "  + convoDetail.last_name
        cell.profileImg.layer.borderWidth=1.0
        cell.profileImg.layer.masksToBounds = false
        cell.profileImg.layer.borderColor = UIColor.white.cgColor
        cell.profileImg.layer.cornerRadius = 13
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.height/2
        cell.profileImg.clipsToBounds = true
        cell.profileImg.sd_setImage(with: URL(string:convoDetail.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        
        cell.timeLabel.text = Commons.changeDateFormat(dateFrom: convoDetail.datetime)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let convoDetail = listofChats[indexPath.row] as! ConversationModel
        
        if Commons.connectedToNetwork() {
            self.GetAllConversationsAPICall(convoDetail)

        }
        else {
        Commons.showAlert("Network Error", VC: self)
        }
//       // let chatView = ChatViewController()
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "conversationVC") as! ChatViewController
//       // nextViewController.messages = nextViewController.makeNormalConversation()
//        present(nextViewController, animated: true, completion: nil)
//        
////    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "conversationVC") as! ConversationViewController
////    self.present(nextViewController, animated:false, completion:nil)
}
    func GetAllConversationsAPICall(_ convoModel: ConversationModel)
    {
        showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId, "sender_id":UserModel.getUserData().userId,"receiver_id":convoModel.user_id] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getConversationAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String, convoModel: convoModel as ConversationModel)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseConversationsResponse(_ response:String, convoModel: ConversationModel) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
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
            hideProgressLoader()
            listOfConversation.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            for i in 0..<msgArray.count {
                let chatDetail = ConversationModel()
                let firstObject = msgArray[i] as! NSDictionary
                let chat = firstObject["Chat"] as! NSDictionary
                let user = firstObject["UserInfo"] as! NSDictionary
                chatDetail.chatId = chat["id"] as! String
                chatDetail.sender_id = chat["sender_id"] as! String
                chatDetail.receiver_id = chat["receiver_id"] as! String
                chatDetail.message = chat["message"] as! String
                chatDetail.conversation_id = chat["conversation_id"] as! String
                chatDetail.user_id = user["user_id"] as! String
                chatDetail.first_name = user["first_name"] as! String
                chatDetail.last_name = user["last_name"] as! String
                chatDetail.profile_img = user["profile_img"] as! String
                chatDetail.datetime = chat["datetime"] as! String
                listOfConversation.add(chatDetail)
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "conversationVC") as! ChatViewController
            nextViewController.conversationDetail.removeAllObjects()
            nextViewController.otherUserId = convoModel.user_id
            nextViewController.otherUserName = convoModel.first_name + " " + convoModel.last_name
            nextViewController.otherProfileImg = convoModel.profile_img
            nextViewController.conversationDetail = listOfConversation
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        
    }
    
    
    //MARK:- Get Conversation Api Call
    func GetConversationsAPICall()
    {
        self.showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getChatInboxAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseConversationsResponse(_ response:String) {
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
            listofChats.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            
            if msgArray.count>0 {
                
                popView.isHidden=true
            }else{
            
                popView.isHidden=false
                
            }
            
            print(msgArray)
            for i in 0..<msgArray.count {
                let chatDetail = ConversationModel()
                let firstObject = msgArray[i] as! NSDictionary
                let chat = firstObject["Chat"] as! NSDictionary
                let user = firstObject["UserInfo"] as! NSDictionary
                chatDetail.chatId = chat["id"] as! String
                chatDetail.sender_id = chat["sender_id"] as! String
                chatDetail.receiver_id = chat["receiver_id"] as! String
                chatDetail.message = chat["message"] as! String
                chatDetail.conversation_id = chat["conversation_id"] as! String
                chatDetail.user_id = user["user_id"] as! String
                chatDetail.first_name = user["first_name"] as! String
                chatDetail.last_name = user["last_name"] as! String
                if (user["profile_img"] as! String).range(of:"http") != nil{
                    chatDetail.profile_img = String (user["profile_img"] as! String)
                }else{
                    chatDetail.profile_img = String (Constants.PROFILEBASEURL) + String (user["profile_img"] as! String)
                }
                chatDetail.datetime = chat["datetime"] as! String
                listofChats.add(chatDetail)
            }
            self.tableView.reloadData()
        }
        
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
