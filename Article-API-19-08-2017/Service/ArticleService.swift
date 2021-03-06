//
//  ArticleService.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import Foundation
import Alamofire


class ArticleService {
    
    var article_get_url = "http://174.138.20.101:15000/v1/api/articles"
    var articel_post_url = "http://174.138.20.101:15000/v1/api/articles"
    var upload_image_url = "http://174.138.20.101:15000/v1/api/uploadfile/single"
    var article_put_url = "http://174.138.20.101:15000/v1/api/articles/"
    var article_delete_url = "http://174.138.20.101:15000/v1/api/articles/"
    var delegate:ArticleServiceProtocol?
    
    let headers = [
        "Content-Type":"application/json",
        "Accept":"application/json",
        "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
    ]
    
    //--------- Get Article ----------------
    func getArticles(page:Int, limit:Int) {
       
        var articles = [Article]()
        
        /*
        let request_url = "\(article_get_url)?page=\(page)&limit=\(limit)"
        let url = URL(string: request_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (
            data, response, error) in
            if error == nil {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]{
                    let objects = json["DATA"] as! NSArray
                    for obj in objects {
                        articles.append(Article(JSON: obj as! [String:Any])!)
                    }
                    self.delegate?.responseArticle(articles)
                }
                
            }
        }
        task.resume() */
        
        // ------ With Alamofire --------------
        
        Alamofire.request("\(article_get_url)?page=\(page)&limit=\(limit)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                    let objects = json["DATA"] as! NSArray
                    for obj in objects {
                        articles.append(Article(JSON: obj as! [String:Any])!)
                    }
                    self.delegate?.responseArticle(articles)
                }
            }
        }
        
    }
    //------- insert / update article ---------
    func insertUpdateArticle(article:Article, img:Data) {
        /*
        let url = URL(string: upload_image_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var formData = Data()
        
        let imageData = img
        let mimeType = "image/jpeg"
        formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        formData.append("Content-Disposition: form-data; name=\"FILE\"; filename=\"Image.png\"\r\n".data(using: .utf8)!)
        formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        formData.append(imageData)
        formData.append("\r\n".data(using: .utf8)!)
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = formData
        
        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: formData) { (data, response, error) in
            if error == nil {
                print("SUCCESS")
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]{
                    let image_url = json["DATA"] as! String
                    article.image = image_url
                    if article.id == 0 {
                        self.insertArticle(article: article)
                    }else {
                        self.updateArticle(article: article)
                    }
                }
                
            }
        }
        task.resume()*/
        
        //-------- With Alamofire --------------
        
        Alamofire.upload(multipartFormData: { (multipart) in
            multipart.append(img, withName: "FILE", fileName: ".jpg", mimeType: "image/jpeg")
        }, to: upload_image_url,method:.post,headers:headers) { (encodingResult) in
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _ , streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if let data = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                        let image_url = data["DATA"] as! String
                        article.image = image_url
                        if article.id == 0 {
                            self.insertArticle(article: article)
                        }else {
                            self.updateArticle(article: article)
                        }
                    }
                })
            case .failure(let error):
                print(error)
            }
        }

    }
    
    //------- insert article ------------
    func insertArticle(article:Article) {
        let newData:[String:Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": article.image!
        ]
        /*
        let url = URL(string: articel_post_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: newData, options: [])
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                self.delegate?.responseMessage("Insert Succesfully!")
            }
        }
        task.resume()*/
 
        // ------ With Alamofire --------
        Alamofire.request(articel_post_url, method: .post, parameters: newData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.responseMessage("Insert Successfully!")
            }
        }
    }
    //------- update article ------------
    func updateArticle(article:Article) {
        let newData:[String:Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": article.image!
        ]
        /*
        let url = URL(string: "\(article_put_url)\(article.id!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: newData, options: [])
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                self.delegate?.responseMessage("Update Succesfully!")
            }
        }
        task.resume()*/
        
        // ---- With Alamofire ------------
        Alamofire.request("\(article_put_url)\(article.id!)", method: .put, parameters: newData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.responseMessage("Update Successfully!")
            }
        }
        
    }
    //------- delete article ------------
    func deleteArticle(id:Int) {
        /*
        let url = URL(string: "\(article_delete_url)\(id)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                self.delegate?.responseMessage("Delete Succesfully!")
            }
        }
        task.resume()*/
        // ---- With Alamofire ------------
        
        Alamofire.request("\(article_delete_url)\(id)", method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.responseMessage("Delete Successfully!")
            }
        }
    }

}
