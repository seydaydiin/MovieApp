//
//  TitleListView.swift
//  MovieApp
//
//  Created by Şeyda Aydın on 30.10.2024.
//

import SwiftUI

struct TitleListView: View {
    
    @StateObject private var viewModel = TitleViewModel() // ViewModel'i oluştur

    var body: some View {
        NavigationView {
            VStack(spacing: 16) { // Boşluk eklemek için spacing kullandık
                Text("Popular Movies") // Başlığı burada gösterdik
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TitleColor")) // Altın rengi
                    .padding(.top, 20) // Üstten boşluk
                    .padding(.bottom, 10) // Aşağıdan boşluk

                List {
                    ForEach(viewModel.titles.sorted(by: { $0.vote_average > $1.vote_average }), id: \.id) { title in
                        NavigationLink(destination: TitleDetailView(title: title)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(title.original_title ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold) // Kalın yazı
                                        .lineLimit(1) // Tek satırda gösterdik
                                    
                                    HStack {
                                        Image(systemName: "star.fill") // Yıldız simgesi
                                            .foregroundColor(Color("TitleColor")) // Altın rengi
                                            .font(.system(size: 14))
                                        Text("\(title.vote_average, specifier: "%.1f")")
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 8) // Elemanlar arası boşluk
                                
                                Spacer() // Sağ tarafta boşluk bıraktık
                            }
                        }
                        .onAppear {
                            // Son eleman görünür olduğunda yeni filmleri yükledik
                            if title.id == viewModel.titles.last?.id { // title'ın ID'sini karşılaştırdık
                                viewModel.fetchMovies()
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Liste stilini düz yaptık
            }
            .navigationBarTitleDisplayMode(.inline) // Başlık ayarını yaptık
            .navigationBarHidden(true) // Varsayılan navigation bar'ı gizledik
        }
        .onAppear {
            // İlk sayfayı yükledik
            if viewModel.titles.isEmpty {
                viewModel.fetchMovies()
            }
        }
    }
}

#Preview {
    TitleListView()
}
