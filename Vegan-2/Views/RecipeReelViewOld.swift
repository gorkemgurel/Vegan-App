//
//  VerticalCarousel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 1.07.2023.
//

/*import Foundation
import SwiftUI
struct RecipeReelViewOld: View {
    //@StateObject var recipeStore = RecipeStore.shared
    //@ObservedObject var recipeStore = RecipeManager.shared
    @ObservedObject var recipeViewModel: RecipeViewModel
    //var imageNames: [String]
    @State private var selectedTab = 0
    @State var readyToNavigateToRecipe = false
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
            //navigationBarAppearance.backgroundColor = .orange
            
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                TabView(selection: $selectedTab) {
                    /*Text("\(recipeStore.recipes.count)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.bottom, 1)
                        .padding(.top, 10)*/
                    ForEach(recipeStore.recipes.indices, id: \.self) { index in
                        if (recipeStore.recipes.count > 0) {
                            ZStack {
                                //recipeStore.recipes[index].images[0]
                                /*if let coverImage = recipeStore.recipes[index].coverImage {
                                    Image(uiImage: coverImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .rotationEffect(.degrees(-90))
                                        .tag(index)
                                }*/
                                Image(uiImage: recipeStore.recipes[index].coverImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .rotationEffect(.degrees(-90))
                                    .tag(index)

                                Rectangle()
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .frame(width: geometry.size.width, height: geometry.size.height / 4)
                                    .position(x: (geometry.size.height + safeAreaInsets.top) / 2, y: geometry.size.height * 0.875)
                                    .rotationEffect(.degrees(-90))
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        //Spacer(minLength: 24)
                                        Text(recipeStore.recipes[index].title)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .padding(.leading)
                                            .padding(.bottom, 1)
                                            .padding(.top, 10)
                                            .onTapGesture {
                                                readyToNavigateToRecipe = true
                                            }
                                            .navigationDestination(isPresented: $readyToNavigateToRecipe) {
                                                RecipeView(index: index)
                                                }
                                            //.navigationBarTitle("", displayMode: .inline)
                                        /*Image(systemName: "clock")
                                            .foregroundColor(.white)
                                            .padding(.leading)
                                        Text(String(recipeStore.recipes[index].prepTime) + " dk.")
                                            .foregroundColor(.white)
                                            .padding(.leading)*/
                                        Label(String(recipeStore.recipes[index].prepTime) + " dk.", systemImage: "clock")
                                            .foregroundColor(.white)
                                            .padding(.leading)
                                            .padding(.bottom, 10)
                                        Text(recipeStore.recipes[index].description)
                                            .foregroundColor(.white)
                                            .padding(.leading)
                                        Spacer()
                                    }//.background(.blue)
                                    Spacer()
                                    VStack() {
                                        Button(action: {
                                            // Action to perform when button is tapped
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                                .font(.title2)
                                        }
                                        .padding(.trailing)
                                        .padding(.top, 30)
                                        .padding(.bottom, 10)
                                        Button(action: {
                                            // Action to perform when button is tapped
                                        }) {
                                            Image(systemName: "bookmark")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                        }
                                        .padding(.trailing)
                                    }//.background(.yellow)
                                }.frame(width: geometry.size.width, height: geometry.size.height / 4)
                                    .position(x: (geometry.size.height + safeAreaInsets.top) / 2, y: geometry.size.height * 0.875)
                                .rotationEffect(.degrees(-90))
                            }.tag(index)
                        }
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .rotationEffect(.degrees(90))
                .frame(width: geometry.size.height, height: geometry.size.width)
                .offset(x: (geometry.size.width - geometry.size.height) / 2, y: (geometry.size.height - geometry.size.width) / 2)
                .onChange(of: selectedTab) { newIndex in
                    if newIndex == recipeStore.recipes.count - 2 {
                        print("Reached the last tab!")
                        //recipeStore.test(times: 5)
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}*/
