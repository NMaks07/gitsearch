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
    
    
    func getToken(code: String, onComplete: @escaping (Result<String, Error>)->Void) {
        // POST https://github.com/login/oauth/access_token?client_id&client_secret&code
        
        var urlComponents = URLComponents(string: "https://github.com/login/oauth/access_token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code)
        ]
        
        var rq = URLRequest(url: urlComponents.url!)
        rq.httpMethod = "POST"
        rq.addValue("application/json", forHTTPHeaderField: "Accept")
        rq.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: rq) { (data, urlResponse, error) in
            guard error == nil  else {
                onComplete(.failure(error!))
                return
            }
            
            guard data != nil else {
                onComplete(.failure(RestError.invalidData))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                onComplete(.failure(RestError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    
                    struct responseObj: Codable {
                        var access_token: String
                    }
                    
                    let dataFromServer =  try JSONDecoder().decode(responseObj.self, from: data!)
                    onComplete(.success(dataFromServer.access_token))
                } catch {
                    let responseStr = String(data: data!, encoding: .utf8) ?? ""
                    let err = RestError.jsonParsingFailure(objAsString: responseStr, httpStatus: httpResponse.statusCode, path: rq.url?.path)
                    onComplete(.failure(err))
                    
                }
            default:
                let err = RestError.custom(message: "запрос не удался, код статуса ответа: \(httpResponse.statusCode)")
                onComplete(.failure(err))
            }
            
        }
        
        task.resume()
    }

    
    func search(_ q: String, page: Int, onComplete: @escaping (Result<[Repo], Error>)->Void) {
        //GET /search/repositories

        //return Result(catching: <#T##() throws -> _#>)
    }
    
}

struct Owner: Codable {
    var avatar_url: String
}

struct Repo: Codable {
    var full_name: String
    var owner: Owner
    var language: String
}

class SearchResult: Codable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [Repo]
}
