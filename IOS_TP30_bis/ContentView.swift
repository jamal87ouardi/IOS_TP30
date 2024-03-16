import SwiftUI

struct Product: Decodable {
    let name: String
    let price: Double
    let haveFPC: Bool
    let image: String
}

struct ContentView: View {
    
    @State private var products = [Product]()

    var body: some View {
       
            List(products, id: \.name) { product in
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.headline)
                    Text("\(product.price) MAD")
                        .font(.subheadline)
                    Text(product.haveFPC ? "Supporte la reconnaissance faciale" : "Ne supporte pas la reconnaissance faciale")
                        .font(.subheadline)
                    AsyncImage(url: URL(string: product.image)!) { image in
                                           image.resizable()
                                               .aspectRatio(contentMode: .fit)
                                               .frame(width: 100, height: 100)
                                       } placeholder: {
                                           ProgressView()
                                       }
                    
                }
            }
            .onAppear {
                fetchProducts()
            }
        
    }

    func fetchProducts() {
        guard let url = URL(string: "https://run.mocky.io/v3/93f299af-bda9-47ec-a2e1-d62d93b667f2") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Erreur lors de la récupération des données:", error)
                return
            }

            guard let data = data else {
                print("Aucune donnée reçue de l'API")
                return
            }

            do {
                                
                self.products = try JSONDecoder().decode([Product].self, from: data)
                
            } catch {
                print("Erreur de décodage des données:", error)
            }
        }.resume()
    }
}



