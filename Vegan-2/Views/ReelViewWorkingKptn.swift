//
//  RecipeReelView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 8.10.2023.
//

/*import Foundation
import SwiftUI

struct ReelView: View {
    
    @ObservedObject var recipeStore = RecipeStore.shared
    //@ObservedObject var recipeStore = RecipeViewModel.shared
    @ObservedObject var reelViewModel: ReelViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var selectedTab = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    /*init(userViewModel: UserViewModel, reelViewModel: ReelViewModel) {
                self.userViewModel = userViewModel
                self.reelViewModel = reelViewModel

                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white.opacity(0))]

                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }*/
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ReelView16(selectedTab: selectedTab, reelViewModel: reelViewModel, userViewModel: userViewModel, recipeStore: recipeStore)
        } else {
            ReelView15(selectedTab: selectedTab, reelViewModel: reelViewModel, userViewModel: userViewModel, recipeStore: recipeStore)
        }
    }
}

@available(iOS 16.0, *)
struct ReelView16: View {
    
    @State var selectedTab: Int
    @ObservedObject var reelViewModel: ReelViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var recipeStore: RecipeStore
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.overlay(
                    GeometryReader { geometry in
                        TabView(selection: $selectedTab) {
                            ForEach(reelViewModel.recipes.indices, id: \.self) { index in
                                let recipeID = reelViewModel.recipes[index].recipeID
                                if let recipe = recipeStore.uniqueRecipes[recipeID] {
                                    ZStack {
                                        if let coverImage = recipe.coverPhoto {
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
                                            VStack(alignment: .leading, spacing: 0) {
                                                NavigationLink(destination: RecipeView(recipeViewModel: RecipeViewModel(recipeID: recipeID))) {
                                                    Text("\(recipe.title)")
                                                        //.font(.title)
                                                        .font(Font.custom("ElMessiri-Bold", size: 40))
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        //.padding(.bottom, 1)
                                                        //.padding(.top, 10)
                                                }
  
                                                Label(recipe.prepTime + " dk.", systemImage: "clock")
                                                    .font(Font.custom("ElMessiri-Bold", size: 20))
                                                    .foregroundColor(.white)
                                                    .padding(.leading)
                                                    //.padding(.bottom, 10)

                                                Text(recipe.description)
                                                    .font(Font.custom("Fredoka-Light", size: 20))
                                                    .foregroundColor(.white)
                                                    .padding(.leading)

                                                Spacer()
                                            }
                                            Spacer()
                                            VStack() {
                                                Button(action: {
                                                    userViewModel.toggleLike(for: recipeID)
                                                }) {
                                                    if (userViewModel.user.likedRecipes.contains(recipeID)) {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundColor(.red)
                                                            .font(.title)
                                                    }
                                                    else {
                                                        Image(systemName: "heart")
                                                            .font(.title)
                                                    }
                                                    /*if let likedRecipes = userViewModel.user.likedRecipes {
                                                        if (likedRecipes.contains(recipeID)) {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundColor(.red)
                                                                .font(.title)
                                                        }
                                                        else {
                                                            Image(systemName: "heart")
                                                                .font(.title)
                                                        }
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
                                            //print("Appeared!")
                                            await reelViewModel.downloadAndAssignCoverPhoto(for: recipeID)
                                            //await recipeStore.downloadAndAssignCoverPhoto(for: recipeID)
                                            //await recipeStore.downloadAndAssignCoverImage(for: recipeID)
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
                            print(selectedTab)
                            if newIndex == reelViewModel.recipes.count - 2 {
                                //print("Reached the last tab!")
                                reelViewModel.fetchRecipesForReels(count: 4)
                            }
                        }
                    }
                )
            }
            .ignoresSafeArea(edges: .top)
            .navigationDestination(for: String.self) { value in
                RecipeView(recipeViewModel: RecipeViewModel(recipeID: value))
            }
        }
    }
}

struct ReelView15: View {
    
    @State var selectedTab: Int
    @ObservedObject var reelViewModel: ReelViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var recipeStore: RecipeStore
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.overlay(
                    GeometryReader { geometry in
                        TabView(selection: $selectedTab) {
                            ForEach(reelViewModel.recipes.indices, id: \.self) { index in
                                let recipeID = reelViewModel.recipes[index].recipeID
                                if let recipe = recipeStore.uniqueRecipes[recipeID] {
                                    ZStack {
                                        if let coverImage = recipe.coverPhoto {
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
                                            VStack(alignment: .leading, spacing: 0) {
                                                NavigationLink(destination: RecipeView(recipeViewModel: RecipeViewModel(recipeID: recipeID))) {
                                                    Text("\(recipe.title)")
                                                        //.font(.title)
                                                        .font(Font.custom("ElMessiri-Bold", size: 40))
                                                        .foregroundColor(.white)
                                                        .padding(.leading)
                                                        //.padding(.bottom, 1)
                                                        //.padding(.top, 10)
                                                }
  
                                                Label(recipe.prepTime + " dk.", systemImage: "clock")
                                                    .font(Font.custom("ElMessiri-Bold", size: 20))
                                                    .foregroundColor(.white)
                                                    .padding(.leading)
                                                    //.padding(.bottom, 10)

                                                Text(recipe.description)
                                                    .font(Font.custom("Fredoka-Light", size: 20))
                                                    .foregroundColor(.white)
                                                    .padding(.leading)

                                                Spacer()
                                            }
                                            Spacer()
                                            VStack() {
                                                Button(action: {
                                                    userViewModel.toggleLike(for: recipeID)
                                                }) {
                                                    if (userViewModel.user.likedRecipes.contains(recipeID)) {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundColor(.red)
                                                            .font(.title)
                                                    }
                                                    else {
                                                        Image(systemName: "heart")
                                                            .font(.title)
                                                    }
                                                    /*if let likedRecipes = userViewModel.user.likedRecipes {
                                                        if (likedRecipes.contains(recipeID)) {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundColor(.red)
                                                                .font(.title)
                                                        }
                                                        else {
                                                            Image(systemName: "heart")
                                                                .font(.title)
                                                        }
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
                                            //print("Appeared!")
                                            await reelViewModel.downloadAndAssignCoverPhoto(for: recipeID)
                                            //await recipeStore.downloadAndAssignCoverPhoto(for: recipeID)
                                            //await recipeStore.downloadAndAssignCoverImage(for: recipeID)
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
                            print(selectedTab)
                            if newIndex == reelViewModel.recipes.count - 2 {
                                //print("Reached the last tab!")
                                reelViewModel.fetchRecipesForReels(count: 4)
                            }
                        }
                    }
                )
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}*/
