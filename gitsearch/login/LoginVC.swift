//
//  LoginVC.swift
//  gitsearch
//
//  Created by Nodirbek Maksumov on 21/02/21.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {

    let githubApi = GithubApi()

    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.addTarget(self, action: #selector(self.openSafari), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func openSafari(){
        let options = SFSafariViewController.Configuration()
        options.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: githubApi.getAuthUrl(), configuration: options)
        self.present(vc, animated: true, completion: nil)
    }
}
