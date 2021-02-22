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
    
    func handleAuth(code: String) {
        print("auth code", code)
        self.presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.githubApi.getToken(code: code) { result in
                switch result {
                case .success(let token):
                    print("auth token", token)
                    UserDefaults.standard.set(token, forKey: "token")
                    DispatchQueue.main.async {
                        let sv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "sv") as SearchVC
                        sv.modalPresentationStyle = .fullScreen
                        self?.present(sv, animated: true, completion: nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "ошибка", message: "ошибка авторизации токен не получен", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(ac, animated: true, completion: nil)
                    }
                    print(error)
                }
            }
        }
    }
}
