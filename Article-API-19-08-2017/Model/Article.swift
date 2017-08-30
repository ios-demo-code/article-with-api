//
//  Article.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    var id:Int?
    var title:String?
    var description:String?
    var category:Category?
    var image:String?
    
    init() {
        self.category = Category()
    }
    required init?(map: Map) {}
    func mapping(map: Map) {
        id          <- map["ID"]
        title       <- map["TITLE"]
        description <- map["DESCRIPTION"]
        category    <- map["CATEGORY"]
        image       <- map["IMAGE"]
    }
}


class Category: Mappable {
    var id:Int?
    var name:String?
    init() {
        
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id      <- map["ID"]
        name    <- map["NAME"]
    }
}
