//
//  TitleDetailView.swift
//  MovieApp
//
//  Created by Şeyda Aydın on 30.10.2024.
//

import SwiftUI
import WebKit

struct TitleDetailView: View {
    
    let title: Title
    @StateObject var viewModel = TitleViewModel()
    @State private var showWebView = false
    @State private var trailerURL: URL?
    
    struct WebView: UIViewRepresentable {
        let url: URL?
        
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            if let url = url {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let posterPath = title.poster_path {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(title.original_title ?? "")
                    .font(.system(size: 30, weight: .bold)) // Başlık boyutu ve kalınlığı ayarladık
                    .foregroundColor(Color("TitleColor")) // Altın rengi
                    .padding(.horizontal)
                
                if let overview = title.overview {
                    Text(overview)
                        .font(.body) // Yazı tipi
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                }
                
                Button(action: {
                    viewModel.getMovie(with: "\(title.original_title ?? "") trailer")
                }) {
                    Image(systemName: "play.circle.fill") // Oynatma simgesi
                        .font(.system(size: 30)) // Buton simgesi boyutu
                        .foregroundColor(.white) // Simge rengi
                        .frame(width: 50, height: 50) // Buton boyutu
                        .background(Color("TitleColor")) // Altın sarısı arka plan
                        .clipShape(Circle()) // Yuvarlak buton
                        .shadow(radius: 10) // Gölge efekti
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showWebView) {
                    if let url = trailerURL {
                        WebView(url: url)
                            .background(Color(.systemBackground)) // Ana arka plan rengi
                            .edgesIgnoringSafeArea(.all) // Tam ekran yap
                            .presentationDetents([.medium, .large]) // Yüksekliği ayarla
                            .presentationDragIndicator(.visible) // Sürükleme göstergesi
                    }
                }
            }
            .padding(.top, 20) // Üst boşluk
            .navigationTitle("") // Başlığı kaldır
        }
        .onReceive(viewModel.$trailer) { trailer in
            if let trailer = trailer {
                trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.id.videoId)")
                showWebView.toggle()
            } else {
            
            }
        }
    }
}

struct TvDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTvShow = Title(
            id: 1,
            media_type: "",
            original_name: "Sample TV Show",
            original_title: "Sample Title",
            poster_path: "/path/to/poster.jpg",
            overview: "Sample overview.",
            vote_count: 100,
            release_date: "2023-10-28",
            vote_average: 8.0
        )
        TitleDetailView(title: sampleTvShow)
    }
}
