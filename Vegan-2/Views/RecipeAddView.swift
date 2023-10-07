//
//  RecipeAddView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 20.07.2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct RecipeAddView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    @StateObject var recipeViewModel = RecipeViewModel.shared
    @State var readyToNavigateToCamera = false
    @State var readyToNavigateToThumbnail = false
    @State var indexToPass = -1
    @State private var titleText: String = ""
    @State private var descriptionText: String = ""
    @State private var prepTimeText: String = ""
    @State private var servingSizeNumber: Int = 1
    @State private var instructionText: String = ""
    @State private var bindingSteps: [Step] = []

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                Text("Tarif Bilgileri")
                    .font(.title)
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Tarif Başlığı")
                                .padding(.top, 50)
                                .padding(.leading)
                            TextField("Tarif başlığını giriniz. Örneğin; Kızarmış Sebzeli Tofu Kızartması", text: $titleText)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .onChange(of: titleText) { newValue in
                                    recipeViewModel.title = newValue
                                }
                            Text("Kapak Fotoğrafı")
                                .padding(.leading)
                            NavigationLink(value: -1) {
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 2)
                                        .cornerRadius(10)
                                        Spacer()
                                    }
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                    if let coverPhoto = recipeViewModel.coverPhoto {
                                        Image(uiImage: coverPhoto)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            Text("Açıklama")
                                .padding(.leading)
                            TextField("Tarifi birkaç cümle ile anlatınız.", text: $descriptionText)
                                //.frame(height: 4)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .onChange(of: descriptionText) { newValue in
                                    recipeViewModel.description = newValue
                                }
                            Text("Hazırlama Süresi")
                                .padding(.leading)
                            TextField("Dakika cinsinden.", text: $prepTimeText)
                                //.frame(height: 4)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .keyboardType(.numberPad)
                                .onChange(of: prepTimeText) { newValue in
                                    recipeViewModel.prepTime = newValue
                                }
                            Text("Porsiyon Miktarı")
                                .padding(.leading)
                            HStack {
                                Image(systemName: "person.2.fill")
                                Picker("Number", selection: $servingSizeNumber) {
                                    ForEach(1...16, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }.accentColor(.gray)
                                    .onChange(of: servingSizeNumber) { newValue in
                                        recipeViewModel.servingSize = newValue
                                    }
                            }.padding(.leading)
                        }
                        
                        Group {
                            Text("Kategori")
                                .padding(.leading)
                            ZStack {
                                
                                Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 35)  // Specify the height as per your requirements
                                        .cornerRadius(10)
                                Picker("Options", selection: .constant("Akşam Yemeği")) {
                                    ForEach(["Akşam Yemeği", "Option 2", "Option 3"], id: \.self) { option in
                                    Text(option).tag(option)
                                    }
                                }.pickerStyle(MenuPickerStyle())
                                    .accentColor(.gray)
                            }.padding(.leading)
                            Text("Tarifin Yapılışı")
                                .padding(.leading)
                            //ForEach(recipeViewModel.steps.indices, id: \.self) { index in //OLD CODE
                            ForEach(0..<(recipeViewModel.steps?.count ?? 0), id: \.self) { stepIndex in
                                Text("")
                                VStack {
                                    NavigationLink(value: stepIndex) {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                                .cornerRadius(10)
                                            Image(systemName: "camera.fill")
                                                .font(.largeTitle)
                                            /*Image(uiImage: recipeViewModel.steps?[stepIndex].image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                                .cornerRadius(10)*/
                                            if let stepImage = recipeViewModel.steps?[stepIndex].stepPhoto {
                                                Image(uiImage: stepImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                                    .cornerRadius(10)
                                            }

                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        
                                                    }) {
                                                        Image(systemName: "x.circle.fill")
                                                            .font(.title)
                                                            .foregroundColor(.gray)
                                                    }
                                                }.padding(.trailing)
                                                Spacer()
                                            }
                                        }
                                    }
                                    Spacer()
                                        .padding(.horizontal)
                                    /*TextField("Enter text", text: Binding(
                                        get: { recipeViewModel.steps?[index].instruction},
                                        set: { newValue in
                                            recipeViewModel.steps?[index].instruction = newValue
                                        }
                                    ), axis: .vertical)*/
                                    TextField("Enter text", text: Binding(
                                        //get: { recipeViewModel.steps?[stepIndex].instruction ?? "" },
                                        get: { if let instruction = recipeViewModel.steps?[stepIndex].stepInstruction {
                                            return instruction
                                        }
                                            else {
                                                return ""
                                            }
                                        },
                                        set: { newValue in recipeViewModel.steps?[stepIndex].stepInstruction = newValue }
                                    ), axis: .vertical)
                                        //.frame(height: 4)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                        .padding(.horizontal)
                                }.overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                            .stroke(.black, lineWidth: 1)
                                        .frame(width: geometry.size.width - 32))
                                .padding(.bottom)
                                .padding(.bottom)
                            }
                            Button(action: {
                                //viewModel.steps?.append(Step(instruction: "", image: UIImage()))
                                if (recipeViewModel.steps?.append(Step(stepInstruction: "", stepPhoto: UIImage()))) == nil {
                                    recipeViewModel.steps = [Step(stepInstruction: "", stepPhoto: UIImage())]
                                }
                                //print(viewModel.steps?.count)
                            }) {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "plus")
                                            .font(.title)
                                    }
                                    Spacer()
                                }.padding()
                            }
                            HStack {
                                Spacer()
                                Button("Add Recipe") {
                                    recipeViewModel.addRecipe()
                                }
                                Spacer()
                            }
                        }
                    }
                }.background(Color(red: Double(28) / 255.0, green: Double(28) / 255.0, blue: Double(30) / 255.0))
                    .navigationDestination(for: Int.self) { value in
                        CameraView(recipeViewModel: recipeViewModel, index: value)
                    }
                Spacer()
            }
        }
    }
}

