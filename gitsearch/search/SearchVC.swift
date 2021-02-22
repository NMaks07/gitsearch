//
//  SearchVC.swift
//  gitsearch
//
//  Created by Nodirbek Maksumov on 22/02/21.
//

import UIKit
import Kingfisher

class SearchVC: UIViewController {

    var gitApi = GithubApi()
    var results: SearchResult!
    
    @IBOutlet weak var exitBtn: UIButton!{
        didSet{
            exitBtn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var inputFld: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!{
        didSet{
            searchBtn.addTarget(self, action: #selector(self.pressSearch), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var listTbl: UITableView!{
        didSet{
            listTbl.dataSource = self
        }
    }
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //@objc fun
    
    @objc func pressSearch(){
        doSearch(str: inputFld.text)
    }
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    func doSearch(str: String?){
        guard str != nil else {
            return
        }
        gitApi.search(str!, perPage: 40, page: 1) { [weak self](result) in
            switch result {
            case .success(let resultFromGitServer):
                self?.results = resultFromGitServer
                
                DispatchQueue.main.async {
                    self?.listTbl.reloadData()
                }
                
            case .failure(let err):
                DispatchQueue.main.async {
                    let av = UIAlertController(title: "ошибка", message: err.localizedDescription, preferredStyle: .alert)
                    av.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(av, animated: true, completion: nil)

                }
            }
        }
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let imgUrl = URL(string: results?.items?[indexPath.row].owner?.avatar_url ?? "")
        cell.imageView?.kf.setImage(with: imgUrl)
        cell.textLabel?.text = results?.items?[indexPath.row].full_name ?? ""
        cell.detailTextLabel?.text = results?.items?[indexPath.row].language ?? ""
        return cell
    }
}
