//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AFNetworking
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    let defaults = UserDefaults.standard
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    var otherUserId: String!;
    var otherUserName: String!;
    var otherProfileImg: String!;
    var conversationDetail = NSMutableArray()
    var meProfileImg:JSQMessagesAvatarImage!
    var otherProfileImgPic:JSQMessagesAvatarImage!
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.messages = makeNormalConversation()
        // Setup navigation
        topView()
        setupBackButton()
        //self.tabBarController?.tabBar.isHidden = true
        self.senderId  = UserModel.getUserData().userId
        self.senderDisplayName = getName(UserModel.getUserData().userId)
        let imageName = UserModel.getUserData().profile_img
        var dataa = NSData(contentsOf: NSURL(string: imageName) as! URL)
        let url = URL(string: imageName)
        do {
            let imageData = try Data(contentsOf: url! as URL)
            dataa = imageData as NSData?
        } catch {
            print("Unable to load data: \(error)")
        }
        
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        if dataa != nil {
            
            meProfileImg = JSQMessagesAvatarImage.avatar(with:UIImage(data: dataa as! Data))
        
        }
        
        let otherdataa = NSData(contentsOf: NSURL(string: otherProfileImg) as! URL)
        
        if otherdataa != nil {
            
            otherProfileImgPic = JSQMessagesAvatarImage.avatar(with:UIImage(data: otherdataa as! Data))
            
        }

        
        
    
        self.messages = makeNormalConversation()
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
            outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        collectionView?.collectionViewLayout.springinessEnabled = false
        automaticallyScrollsToMostRecentMessage = true
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()

        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ChatViewController.callTimer), userInfo: nil, repeats: true)
        
        

    }
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    func callTimer()
    {
        if Commons.connectedToNetwork() {
            self.GetMoreMessagesAPICall()

        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
    }
    
    func topView()  {
        
        //self.view.frame = CGRect(x:0, y:70, width:self.view.frame.width,  height:self.view.frame.height)
        
        let x:CGFloat      = self.view.bounds.origin.x
        let y:CGFloat      = self.view.bounds.origin.y + CGFloat(70.0)
        let width:CGFloat  = self.view.bounds.width
        let height:CGFloat = self.view.bounds.height - CGFloat(70.0)
        let frame:CGRect   = CGRect(x: x, y: y, width: width, height: height)
        
        self.collectionView?.frame = frame
        let DynamicView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width+200, height:70))
        DynamicView.backgroundColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        
        let button = UIButton(frame: CGRect(x: 8, y: 40, width: 20, height: 20))
        button.setImage(UIImage(named: "backarrow.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
        let codedLabel:UILabel = UILabel()
        codedLabel.frame = CGRect(x: DynamicView.frame.width/2-110, y: 30, width: 50, height: 40)
        codedLabel.textAlignment = .center
        codedLabel.text = "Chats"
        codedLabel.numberOfLines=1
        codedLabel.textColor=UIColor.white
        codedLabel.font=UIFont.systemFont(ofSize: 17)
        //codedLabel.backgroundColor=UIColor.lightGray
        
        DynamicView.addSubview(codedLabel)
        
        DynamicView.addSubview(button)
        
        
        self.view?.addSubview(DynamicView)
    }
    func pressButton(button: UIButton) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func receiveMessagePressed(_ sender: UIBarButtonItem) {
        /**
         *  DEMO ONLY
         *
         *  The following is simply to simulate received messages for the demo.
         *  Do not actually do this.
         */
        
        /**
         *  Show the typing indicator to be shown
         */
        self.showTypingIndicator = !self.showTypingIndicator
        
        /**
         *  Scroll to actually view the indicator
         */
        self.scrollToBottom(animated: true)
        
        /**
         *  Copy last sent message, this will be the new "received" message
         */
        var copyMessage = self.messages.last?.copy()
        
        if (copyMessage == nil) {
            copyMessage = JSQMessage(senderId: UserModel.getUserData().userId, displayName: getName(UserModel.getUserData().userId), text: "First received!")
        }
            
        var newMessage:JSQMessage!
        var newMediaData:JSQMessageMediaData!
        var newMediaAttachmentCopy:AnyObject?
        
        if (copyMessage! as AnyObject).isMediaMessage() {
            /**
             *  Last message was a media message
             */
            let copyMediaData = (copyMessage! as AnyObject).media
            
            switch copyMediaData {
            case is JSQPhotoMediaItem:
                let photoItemCopy = (copyMediaData as! JSQPhotoMediaItem).copy() as! JSQPhotoMediaItem
                photoItemCopy.appliesMediaViewMaskAsOutgoing = false
                
                newMediaAttachmentCopy = UIImage(cgImage: photoItemCopy.image!.cgImage!)
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view5017
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy
            case is JSQLocationMediaItem:
                let locationItemCopy = (copyMediaData as! JSQLocationMediaItem).copy() as! JSQLocationMediaItem
                locationItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = locationItemCopy.location!.copy() as AnyObject?
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            case is JSQVideoMediaItem:
                let videoItemCopy = (copyMediaData as! JSQVideoMediaItem).copy() as! JSQVideoMediaItem
                videoItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (videoItemCopy.fileURL! as NSURL).copy() as AnyObject?
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = false;
                
                newMediaData = videoItemCopy;
            case is JSQAudioMediaItem:
                let audioItemCopy = (copyMediaData as! JSQAudioMediaItem).copy() as! JSQAudioMediaItem
                audioItemCopy.appliesMediaViewMaskAsOutgoing = false
                newMediaAttachmentCopy = (audioItemCopy.audioData! as NSData).copy() as AnyObject?
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            default:
                assertionFailure("Error: This Media type was not recognised")
            }
            
            newMessage = JSQMessage(senderId: UserModel.getUserData().userId, displayName: getName(UserModel.getUserData().userId), media: newMediaData)
        }
        else {
            /**
             *  Last message was a text message
             */
            
            newMessage = JSQMessage(senderId: UserModel.getUserData().userId, displayName: getName(UserModel.getUserData().userId), text: (copyMessage! as AnyObject).text)
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new JSQMessageData object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        self.messages.append(newMessage)
        self.finishReceivingMessage(animated: true)
        
        if newMessage.isMediaMessage {
            /**
             *  Simulate "downloading" media
             */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                switch newMediaData {
                case is JSQPhotoMediaItem:
                    (newMediaData as! JSQPhotoMediaItem).image = newMediaAttachmentCopy as? UIImage
                    self.collectionView!.reloadData()
                case is JSQLocationMediaItem:
                    (newMediaData as! JSQLocationMediaItem).setLocation(newMediaAttachmentCopy as? CLLocation, withCompletionHandler: {
                        self.collectionView!.reloadData()
                    })
                case is JSQVideoMediaItem:
                    (newMediaData as! JSQVideoMediaItem).fileURL = newMediaAttachmentCopy as? URL
                    (newMediaData as! JSQVideoMediaItem).isReadyToPlay = true
                    self.collectionView!.reloadData()
                case is JSQAudioMediaItem:
                    (newMediaData as! JSQAudioMediaItem).audioData = newMediaAttachmentCopy as? Data
                    self.collectionView!.reloadData()
                default:
                    assertionFailure("Error: This Media type was not recognised")
                }
            }
        }
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //ss
        self.messages.append(message!)
        
        let convoModel = ConversationModel()
        convoModel.sender_id = senderId
        convoModel.message = text
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        convoModel.datetime = formatter.string(from: date)
        convoModel.profile_img = UserModel.getUserData().profile_img
        convoModel.first_name = UserModel.getUserData().first_name
        convoModel.last_name = UserModel.getUserData().last_name
        conversationDetail.add(convoModel)
        if Commons.connectedToNetwork() {
            GetAllConversationsAPICall(otherUserId,message: text,dateTime: formatter.string(from: date))
        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
        self.finishSendingMessage(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
            self.addMedia(photoItem!)
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in
            /**
             *  Add fake location
             */
            let locationItem = self.buildLocationItem()
            
            self.addMedia(locationItem)
        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .default) { (action) in
            /**
             *  Add fake video
             */
            let videoItem = self.buildVideoItem()
            
            self.addMedia(videoItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .default) { (action) in
            /**
             *  Add fake audio
             */
            let audioItem = self.buildAudioItem()
            
            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func buildVideoItem() -> JSQVideoMediaItem {
        let videoURL = URL(fileURLWithPath: "file://")
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        return videoItem!
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
        let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(_ media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: media)
        self.messages.append(message!)
        
        //Optional: play sent sound
        
        self.finishSendingMessage(animated: true)
    }
    
    
    //MARK: JSQMessages CollectionView DataSource
    
//    override func senderId() -> String {
//        return User.Wozniak.rawValue
//    }
//    
//    override func senderDisplayName() -> String {
//        return getName(.Wozniak)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        return getAvatar(message.senderId)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item == 0) {
            return nil
        }else{
            //let message = self.messages[indexPath.item]
//            if(sendPressed==true)
//            {
//                //2017-02-10 11:34:33
//                sendPressed = false
//                let message = self.messages[indexPath.item]
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for:Commons.changeChatDateFormat(dateFrom: formatter.string(from: message.date)))
//            }
//            else
//            {
                print(indexPath.item)
                let message = conversationDetail[indexPath.item] as! ConversationModel
                
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for:Commons.changeChatDateFormat(dateFrom: message.datetime))
            
        }
        
        //return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
       // if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
       //     return nil
       // }
        
        if message.senderId == self.senderId {
            return nil
        }

        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        //if indexPath.item % 3 == 0 {
            if(indexPath.item==0)
            {
                 return kJSQMessagesCollectionViewCellLabelHeightDefault+50
            }
            else{
                 return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
//
//        }
        
//        return 0.0
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
        //if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
        //    return 0.0
        //}
        
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
//        if(indexPath.item==0)
//        {
//            return kJSQMessagesCollectionViewCellLabelHeightDefault+20
//        }
//        else{
            return kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
    }
    func makeNormalConversation() -> [JSQMessage] {
        
        var conversation = [JSQMessage]()
        let list = conversationDetail
        print(list)
        for i in 0..<list.count {
            let convoModel = list[i] as! ConversationModel
            let id = convoModel.sender_id as String
            let name = convoModel.first_name + " " + convoModel.last_name as String
            let mesg = convoModel.message as String
            let message = JSQMessage(senderId: id, displayName: name, text: mesg)
            conversation.append(message!)
        }
        
        
        
        return conversation
    }

    // Helper Method for getting an avatar for a specific User.
    func getAvatar(_ id: String) -> JSQMessagesAvatarImage{
        // let user = User(rawValue: id)!
        
        switch id {
        case UserModel.getUserData().userId:
            return meProfileImg
        case otherUserId:
            return otherProfileImgPic
        default:
            return meProfileImg
        }
    }
    func getName(_ id: String) -> String{
        switch id {
        case UserModel.getUserData().userId:
            return UserModel.getUserData().first_name + " " + UserModel.getUserData().last_name
        case otherUserId:
            return otherUserName
        default:
            return ""
        }
    }
    
    
    //MARK:- Get Notification Count Api Call
    func GetAllConversationsAPICall(_ receverId: String, message:String, dateTime:String)
    {
        
        let params = ["sender_id":UserModel.getUserData().userId, "receiver_id":receverId,"message":message, "datetime":dateTime] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getChatAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseConversationsResponse(_ response:String) {
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
        }
        
    }
    
    
    //MARK:- Get More Messges API Call
    func GetMoreMessagesAPICall()
    {
        
        let params = ["user_id":UserModel.getUserData().userId, "sender_id":UserModel.getUserData().userId,"receiver_id":otherUserId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getConversationAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseMoreMessageResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseMoreMessageResponse(_ response:String) {
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
            conversationDetail.removeAllObjects()
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
                conversationDetail.add(chatDetail)
            }
            self.messages = makeNormalConversation()
            incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
            outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
            
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
            
            collectionView?.collectionViewLayout.springinessEnabled = false
            automaticallyScrollsToMostRecentMessage = true
            self.collectionView?.reloadData()
            self.collectionView?.layoutIfNeeded()
        }
    }
}
