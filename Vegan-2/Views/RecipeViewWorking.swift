//
//  RecipeView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 16.08.2023.
//

/*import Foundation
import SwiftUI

struct RecipeView: View {
    @State private var isAnimating = false
    @State private var isSelected = false
    @ObservedObject var recipeStore = RecipeStore.shared
    @ObservedObject var recipeViewModel: RecipeViewModel
    var tempIngredientImages: [Image] = [Image("Domates"), Image("Patates"), Image("Tofu"), Image("Marul"), Image("Mısır"), Image("Dereotu"), Image("Salatalık")]
    
    //let db = FirestoreManager.shared.getFirestore()
    
    @State private var blurAmount: CGFloat = 0
    @State private var opacityAmount: CGFloat = 0.1
    @State private var test: CGFloat = 0
    
    @State private var insideViewHeight: CGFloat = 9999
    
    //var recipeID: String
    
    init(recipeViewModel: RecipeViewModel) {
        //self.recipeID = recipeID
        self.recipeViewModel = recipeViewModel
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    var body: some View {
        GeometryReader { geometry in
            //if (recipeStore.uniqueRecipes[recipeViewModel.recipeID] != nil) {
            if let recipe = recipeStore.uniqueRecipes[recipeViewModel.recipeID] {
                ZStack {
                    if let coverPhoto = recipe.coverPhoto {
                        Image(uiImage: coverPhoto)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .blur(radius: blurAmount)
                    } else {
                        
                    }
                    
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0/255, green: 0/255, blue: 0/255).opacity(opacityAmount), Color(red: 0/255, green: 0/255, blue: 0/255).opacity(1)]), startPoint: .top, endPoint: .bottom)
                    //TabView(selection: $isSelected) {
                    ScrollView() {
                        Spacer().frame(height: geometry.size.height - 250)
                        VStack(spacing: 0) {
                            HStack {
                                HStack {
                                    Spacer()
                                    Text("Tarif Detayları")
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .font(Font.custom("Fredoka-Light", size: 15))
                                    Spacer()
                                    //.background(isSelected ? .blue : .black)
                                }
                                .background(isSelected ? .black : Color("RecipeViewSelectedTabColor"))
                                //.foregroundColor(isSelected ? .blue : .black)
                                HStack {
                                    Spacer()
                                    Text("Yorumlar")
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .font(Font.custom("Fredoka-Light", size: 15))
                                    Spacer()
                                    //.background(isSelected ? .black : .blue)
                                }
                                .background(isSelected ? Color("RecipeViewSelectedTabColor") : .black)
                                //.foregroundColor(isSelected ? .black : .blue)
                            }.background(.clear)
                                .sticky()
                            TabView(selection: $isSelected) {
                                /*VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text("Hello")
                                        Spacer()
                                    }
                                    Spacer()
                                }*/
                                VStack {
                                    LazyVStack(alignment: .leading) {
                                        //ForEach(0..<(recipeStore.uniqueRecipes[recipeViewModel.recipeID]?.steps?.count ?? 0), id: \.self) { stepIndex in
                                        //ForEach(0..<(recipe.steps.count ?? 0), id: \.self) { stepIndex in
                                        ForEach(recipe.steps.indices, id: \.self) { stepIndex in
                                            VStack {
                                                if let stepImage = recipe.steps[stepIndex].stepPhoto {
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
                                                    Text(recipe.steps[stepIndex].stepInstruction)
                                                    Spacer()
                                                }.padding(.top, 5)
                                                    .padding(.bottom, 5)
                                                    .background(Color(red: 131/255, green: 185/255, blue: 89/255).opacity(0.1))
                                                Spacer(minLength: 50)
                                            }.onAppear {
                                                Task {
                                                    await recipeViewModel.downloadAndAssignStepPhotos(for: recipeViewModel.recipeID, atIndex: stepIndex)
                                                }
                                            }
                                        }
                                    }
                                }
                                .tabItem {
                                    Text("Yorumlar")
                                }.tag(true)
                                    .rotationEffect(.degrees(180))
                                    //.background(Color("RecipeViewSelectedTabColor"))
                                VStack {
                                    Text(recipe.title)
                                        .font(Font.custom("ElMessiri-Bold", size: 40))
                                    //.font(.title)
                                    HStack {
                                        Image(systemName: "clock")
                                        Text("\(recipe.prepTime) dk.")
                                            .font(Font.custom("ElMessiri-Bold", size: 15))
                                            .underline()
                                    }
                                    VStack(spacing: 20) {
                                        HStack {
                                            Image("sevval")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                            VStack {
                                                Text("Şevval Alsancak")
                                                    .font(Font.custom("ElMessiri-Bold", size: 15))
                                                //.padding(.bottom)
                                                Text("@sevvalalsancak")
                                                    .font(Font.custom("ElMessiri-Bold", size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }.padding(.leading)
                                        HStack {
                                            Spacer()
                                        }.padding(.leading)
                                        //.background(Color(red: 131/255, green: 185/255, blue: 89/255))
                                            .background(Color("RecipeViewSelectedTabColor"))
                                        HStack {
                                            Text("Porsiyon")
                                                .padding(.top, 5)
                                                .padding(.bottom, 5)
                                                .font(Font.custom("Fredoka-Light", size: 15))
                                            Spacer()
                                        }.padding(.leading)
                                        //.background(Color(red: 131/255, green: 185/255, blue: 89/255))
                                            .background(Color("RecipeViewSelectedTabColor"))
                                        //Spacer()
                                        HStack {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.green)
                                            Image(systemName: "person.2.fill")
                                                .font(.system(size: 50))
                                                .foregroundColor(.gray)
                                            Text("2")
                                                .font(.title2)
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.green)
                                        }
                                        HStack {
                                            Text("Gerekli Malzemeler")
                                                .padding(.top, 5)
                                                .padding(.bottom, 5)
                                                .font(Font.custom("Fredoka-Light", size: 15))
                                            Spacer()
                                        }.padding(.leading)
                                        //.background(Color(red: 131/255, green: 185/255, blue: 89/255))
                                            .background(Color("RecipeViewSelectedTabColor"))
                                    }
                                    VStack(spacing: 20) {
                                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 15) {
                                            ForEach(tempIngredientImages.indices, id: \.self) { index in
                                                VStack {
                                                    tempIngredientImages[index]
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                                        .clipShape(Circle())
                                                    Text("Malzeme \(index)")
                                                        .font(Font.custom("Fredoka-Light", size: 11))
                                                    Spacer()
                                                }
                                            }
                                        }.padding(.horizontal)
                                        HStack {
                                            Text("Tarifin Yapılışı")
                                                .font(Font.custom("Fredoka-Light", size: 15))
                                                .padding(.top, 5)
                                                .padding(.bottom, 5)
                                            Spacer()
                                        }.padding(.leading)
                                        //.background(Color(red: 131/255, green: 185/255, blue: 89/255))
                                            .background(Color("RecipeViewSelectedTabColor"))
                                        /*LazyVStack(alignment: .leading) {
                                            //ForEach(0..<(recipeStore.uniqueRecipes[recipeViewModel.recipeID]?.steps?.count ?? 0), id: \.self) { stepIndex in
                                            //ForEach(0..<(recipe.steps.count ?? 0), id: \.self) { stepIndex in
                                            ForEach(recipe.steps.indices, id: \.self) { stepIndex in
                                                VStack {
                                                    if let stepImage = recipe.steps[stepIndex].stepPhoto {
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
                                                        Text(recipe.steps[stepIndex].stepInstruction)
                                                        Spacer()
                                                    }.padding(.top, 5)
                                                        .padding(.bottom, 5)
                                                        .background(Color(red: 131/255, green: 185/255, blue: 89/255).opacity(0.1))
                                                    Spacer(minLength: 50)
                                                }.onAppear {
                                                    Task {
                                                        await recipeViewModel.downloadAndAssignStepPhotos(for: recipeViewModel.recipeID, atIndex: stepIndex)
                                                    }
                                                }
                                            }
                                        }*/
                                        Color.clear.frame(height: 500)
                                    }
                                }.tabItem {
                                    Text("Tarif Detayları")
                                }.tag(false)
                                    .rotationEffect(.degrees(180))
                                    /*.background(GeometryReader { scrollGeometry in
                                        Color("RecipeViewSelectedTabColor")
                                            .onChange(of: scrollGeometry.frame(in: .global).minY) { minY in
                                                blurAmount = max(0, (-minY + 600) / 50)  // Adjust division value for blur speed
                                                opacityAmount = min(0.7, max(0.0, (-minY + 600) / 600))
                                                //blurAmount = 30
                                                //opacityAmount = 0.7
                                            }
                                            .preference(key: ViewHeightKey.self, value: scrollGeometry.size.height)
                                    })*/
                                    .background(GeometryReader { scrollGeometry in
                                        Color.clear
                                            .preference(key: ViewHeightKey.self, value: scrollGeometry.size.height)
                                    })
                                    .onPreferenceChange(ViewHeightKey.self) { height in
                                                        // Update the inside view's height
                                                        self.insideViewHeight = height
                                                    }
                            }
                            //.frame(height: UIScreen.main.bounds.height)
                            //
                            .frame(width: geometry.size.width, height: insideViewHeight)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .rotationEffect(.degrees(180))
                            .background(GeometryReader { scrollGeometry in
                                Color("RecipeViewSelectedTabColor")
                                    .onChange(of: scrollGeometry.frame(in: .global).minY) { minY in
                                        blurAmount = max(0, (-minY + 400) / 50)  // Adjust division value for blur speed
                                        opacityAmount = min(0.7, max(0.0, (-minY + 400) / 600))
                                        //blurAmount = 0
                                        //opacityAmount = 0
                                    }
                            })
                        }.clipShape(RoundedTopRectangle(cornerRadius: 30))
                    }.coordinateSpace(name: "container")
                }
            }
        }
    }
}

extension View {
    func sticky() -> some View {
        modifier(Sticky())
    }
}

struct Sticky: ViewModifier {
    @State private var frame: CGRect = .zero
    
    var isSticking: Bool {
        frame.minY < 0
    }
    
    func body(content: Content) -> some View {
        content
            .background(isSticking ? Color("RecipeViewStickyColor") : Color("RecipeViewSelectedTabColor"))
            .offset(y: isSticking ? -frame.minY : 0)
            .zIndex(isSticking ? .infinity : 0)
            .overlay(GeometryReader { proxy in
                let f = proxy.frame(in: .named("container"))
                Color.clear
                    .onAppear { frame = f }
                    .onChange(of: f) { frame = $0 }
            })
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
*/
