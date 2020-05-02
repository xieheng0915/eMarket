//
//  Constants.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/05.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import Foundation

enum Constats {
    static let publishableKey = "pk_test_V0GQVUGZQLqQMP0u5rMZzF5c00px8GUcS0"
    static let baseURLString = "http://localhost:3000/"
    static let defaultCurrency = "jpy"
    static let defaultDescription = "Purchase from eMarket"
}

// IDS and Keys
public let kFILEREFERENCE = "gs://emarket-1de53.appspot.com/"
public let kALGOLIA_APP_ID = "DYP2CACN2K"
public let kALGOLIA_SEARCH_KEY = "a986f784759ed58228b456ac115ee01e"
public let kALGOLIA_ADMIN_KEY = "bcc2629f4d7ce8d29ff24fcc2d04376c"


//Firebase Headers
public let kUSER_PATH = "User"
public let kCATEGORY_PATH = "Category"
public let kITEMS_PATH = "Items"
public let kBASKET_PATH = "Basket"

//Category
public let kNAME = "name"
public let kIMAGENAME = "imageName"
public let kOBJECTID = "objectId"

//Item
public let kCATEGORYID = "categoryId"
public let kDESCRIPTION = "description"
public let kPRICE = "price"
public let kIMAGELINKS = "imageLinks"

//Basket
public let kOWNERID = "ownerId"
public let kITEMIDS = "itemIds"

//User
public let kEMAIL = "email"
public let kFIRSTNAME = "firstName"
public let kLASTNAME = "lastName"
public let kFULLNAME = "fullName"
public let kCURRENTUSER = "currentUser"
public let kFULLADDRESS = "fullAddress"
public let kONBOARD = "onboard"
public let kPURCHASEDITEMIDS = "purchasedIds"

