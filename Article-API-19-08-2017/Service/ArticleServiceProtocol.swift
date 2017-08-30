//
//  ArticleServiceProtocol.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import Foundation

protocol ArticleServiceProtocol {
    func responseArticle(_ article:[Article])
    func responseMessage(_ msg:String)
}
