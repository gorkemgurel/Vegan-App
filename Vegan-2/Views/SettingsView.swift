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
        if #available(iOS 16.0, *) {
            SettingsView16()
        } else {
            SettingsView15()
        }
    }
}

@available(iOS 16.0, *)
struct SettingsView16: View {
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

struct SettingsView15: View {
    var body: some View {
        NavigationView {
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
