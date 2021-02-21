//
//  GithubApi.swift
//  gitsearch
//
//  Created by Nodirbek Maksumov on 21/02/21.
//

import Foundation

class GithubApi
{
    let clientID = "1fb7cfe50603b10d19d3"
    let clientSecret = "7edb720da8232b126a8fd0851506be7ba77c784c"
    let deepLinkUrl = "com.maksumov.gitsearch://auth"
    
    func getAuthUrl() -> URL {
        // GET https://github.com/login/oauth/authorize?client_id
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)")
        return url!
    }
    
    func getCode(_ url: URL?) -> String? {
        // com.maksumov.gitsearch://auth?code={code}
        if let url = url, url.absoluteString.starts(with: deepLinkUrl),
           let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let codeQ = urlComponents.queryItems?.filter({ $0.name == "code" }),
           let code = codeQ.first {
            return code.value
        }
        
        return nil
    }
    
    
    func getToken(code: String) -> String? {
        // POST https://github.com/login/oauth/access_token?client_id&client_secret&code
        
    }
     

    /*
    func search(_ q: String, page: Int) -> Result<[Repo], Error> {
        return Result(catching: <#T##() throws -> _#>)
    }
     */
}

struct Repo {
    var name: String
    var author: String
}

