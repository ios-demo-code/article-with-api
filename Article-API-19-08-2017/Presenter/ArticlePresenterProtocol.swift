//
//  ArticlePresenterProtocol.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import Foundation


protocol ArticlePresenterProcotol {
    func responseArticle(articles:[Article])
    func responseMessage(msg:String)
}
