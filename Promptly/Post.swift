//
//  Post.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/31/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Post: Identifiable {
    var id: String
    var text: String
    var timestamp: Timestamp
    var like_count: Int32
}

