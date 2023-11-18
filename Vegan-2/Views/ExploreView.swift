//
//  ExploreView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 30.07.2023.
//

import Foundation
import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var recipeStore = RecipeStore.shared
    @ObservedObject var exploreViewModel: ExploreViewModel
    
    @State var readyToNavigateToRecipe = false
    @State private var searchText = ""
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ExploreView16(recipeStore: recipeStore, exploreViewModel: exploreViewModel, searchText: searchText)
        } else {
            ExploreView15(recipeStore: recipeStore, exploreViewModel: exploreViewModel, searchText: searchText)
        }
    }
}

@available(iOS 16.0, *)
struct ExploreView16: View {
    //@State private var searchText = ""
    @ObservedObject var recipeStore = RecipeStore.shared
    @ObservedObject var exploreViewModel: ExploreViewModel
    @State var searchText: String
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(width: 0, height: 0)
                    TextField(" Search", text: $searchText)
                        .frame(height: 4)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 2) {
                        ForEach(exploreViewModel.recipes.indices, id: \.self) { index in
                            let recipeID = exploreViewModel.recipes[index].recipeID
                            ZStack {
                                if let coverImage = recipeStore.uniqueRecipes[recipeID]?.coverPhoto {
                                    NavigationLink(value: recipeID) {
                                        Image(uiImage: coverImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                            .clipped()
                                    }
                                }
                            }
                            .onAppear {
                                Task {
                                    print("Appeared!")
                                    await exploreViewModel.downloadAndAssignCoverPhoto(for: recipeID)
                                    //await recipeStore.downloadAndAssignCoverPhoto(for: recipeID)
                                    //await recipeStore.downloadAndAssignCoverImage(for: recipeID)
                                }
                            }
                        }
                    }
                }
            }.navigationDestination(for: String.self) { value in
                RecipeView(recipeViewModel: RecipeViewModel(recipeID: value))
            }/*.onAppear {
              exploreViewModel.fetchRecipesForExplore(count: 15)
              }*/
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
        }
    }
}

struct ExploreView15: View {
    //@State private var searchText = ""
    @ObservedObject var recipeStore = RecipeStore.shared
    @ObservedObject var exploreViewModel: ExploreViewModel
    @State var searchText: String
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(width: 0, height: 0)
                    TextField(" Search", text: $searchText)
                        .frame(height: 4)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 2) {
                        ForEach(exploreViewModel.recipes.indices, id: \.self) { index in
                            let recipeID = exploreViewModel.recipes[index].recipeID
                            ZStack {
                                if let coverImage = recipeStore.uniqueRecipes[recipeID]?.coverPhoto {
                                    NavigationLink(destination: RecipeView(recipeViewModel: RecipeViewModel(recipeID: recipeID))) {
                                        Image(uiImage: coverImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                            .clipped()
                                    }
                                }
                            }
                            .onAppear {
                                Task {
                                    print("Appeared!")
                                    await exploreViewModel.downloadAndAssignCoverPhoto(for: recipeID)
                                    //await recipeStore.downloadAndAssignCoverPhoto(for: recipeID)
                                    //await recipeStore.downloadAndAssignCoverImage(for: recipeID)
                                }
                            }
                        }
                    }
                }
            }/*.onAppear {
              exploreViewModel.fetchRecipesForExplore(count: 15)
              }*/
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
        }
    }
}
