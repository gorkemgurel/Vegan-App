//
//  RecipeAddView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 9.10.2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct RecipeAddView: View {
    
    //@State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    //@State var readyToNavigateToCamera = false
    @State var readyToNavigateToThumbnail = false
    @State var readyToNavigateToTestView = false
    
    var body: some View {
        if #available(iOS 16.0, *) {
            RecipeAddView16(recipeAddViewModel: recipeAddViewModel)
        } else {
            RecipeAddView15(recipeAddViewModel: recipeAddViewModel)
        }
    }
}

@available(iOS 16.0, *)
struct RecipeAddView16: View {
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Text("Tarif Bilgileri")
                    .font(.title)
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Tarif Başlığı")
                                .padding(.top, 50)
                                .padding(.leading)
                            TextField("Tarif başlığını giriniz. Örneğin; Kızarmış Sebzeli Tofu Kızartması", text: $recipeAddViewModel.recipe.title)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Text("Kapak Fotoğrafı")
                                .padding(.leading)
                            Button(action: {
                                //readyToGoToCamera = true
                                //recipeAddViewimageType = ImageType.cover
                                recipeAddViewModel.imageType = ImageType.cover
                            }) {
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 2)
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                    if let coverPhoto = recipeAddViewModel.recipe.coverPhoto {
                                        Image(uiImage: coverPhoto)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                                         
                            /*NavigationLink(destination: CameraView(cameraViewModel: CameraViewModel(imageType: ImageType.cover), recipeAddViewModel: recipeAddViewModel)){
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 2)
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                    if let coverPhoto = recipeAddViewModel.recipe.coverPhoto {
                                        Image(uiImage: coverPhoto)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                            .cornerRadius(10)
                                    }
                                }
                            }*/
                            Text("Açıklama")
                                .padding(.leading)
                            TextField("Tarifi birkaç cümle ile anlatınız.", text: $recipeAddViewModel.recipe.description)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Text("Hazırlama Süresi")
                                .padding(.leading)
                            TextField("Dakika cinsinden.", text: $recipeAddViewModel.recipe.prepTime)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .keyboardType(.numberPad)
                            Text("Porsiyon Miktarı")
                                .padding(.leading)
                            HStack {
                                Image(systemName: "person.2.fill")
                                Picker("Number", selection: $recipeAddViewModel.recipe.servingSize) {
                                    ForEach(1...16, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }.accentColor(.gray)
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
                            ForEach(recipeAddViewModel.recipe.steps.indices, id: \.self) { stepIndex in
                                Text("")
                                VStack {
                                    /*NavigationLink(destination: CameraView(cameraViewModel: CameraViewModel(imageType: ImageType.step(stepIndex)), recipeAddViewModel: recipeAddViewModel, readyToGoToCamera: $readyToGoToCamera)) {
                                        
                                    }*/
                                    Button(action: {
                                        //readyToGoToCamera = true
                                        //recipeAddViewimageType = ImageType.cover
                                        recipeAddViewModel.imageType = ImageType.step(stepIndex)
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                                .cornerRadius(10)
                                            Image(systemName: "camera.fill")
                                                .font(.largeTitle)
                                            if let stepImage = recipeAddViewModel.recipe.steps[stepIndex].stepPhoto {
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
                                    TextField("Enter text", text: $recipeAddViewModel.recipe.steps[stepIndex].stepInstruction)
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
                                recipeAddViewModel.recipe.steps.append(Step())
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
                                    recipeAddViewModel.addRecipe()
                                }
                                Spacer()
                            }
                        }
                    }
                }.background(Color(red: Double(28) / 255.0, green: Double(28) / 255.0, blue: Double(30) / 255.0))
                Spacer()
            }.navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .fullScreenCover(item: $recipeAddViewModel.imageType) { type in
                    CameraView(cameraViewModel: CameraViewModel(imageType: type), recipeAddViewModel: recipeAddViewModel)
                }
        }
    }
}

struct RecipeAddView15: View {
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Text("Tarif Bilgileri")
                    .font(.title)
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Tarif Başlığı")
                                .padding(.top, 50)
                                .padding(.leading)
                            TextField("Tarif başlığını giriniz. Örneğin; Kızarmış Sebzeli Tofu Kızartması", text: $recipeAddViewModel.recipe.title)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Text("Kapak Fotoğrafı")
                                .padding(.leading)
                            Button(action: {
                                //readyToGoToCamera = true
                                //recipeAddViewimageType = ImageType.cover
                                recipeAddViewModel.imageType = ImageType.cover
                            }) {
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 2)
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                    if let coverPhoto = recipeAddViewModel.recipe.coverPhoto {
                                        Image(uiImage: coverPhoto)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                                         
                            /*NavigationLink(destination: CameraView(cameraViewModel: CameraViewModel(imageType: ImageType.cover), recipeAddViewModel: recipeAddViewModel)){
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 2)
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                    if let coverPhoto = recipeAddViewModel.recipe.coverPhoto {
                                        Image(uiImage: coverPhoto)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                            .cornerRadius(10)
                                    }
                                }
                            }*/
                            Text("Açıklama")
                                .padding(.leading)
                            TextField("Tarifi birkaç cümle ile anlatınız.", text: $recipeAddViewModel.recipe.description)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Text("Hazırlama Süresi")
                                .padding(.leading)
                            TextField("Dakika cinsinden.", text: $recipeAddViewModel.recipe.prepTime)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .keyboardType(.numberPad)
                            Text("Porsiyon Miktarı")
                                .padding(.leading)
                            HStack {
                                Image(systemName: "person.2.fill")
                                Picker("Number", selection: $recipeAddViewModel.recipe.servingSize) {
                                    ForEach(1...16, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }.accentColor(.gray)
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
                            ForEach(recipeAddViewModel.recipe.steps.indices, id: \.self) { stepIndex in
                                Text("")
                                VStack {
                                    /*NavigationLink(destination: CameraView(cameraViewModel: CameraViewModel(imageType: ImageType.step(stepIndex)), recipeAddViewModel: recipeAddViewModel, readyToGoToCamera: $readyToGoToCamera)) {
                                        
                                    }*/
                                    Button(action: {
                                        //readyToGoToCamera = true
                                        //recipeAddViewimageType = ImageType.cover
                                        recipeAddViewModel.imageType = ImageType.step(stepIndex)
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) / 1.5)
                                                .cornerRadius(10)
                                            Image(systemName: "camera.fill")
                                                .font(.largeTitle)
                                            if let stepImage = recipeAddViewModel.recipe.steps[stepIndex].stepPhoto {
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
                                    TextField("Enter text", text: $recipeAddViewModel.recipe.steps[stepIndex].stepInstruction)
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
                                recipeAddViewModel.recipe.steps.append(Step())
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
                                    recipeAddViewModel.addRecipe()
                                }
                                Spacer()
                            }
                        }
                    }
                }.background(Color(red: Double(28) / 255.0, green: Double(28) / 255.0, blue: Double(30) / 255.0))
                Spacer()
            }.navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .fullScreenCover(item: $recipeAddViewModel.imageType) { type in
                    CameraView(cameraViewModel: CameraViewModel(imageType: type), recipeAddViewModel: recipeAddViewModel)
                }
        }
    }
}
