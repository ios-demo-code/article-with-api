//
//  ViewController.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/19/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var articlePresenter:ArticlePresenter?
    var articles:[Article]?
    var refreshControl:UIRefreshControl?
    var n = 1
    var newFetchBool = 0
    var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        self.articles = [Article]()
        self.articlePresenter = ArticlePresenter()
        self.articlePresenter?.getArticle(page: 1, limit: 15)
        self.articlePresenter?.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (articles?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        cell.configureCell(article: (articles?[indexPath.row])!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetchBool = 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetchBool = newFetchBool + 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate && newFetchBool >= 1 && scrollView.contentOffset.y >= 0 {
            tableView.layoutIfNeeded()
            n = n + 1
            self.tableView.tableFooterView = indicatorView
            self.tableView.tableFooterView?.isHidden = false
            self.tableView.tableFooterView?.center = indicatorView.center
            self.indicatorView.startAnimating()
            self.articlePresenter?.getArticle(page: self.n, limit: 15)
            newFetchBool = 0
        }else if !decelerate {
            newFetchBool = 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let article = self.articles?[indexPath.row]
            self.performSegue(withIdentifier: "ShowEdit", sender: article)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            let id = self.articles?[indexPath.row].id
            print(id!)
            self.articlePresenter?.deleteArticle(id: id!)
        }
        return [edit, delete]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEdit" {
            let dest = segue.destination as! AddEditViewController
            dest.detailArticle = sender as? Article
        }
    }
    
    func refreshData() {
        n = 1
        self.articlePresenter?.getArticle(page: n, limit: 15)
    }
   
}

extension ViewController:ArticlePresenterProcotol{
    func responseArticle(articles: [Article]) {
        print(articles)
        if n == 1 {
            self.articles = []
            self.refreshControl?.endRefreshing()
        }
        self.articles = self.articles! + articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
        }
       
        
    }
    func responseMessage(msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

