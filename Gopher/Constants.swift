//
//  Constants.swift
//  Gopher
//
//  Created by User on 2/20/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class Constants: NSObject {

    static let BASEURL = "http://54.174.109.228/gopher/api/"
    static let PROFILEBASEURL = "http://54.174.109.228/gopher/" as String
    static let SIGNUPAPIURL = BASEURL + "registerUser"
    static let SIGNINAPIURL = BASEURL + "login"
    static let SIGNINFBAPIURL = BASEURL + "loginFacebook"
    static let SIGNINGOOGLEAPIURL = BASEURL + "loginGoogle"
    static let RESETAPIURL = BASEURL + "resetPassword"
    static let ADDSKILLSAPIURL = BASEURL + "addSkill"
    static let GETCATEGORIESAPIURL = BASEURL + "getCategories"
    static let POSTGIGAPIURL = BASEURL + "addGigPost"
    static let EDITGIGAPIURL = BASEURL + "updateGigPost"//"updateGigPostNew"
    static let EDITPROFILEAPIURL = BASEURL + "editUser"
    static let APIURL = BASEURL + "registerUser"
    static let USERRESPONSEKEY = "userResponse"
    static let ADDUSERCATEGORYAPIURL = BASEURL + "addUserCategory"
    static let ADDUSERSKILLAPIURL = BASEURL + "addSkill"
    static let GETALLGIGGSAPIURL = BASEURL + "getAllGigPosts"
    static let SEARCHGIGGSAPIURL = BASEURL + "searchGigPosts"
    static let GETUSERGIGGSPOSTS = BASEURL + "getUserGigPosts"
    static let ACTIVEGIGPOSTS = BASEURL + "activeGigPosts"
    static let DEACTIVEGIGPOSTS = BASEURL + "deActiveGigPosts"
    static let getAllSellers = BASEURL + "getAllSellers"
    static let SENDCONTRACTAPIURL = BASEURL + "sendContract"
    static let PUBLICUSERPROFILEAPIURL = BASEURL + "showUserProfile"
    static let ShOWALLNOTIFICATIONAPIURL = BASEURL + "showAllNotifications"
    static let COMPLETEANDPAY = BASEURL + "CompleteAndPay"
    static let CONTACTRESPONSEAPIURL = BASEURL + "gigRequestResponse"
    static let GETUNREADNOTIFICATIONSAPIURL = BASEURL + "getUnReadNotifications"
    static let SETREADNOTIFICATIONSAPIURL = BASEURL + "readNotification"
    static let POSTAGAINSTPOSTAPIURL = BASEURL + "ApplyAgainstGigPost"
    static let availableForGigsAPIURL = BASEURL + "availableForGigs"
    static let showGigPostDetailAPIURL = BASEURL + "showGigPostDetail"
    static let getConversationAPIURL = BASEURL +  "getConversation"
    static let getChatInboxAPIURL = BASEURL +  "chatInbox"
    static let getChatAPIURL = BASEURL +  "chat"
    static let getNewConverstationAPIURL = BASEURL +  "getNewConverstation"
    static let getBuyerUnCompletedGigPostsAPIURL = BASEURL +  "getBuyerUnCompletedGigPosts"
    static let showGigPostsOnSellerScreenAPIURL = BASEURL +  "showGigPostsOnSellerScreen"
    static let sellerCompleteGigPostResponseAPIURL = BASEURL +  "sellerCompleteGigPostResponse"
    static let getUserPaymentDetailsAPIURL = BASEURL +  "getUserPaymentDetails"
    static let addUserStripeAPIURL = BASEURL +  "addUserStripe"
    static let CompleteAndPayAPIURL = BASEURL +  "CompleteAndPay"
    static let RentAPIURL = BASEURL +  "rent"
    static let activeGigURL = BASEURL +  "activeGig"
    static let UpdateGigURL = BASEURL +  "updateGigPost"//updateGigPost
    static let ALLUSERRATING = BASEURL +  "getAllUserRatings"
    static let filterGigPosts = BASEURL + "filterGigPosts"



    //Google APIs
    static let googleMapsApiKey = "AIzaSyAGDOc8RfuQFrWkNuvQK6PwsM0Hw8Ll820"
    static let googlePlacesClient = "AIzaSyAGDOc8RfuQFrWkNuvQK6PwsM0Hw8Ll820"


}
