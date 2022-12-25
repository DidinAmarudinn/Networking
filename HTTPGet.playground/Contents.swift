import UIKit

let apiKey = "2174d146bb9c0eab47529b2e77d6b526"
let language = "en-US"
let page = "1"

var components = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")!

components.queryItems = [
    URLQueryItem(name: "api_key", value: apiKey),
    URLQueryItem(name: "language", value: language),
    URLQueryItem(name: "page", value: page)
]

let request = URLRequest(url: components.url!)

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let response = response as? HTTPURLResponse else { return }
    
    if let data = data {
        if response.statusCode == 200 {
            decodeJson(from: data)
        } else {
            print("Error: \(data), HTTP Status: \(response.statusCode)")
        }
    }
    
}

task.resume()



func decodeJson(from data: Data) {
    let decoder = JSONDecoder()
    if let moviesRes = try? decoder.decode(MovieResponse.self, from: data) as MovieResponse {
        print("Page \(moviesRes.page)")
        print("Total Result \(moviesRes.totalResults)")
        print("Total Page \(moviesRes.totalPages)")
        moviesRes.movies.forEach { movie in
            print("Movie Title: \(movie.title), with Release Date: \(movie.releaseDate) and with Poster Path: \(movie.posterPath)")
        }
    } else {
        print("Error: Can't Decode Json")
    }
    
}





struct MovieResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [Movie]
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let voteAverage: Double
    let overview: String
    let releaseDate: Date
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // MARK: Menentukan alamat gambar.
        let path = try container.decode(String.self, forKey: .posterPath)
        posterPath = "https://image.tmdb.org/t/p/w300/\(path)"
        
        
        // MARK: Menentukan tanggal rilis.
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        releaseDate = dateFormatter.date(from: dateString)!
        
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        overview = try container.decode(String.self, forKey: .overview)
    }
}
