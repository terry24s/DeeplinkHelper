//
//  DeeplinkHelper.swift
//  
//
//  Created by Terry TAN on 11/06/2021.
//

import Foundation

public class DeeplinkHelper {
    let scheme: String = "sevres24"
    
    public func getDeeplinkURL(_ urlStr: String) -> URL? {
        guard let url = URL(string: urlStr), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        var queryItems = [String: String]()
        if let items = components.queryItems {
            for item in items {
                if let value = item.value {
                    queryItems[item.name] = value
                }
            }
        }
        
        /// First we get all the paths of the url in an array
        var pathArray = components.path.components(separatedBy: "/").filter { !$0.isEmpty }

        /// Before doing anything, we'll check that the url contains something else
        guard pathArray.count > 1,
            let context = pathArray.first?.components(separatedBy: "-"),
            context.count > 1 else {
            return nil
        }
        
        let locale = context[0]
        let countryCode = context[1].lowercased()
        
        /// After processing the country / language we remove it from the paths array
        pathArray.removeFirst()
        
        guard let link = parsePaths(pathArray, queryItems: queryItems, locale: locale, countryCode: countryCode) else {
            return nil
        }
        return link
    }

    private func parsePaths(_ paths: [String], queryItems: [String:String], locale: String, countryCode: String) -> URL? {
        guard let mainPath = paths.first else {
            return generateDeeplink(.home)
        }
        
        switch mainPath {
        case "women", "men", "femme", "homme":
            let subPaths = Array(paths.dropFirst())
            return parseSubPaths(
                subPaths,
                queryItems: queryItems,
                universe: mainPath,
                locale: locale,
                countryCode: countryCode
            )
            
        default:
            if paths.count == 1 {
                // Check if it is PDP, e.g.: veste-en-denim-palm-angels_PAG337E2BLUMZZZS00
                let elements = mainPath.split(separator: "_")
                if elements.count == 2 {
                    let sku = String(elements.last!)
                    return generateDeeplink(.product, with: [.modelSku: sku])
                }
            }
        }
        
        return nil
    }

    private func parseSubPaths(_ paths: [String], queryItems: [String: String], universe: String, locale: String, countryCode: String) -> URL? {
        guard let mainPath = paths.first else { return nil }
        
        switch mainPath {
        case "brands", "marques":
            if !paths.isEmpty {
                let brandName = paths[1]
                let brandCode: String = "\(Universe(rawValue: universe).rawValue)_\(brandName.replacingOccurrences(of: "-", with: "_"))".lowercased()
                return generateDeeplink(.onlineBrand, with: [.code: brandCode])
            }
            else {
                return generateDeeplink(.brands)
            }
            
        case "events", "evenements":
            let pathsEvent = paths.prefix(2)
            let eventPath = "/\(universe)/\(pathsEvent.joined(separator: "/"))"
            let params: [DeeplinkKey: String] = [.path: eventPath]
    
            return generateDeeplink(.events, with: params)
            
        default:
            // Could be PLP
            let categoryPath = "\(universe)/\(paths.joined(separator: "/"))"
            let params: [DeeplinkKey: String] = [.categoryPath: categoryPath, .locale: locale]
    
            return generateDeeplink(.productsList, with: params)
        }
    }
    
    func generateDeeplink(_ pageType: DeeplinkPageType, with params: [DeeplinkKey: String]? = nil) -> URL? {
        var deeplink = "\(scheme)://\(pageType.rawValue)"
        
        if let params = params {
            let extraParams = params
                .compactMap { param in
                    guard let value = param.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
                    return "\(param.key.rawValue)=\(value)"
                }
                .joined(separator: "&")
        
            deeplink += "?\(extraParams)"
        }
        
        return URL(string: deeplink)
    }
}
