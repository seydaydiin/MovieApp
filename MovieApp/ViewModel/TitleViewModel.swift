//
//  TitleViewModel.swift
//  MovieApp
//
//  Created by Şeyda Aydın on 30.10.2024.
//

import Foundation
import Alamofire

class TitleViewModel: ObservableObject {
    
    @Published var titles: [Title] = [] // Başlangıç değeri boş dizi oluşturduk
    @Published var trailer: VideoElement? // Başlangıç değeri nil verdik
    @Published var error: Error? // Hata durumu

    private var currentPage = 1
    private var isLoading = false
    
    struct Constants {
        static let API_KEY = "1d18770072c232dcbe419007ae0ee2e3"
        static let baseURL = "https://api.themoviedb.org"
        static let YoutubeAPI_KEY = "AIzaSyDCeldJuMIMTLeLvtzlSlqu4fE5yvukfWQ"
        static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
        static let popularMoviesEndpoint = "/3/movie/popular"
    }
    
    func fetchMovies() {
        guard !isLoading else { return } // Zaten yükleniyorsa çık
        
        isLoading = true
        let url = "\(Constants.baseURL)\(Constants.popularMoviesEndpoint)?language=en-US&page=\(currentPage)&api_key=\(Constants.API_KEY)"
        
        // Alamofire ile API çağrısı yaptık
        AF.request(url)
            .validate() // HTTP yanıtını doğruladık
            .responseDecodable(of: TitleResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let titleResponse):
                    self.titles.append(contentsOf: titleResponse.results) // Yeni başlıkları ekledik
                    self.currentPage += 1 // Sonraki sayfaya geçtik
                case .failure(let error):
                    self.error = error // Hata durumunu ayarladık
                }
                self.isLoading = false // Yükleme tamamlandı
            }
    }
    
    func getMovie(with query: String) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let url = "\(Constants.YoutubeBaseURL)q=\(query)&type=video&key=\(Constants.YoutubeAPI_KEY)"
        
        // Youtube API çağrısı
        AF.request(url)
            .validate() // HTTP yanıtını doğrula
            .responseDecodable(of: YoutubeSearchResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let results):
                    // Belirli bir video ID'sine göre video seçimi
                    if let videoElement = results.items.first(where: { $0.id.kind == "youtube#video" }) {
                        self.trailer = videoElement // Video öğesini ayarla
                    } else {
                        print("No valid videos found")
                    }
                case .failure(let error):
                    self.error = error // Hata durumunu ayarla
                    print("Error fetching video: \(error)")
                }
            }
    }
}

