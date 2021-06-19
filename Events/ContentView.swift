//
//  ContentView.swift
//  Events
//
//  Created by Preston Kemp on 6/19/21.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Events: Codable {
    var events: [Event]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Event: Codable {
    var date: String
    var id : Int
    var title: EventTitle
    var status: String
}

struct EventTitle: Codable {
    var rendered: String
}

struct ContentView: View {
    @State var results = [Result]()
    @State var events = [Event]()
    
    var body: some View {
        List(events, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(item.title.rendered)
                    .font(.headline)
                Text(item.date)
                    .font(.footnote)
            }
        }
        .onAppear(perform: {
            getEvents()
        })
    }
    
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url:url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func getEvents() {
        guard let url = URL(string: "https://freemomhugs.org/wp-json/wp/v2/event") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url:url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
                    DispatchQueue.main.async {
                        self.events = decodedResponse
                    }
                    
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
