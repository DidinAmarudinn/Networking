import UIKit

let apiKey = "2174d146bb9c0eab47529b2e77d6b526"

struct Guest: Codable {
    let success: Bool
    let guestSessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionId = "guest_session_id"
    }
}

func getGuestSessionId(completion: ((Guest) -> ())?) {
    let url = "https://api.themoviedb.org/3/authentication/guest_session/new"
    var components = URLComponents(string: url)!
    
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey)
    ]
    
    let request = URLRequest(url: components.url!)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        if response.statusCode == 200 {
            let decoder = JSONDecoder()
            let result = try! decoder.decode(Guest.self, from: data)
            completion?(result)
        } else {
            print("ERROR: \(data), HTTP Status: \(response.statusCode)")
        }
        
    }
    task.resume()
}



getGuestSessionId { guest in
    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/610150/rating")!
    
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "guest_session_id", value: guest.guestSessionId)
    ]
    
    var request = URLRequest(url: components.url!)
    
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let reviewRequest = ReviewRequest(value: 10.0)
    let jsonData = try! JSONEncoder().encode(reviewRequest)
    
    let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        if response.statusCode == 201 {
            print("Data: \(data)")
        }
        
    }
    task.resume()
}


struct ReviewRequest: Codable {
    let value: Double
    
}
