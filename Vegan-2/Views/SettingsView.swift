//
//  SettingsView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 3.09.2023.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Hesap Ayarları")) {
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "person")
                            Text("Hesabım")
                        }
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Ülke")
                        }
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "globe.asia.australia.fill")
                            Text("Dil")
                        }
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "heart.fill")
                            Text("Beğenilenler")
                        }
                    }
                    Section(header: Text("Destek")) {
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "ellipsis.message")
                            Text("Bize Bildir")
                        }
                        NavigationLink(destination: Text("Detail View for Item 1")) {
                            Image(systemName: "heart.fill")
                            Text("SSS")
                        }
                    }
                }
            }
        }
    }
}

struct Previews_SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
