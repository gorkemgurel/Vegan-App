//
//  RecipeView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 16.08.2023.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    @State private var isAnimating = false
    @StateObject var recipeViewModel = RecipeViewModel.shared
    var tempIngredientImages: [Image] = [Image("Domates"), Image("Patates"), Image("Tofu"), Image("Marul"), Image("Mısır"), Image("Dereotu"), Image("Salatalık")]
    
    //let db = FirestoreManager.shared.getFirestore()
    
    @State private var blurAmount: CGFloat = 0
    @State private var opacityAmount: CGFloat = 0.1
    @State private var test: CGFloat = 0

    var recipeID: String
    
    init(recipeID: String) {
            self.recipeID = recipeID
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white)]

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    
    var body: some View {
        GeometryReader { geometry in
            if (recipeViewModel.uniqueRecipes[recipeID] != nil) {
                ZStack {
                    if let coverImage = recipeViewModel.uniqueRecipes[recipeID]?.coverPhoto {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .blur(radius: blurAmount)
                    } else {
                        
                    }

                    LinearGradient(gradient: Gradient(colors: [Color(red: 0/255, green: 0/255, blue: 0/255).opacity(opacityAmount), Color(red: 0/255, green: 0/255, blue: 0/255).opacity(1)]), startPoint: .top, endPoint: .bottom)
                    ScrollView() {
                        Spacer().frame(height: 500)
                        VStack {
                            if let title = recipeViewModel.uniqueRecipes[recipeID]?.title {
                                Text(title)
                                    .font(.title)
                            }
                            else {
                                
                            }
                            HStack {
                                Image(systemName: "clock")
                                if let prepTime = recipeViewModel.uniqueRecipes[recipeID]?.prepTime {
                                    Text(prepTime)
                                }
                                else {
                                    
                                }
                            }
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                VStack {
                                    Text("Şevval Alsancak")
                                    Text("@sevvalalsancak")
                                }
                                Spacer()
                            }.padding(.leading)
                            HStack {
                                Spacer()
                            }.padding(.leading)
                                .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                            HStack {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 20))
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                            }
                            HStack {
                                Text("Gerekli Malzemeler")
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                Spacer()
                            }.padding(.leading)
                                .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 15) {
                                ForEach(tempIngredientImages.indices, id: \.self) { index in
                                    tempIngredientImages[index]
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                        .clipShape(Circle())
                                }
                            }.padding(.horizontal)
                            HStack {
                                Text("Tarifin Yapılışı")
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                Spacer()
                            }.padding(.leading)
                                .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                            LazyVStack(alignment: .leading) {
                                ForEach(0..<(recipeViewModel.uniqueRecipes[recipeID]?.steps?.count ?? 0), id: \.self) { stepIndex in
                                    VStack {
                                        if let stepImage = recipeViewModel.uniqueRecipes[recipeID]?.steps?[stepIndex].stepPhoto {
                                            Image(uiImage: stepImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width)
                                        } else {
                                            /*Image(uiImage: UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width)*/
                                            GradientProgressView()
                                                .frame(width: geometry.size.width, height: 200)
                                        }
                                        HStack {
                                            Image(systemName: "\(stepIndex + 1).circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 30, height: 30)
                                                .padding(.leading)
                                                .padding(.leading)
                                                //.foregroundColor(.green)
                                                .foregroundColor(Color(red: 52/255, green: 199/255, blue: 89/255).opacity(0.5))
                                            if let instruction = recipeViewModel.uniqueRecipes[recipeID]?.steps?[stepIndex].stepInstruction {
                                                Text(instruction)
                                            } else {
                                                
                                            }
                                            Spacer()
                                        }.padding(.top, 5)
                                            .padding(.bottom, 5)
                                            .background(Color(red: 131/255, green: 185/255, blue: 89/255).opacity(0.1))
                                        Spacer(minLength: 50)
                                    }.onAppear {
                                        Task {
                                            await recipeViewModel.downloadAndAssignStepPhotos(for: recipeID, atIndex: stepIndex)
                                        }
                                    }
                                }
                            }
                            Color.clear.frame(height: 500)
                        }.background(GeometryReader { scrollGeometry in
                            Color.clear
                                .onChange(of: scrollGeometry.frame(in: .global).minY) { minY in
                                    blurAmount = max(0, (-minY + 600) / 50)  // Adjust division value for blur speed
                                    opacityAmount = min(0.7, max(0.0, (-minY + 600) / 600))
                                }
                        })

                    }
                    
                }
            }
        }
    }
}
