//
//  RecipeView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 16.08.2023.
//

/*import Foundation
import SwiftUI

struct RecipeViewOld: View {
    @ObservedObject var recipeStore = RecipeManager.shared
    @ObservedObject var recipeViewModel: RecipeViewModel
    var tempIngredientImages: [Image] = [Image("Domates"), Image("Patates"), Image("Tofu"), Image("Marul"), Image("Mısır"), Image("Dereotu"), Image("Salatalık")]
    
    let db = FirestoreManager.shared.getFirestore()
    
    @State private var blurAmount: CGFloat = 0
    @State private var opacityAmount: CGFloat = 0.1
    @State private var test: CGFloat = 0
    
    //var index: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                /*if let coverImage = recipeStore.recipes[index].coverImage {
                    Image(uiImage: coverImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: blurAmount)
                        //.edgesIgnoringSafeArea(.top)
                }*/
                Image(uiImage: recipeStore.recipes[index].coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: blurAmount)
                /*Image("TofuSalad")
                    //.resizable()
                    .frame(width: geometry.size.width)
                    .blur(radius: blurAmount)
                    .edgesIgnoringSafeArea(.top)*/
                    //.background(LinearGradient(gradient: Gradient(colors: [Color(red: 255/255, green: 255/255, blue: 255/255).opacity(1), Color(red: 0/255, green: 0/255, blue: 0/255).opacity(1)]), startPoint: .top, endPoint: .bottom))
                    //.padding(.top, 1)
                    //.scaledToFill()
                LinearGradient(gradient: Gradient(colors: [Color(red: 0/255, green: 0/255, blue: 0/255).opacity(opacityAmount), Color(red: 0/255, green: 0/255, blue: 0/255).opacity(1)]), startPoint: .top, endPoint: .bottom)
                ScrollView() {
                    Spacer().frame(height: 500)
                    VStack {
                        /*Text("Tofulu Salata")
                            .font(.title)*/
                        Text("\(recipeStore.recipes[index].title)")
                            .font(.title)
                        /*HStack {
                            Image(systemName: "clock")
                            Text("15 dk.")
                                .underline()
                        }*/
                        HStack {
                            Image(systemName: "clock")
                            Text("\(recipeStore.recipes[index].prepTime)")
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
                            //Text("Porsiyon")
                            Text("\(recipeStore.recipes[index].servingSize)")
                                .padding(.top, 5)
                                .padding(.bottom, 5)
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
                            Text("\(recipeStore.recipes[index].steps.count)")
                            Spacer()
                        }.padding(.leading)
                            .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 15) {
                            ForEach(tempIngredientImages.indices, id: \.self) { index in
                                tempIngredientImages[index]
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    //.frame(width: 80, height: 80)
                                    .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                    .clipShape(Circle())
                            }
                        }.padding(.horizontal)
                        HStack {
                            Text("Tarif Yapılışı")
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            Spacer()
                        }.padding(.leading)
                            .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                        VStack(alignment: .leading) {
                            /*Image("kisir-adim-1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width)
                            HStack {
                                Image(systemName: "1.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading)
                                .foregroundColor(.green)
                                Text("Yumurta ve şekeri kıvam alana kadar çırpın. Üzerine sıvı malzemeleri ekleyerek çırpmaya devam edin.")
                                Spacer()
                            }.padding(.top, 5)
                                .padding(.bottom, 5)
                                .background(Color(red: 131/255, green: 185/255, blue: 89/255))*/
                            ForEach(recipeStore.recipes[index].steps.indices, id: \.self) { stepIndex in
                                /*if let stepImage = recipeStore.recipes[index].steps[stepIndex].image {
                                    Image(uiImage: stepImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width)
                                }*/
                                Image(uiImage: recipeStore.recipes[index].steps[stepIndex].image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width)
                                HStack {
                                    Image(systemName: "\(stepIndex + 1).circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .padding(.leading)
                                        .foregroundColor(.green)
                                    Text("\(recipeStore.recipes[index].steps[stepIndex].instruction)")
                                    Spacer()
                                }.padding(.top, 5)
                                    .padding(.bottom, 5)
                                    .background(Color(red: 131/255, green: 185/255, blue: 89/255))
                                Spacer(minLength: 50)
                            }
                        }
                        Color.clear.frame(height: 500)
                    }.background(GeometryReader { scrollGeometry in
                        Color.clear
                            .onChange(of: scrollGeometry.frame(in: .global).minY) { minY in
                                blurAmount = max(0, (-minY + 600) / 50)  // Adjust division value for blur speed
                                //test = (-minY + 100) / 600
                                opacityAmount = min(0.7, max(0.0, (-minY + 600) / 600))
                                //opacityAmount = test
                            }
                    })
                    //.background(Color.green.opacity(0.5))
                }//.background(Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.1))
                
            }
        }/*.onAppear() {
            let documentID = recipeStore.recipes[index].id
            let collectionReference = db.collection("recipes")
            collectionReference.document(documentID).getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }
                
                if let document = documentSnapshot, document.exists {
                    Task {
                        do {
                            if let data = document.data(),
                               let stepsData = data["steps"] as? [[String: Any]] {
                                let steps = try await recipeStore.downloadStepsImages(from: stepsData)
                                recipeStore.recipes[index].steps = steps
                            }
                        } catch {
                            print("Error during downloading: \(error)")
                            // Handle this as fits your app's needs.
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }*/
        .onAppear() {
            
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipeViewModel: RecipeViewModel(recipe: Recipe(title: "Test Yemeği", description: "Test Açıklaması", coverImage: UIImage(), prepTime: "30", servingSize: 2, category: "Akşam Yemeği", userID: "123", id: "123", steps: [Step(instruction: "Test Yönergesi", image: UIImage())])), index: 0)
    }
}
*/
