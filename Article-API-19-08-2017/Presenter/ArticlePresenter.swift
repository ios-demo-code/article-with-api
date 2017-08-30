//
//  ArticlePresenter.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import Foundation

class ArticlePresenter {
    var delegate:ArticlePresenterProcotol?
    var articleService:ArticleService?
    
    init() {
        self.articleService = ArticleService()
        self.articleService?.delegate = self
    }
    func getArticle(page:Int, limit:Int) {
        self.articleService?.getArticles(page: page, limit: limit)
    }
    func insertUpdateArticle(article:Article, img:Data) {
        self.articleService?.insertUpdateArticle(article: article, img: img)
    }
    func deleteArticle(id:Int) {
        self.articleService?.deleteArticle(id: id)
    }
    
}

extension ArticlePresenter:ArticleServiceProtocol {
    func responseArticle(_ article: [Article]) {
        self.delegate?.responseArticle(articles: article)
    }
    
    func responseMessage(_ msg: String) {
        self.delegate?.responseMessage(msg: msg)
    }
}
