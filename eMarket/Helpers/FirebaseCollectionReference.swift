//
//  FirebaseCollectionReference.swift
//  eMarket
//
//  Created by Xieheng on 2020/01/27.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

