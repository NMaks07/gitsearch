//
//  RestError.swift
//  gitsearch
//
//  Created by Nodirbek Maksumov on 21/02/21.
//

import Foundation

enum RestError: LocalizedError, Equatable {
    case invalidResponse
    case invalidData
    case requestFailed
    case jsonParsingFailure(objAsString: String, httpStatus: Int, path: String?)
    case noResource
    case badURL
    case couldNotEscape
    case loginOrPasswordInvalid
    case needAuthorization
    case custom(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Невалидный ответ от сервера"
        case .invalidData: return "Полученные данные неверны"
        case .requestFailed: return "Неудачный запрос"
        case .jsonParsingFailure(let str, let status, let path): return "Не смог распарсить данные от сервера \n respAsString \(str)\n httpStatus \(status)\n path \(String(describing: path))"
        case .noResource: return "Похоже ссылки невалидны"
        case .badURL: return "Не могу создать ссылку"
        case .couldNotEscape: return "Could not escape the URL value."
        case .loginOrPasswordInvalid: return "Логин или пароль невалидны"
        case .needAuthorization: return "Вы не авторизированы"
            
        // для других ошибок будем использовать кустарный тип ошибки
        case .custom(let message): return message
        }
    }
}
