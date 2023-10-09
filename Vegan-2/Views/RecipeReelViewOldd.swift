//
//  VerticalCarousel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 1.07.2023.
//

/*import Foundation
import SwiftUI
struct RecipeReelView: View {
    @StateObject var recipeViewModel = RecipeViewModel.shared
    @ObservedObject var userViewModel: UserViewModel
    @State private var selectedTab = 0
    @State var readyToNavigateToRecipe = false
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    let colors: [Color] = [.red, .green, .blue]
    
    init(userViewModel: UserViewModel) {
            self.userViewModel = userViewModel

            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white.opacity(0))]

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.overlay(
                    GeometryReader { geometry in
                        TabView(selection: $selectedTab) {
                            ForEach(recipeViewModel.recipes.indices, id: \.self) { index in
                                if let id = recipeViewModel.recipes[index].id {
                                    ZStack {
                                        if let coverImage = recipeViewModel.uniqueRecipes[id]?.coverPhoto {
                                            Image(uiImage: coverImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .rotationEffect(.degrees(-90))
                                        }
                                        else {
                                            Image(uiImage: UIImage())
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .rotationEffect(.degrees(-90))
                                        }
                                        Rectangle()
                                            .foregroundColor(Color.black.opacity(0.5))
                                            .frame(width: geometry.size.width, height: geometry.size.height / 4)
                                            .position(x: (geometry.size.height + safeAreaInsets.top) / 2, y: geometry.size.height * 0.875)
                                            .rotationEffect(.degrees(-90))
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                if let title = recipeViewModel.uniqueRecipes[id]?.title {
                                                    NavigationLink(value: id) {
                                                    Text("\(title)")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 1)
                                                        .padding(.top, 10)
                                                    }
                                                } else {
                                                    Text("")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 1)
                                                        .padding(.top, 10)
                                                }
                                                /*if let title = recipeViewModel.uniqueRecipes[id]?.title {
                                                    Text("\(title)")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 1)
                                                        .padding(.top, 10)
                                                        .onTapGesture {
                                                            readyToNavigateToRecipe = true
                                                        }
                                                        .navigationDestination(isPresented: $readyToNavigateToRecipe) {
                                                            RecipeView(recipeID: id)
                                                        }
                                                }*/
                                                /*else {
                                                    Text("HMMMMM")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 1)
                                                        .padding(.top, 10)
                                                }*/
                                                if let prepTime = recipeViewModel.uniqueRecipes[id]?.prepTime {
                                                    Label(prepTime + " dk.", systemImage: "clock")
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 10)
                                                }
                                                else {
                                                    Label("", systemImage: "clock")
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        .padding(.bottom, 10)
                                                }
                                                if let description = recipeViewModel.uniqueRecipes[id]?.description {
                                                    Text(description)
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                }
                                                else {
                                                    Text("")
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                }
                                                Spacer()
                                            }
                                            Spacer()
                                            VStack() {
                                                Button(action: {
                                                    userViewModel.toggleLike(for: id)
                                                }) {
                                                    if let likedRecipes = userViewModel.likedRecipes {
                                                        if (likedRecipes.contains(id)) {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundColor(.red)
                                                                .font(.title)
                                                        }
                                                        else {
                                                            Image(systemName: "heart")
                                                                .font(.title)
                                                        }
                                                    }
                                                    /*if (userViewModel.user.likedRecipes.contains(id)) {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundColor(.red)
                                                            .font(.title)
                                                    }
                                                    else {
                                                        Image(systemName: "heart")
                                                            .font(.title)
                                                    }*/
                                                }
                                                .padding(.trailing)
                                                .padding(.top, 30)
                                                .padding(.bottom, 10)
                                            }
                                        }.frame(width: geometry.size.width, height: geometry.size.height / 4)
                                            .position(x: (geometry.size.height + safeAreaInsets.top) / 2, y: geometry.size.height * 0.875)
                                            .rotationEffect(.degrees(-90))
                                    }.onAppear {
                                        Task {
                                            await recipeViewModel.downloadAndAssignCoverImage(for: id)
                                        }
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .rotationEffect(.degrees(90))
                        .frame(width: geometry.size.height, height: geometry.size.width)
                        .offset(x: (geometry.size.width - geometry.size.height) / 2, y: (geometry.size.height - geometry.size.width) / 2)
                        .onChange(of: selectedTab) { newIndex in
                            if newIndex == recipeViewModel.recipes.count - 2 {
                                //print("Reached the last tab!")
                                recipeViewModel.fetchRecipes(count: 3)
                            }
                        }
                    }
                )
            }.ignoresSafeArea(edges: .top)
                .navigationDestination(for: String.self) { value in
                    RecipeView(recipeID: value)
                }
        }
    }
}*/
