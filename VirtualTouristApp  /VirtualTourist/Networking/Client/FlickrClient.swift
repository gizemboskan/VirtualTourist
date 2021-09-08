//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Gizem Boskan on 4.09.2021.
//

import Foundation

class FlickrClient {
    static let apiKey = "76281e20a6bf25c271087027ff23b70d"
    
    private class func flickrURLComponents(endPoint: EndPoint, additionalParameters: [String:String] = [:]) -> URLComponents {
        
        var components = URLComponents(string: Endpoints.base)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": FlickrClient.apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        for (key, value) in additionalParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        return components
    }

    private class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        DispatchQueue.main.async(qos: .utility) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                
                print(String(decoding: data, as: UTF8.self))
                
                let decoder = JSONDecoder()
                
                do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    completion(responseObject, nil)
                } catch {
                    
                    completion(nil, error)
                }
            }
            task.resume()
        }
        
    }
    
    class func getFlickrPhotos(page: Int, latitude: String, longitude: String, completion: @escaping (_ category: FlickrPhotosInfoResponse?, Error?) -> Void) {
        
        var additionalParameters = [
            "extras" : "date_taken,geo,license,machine_tags,owner_name,url_z,views"
        ]
        
        additionalParameters["lat"] = latitude
        additionalParameters["lon"] = longitude
        additionalParameters["radius"] = "0.5"
        additionalParameters["per_page"] = "9"
        additionalParameters["page"] = String(page)
        
        
        let urlComponent = flickrURLComponents(endPoint: EndPoint.locationPhotos, additionalParameters: additionalParameters)
        guard let url = urlComponent.url else {  return }
        taskForGETRequest(url: url, responseType: FlickrPhotosInfoResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }    
}


