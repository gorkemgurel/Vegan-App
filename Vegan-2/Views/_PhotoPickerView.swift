//
//  PhotoPickerView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 11.10.2023.
//

/*import Foundation
import SwiftUI
import PhotosUI
import CropViewController

struct PhotoPickerView: View {
    
    @StateObject var photoPickerViewModel: PhotoPickerViewModel //Will not work with ObservedObject
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    @State private var image: UIImage = UIImage(named: "TofuSalad")!
    @State private var isCropping: Bool = false
    @State private var croppedImage: UIImage? = nil
    @State private var showImageCropper = false
    @State private var tempInputImage: UIImage? = UIImage(named: "TofuSalad")!
    //@ObservedObject var photoPickerViewModel = PhotoPickerViewModel(imageType: .step(3))
    
    func imageCropped(image: UIImage) {
        self.tempInputImage = nil
        croppedImage = image
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                PhotosPicker(selection: $photoPickerViewModel.selectedPhotoPickerItem) {
                    Text("Select Photo")
                }
                Button("Force Change") {
                    photoPickerViewModel.selectedPhotoPickerItem = PhotosPickerItem(itemIdentifier: "")
                }
                Button("Crop Image") {
                    isCropping = true
                }
                Button("Crop Image 2") {
                    showImageCropper = true
                }
                if let croppedImage = croppedImage {
                    Image(uiImage: croppedImage)
                }
                if (photoPickerViewModel.imageType == .cover) {
                    if let coverPhoto = recipeAddViewModel.recipe.coverPhoto {
                        Image(uiImage: coverPhoto)
                    }
                }
            }
            if showImageCropper {
                ImageCropper(image: self.$tempInputImage, visible: self.$showImageCropper, done: self.imageCropped)
            }
            //Image(uiImage: testImage)
        }.onChange(of: photoPickerViewModel.selectedPhotoPickerItem) { _ in
            Task {
                if let photo = await photoPickerViewModel.convertPhoto() {
                    recipeAddViewModel.recipe.coverPhoto = photo
                }
                else {
                }
            }
        }
        .sheet(isPresented: $isCropping) {
            /*CropViewController(image: $image) { cropped in
             self.croppedImage = cropped
             }*/
            ImageCropper(image: self.$tempInputImage, visible: self.$showImageCropper, done: self.imageCropped)
        }
    }
}*/


//
//  ContentView.swift
//  CropViewControllerSwiftUIExample
//
//  Created by KENJI WADA on 2020/07/25.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

/*struct TestView: View {
    
    enum SheetType {
        case imagePick
        case imageCrop
        case share
    }
    
    @State private var currentSheet: SheetType = .imagePick
    @State private var actionSheetIsPresented = false
    @State private var sheetIsPresented = false
    
    @State private var originalImage: UIImage?
    @State private var image: UIImage?
    @State private var croppingStyle = CropViewCroppingStyle.default
    @State private var croppedRect = CGRect.zero
    @State private var croppedAngle = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if image == nil {
                    Text("Tap '+' to choose a photo.")
                        .foregroundColor(Color(UIColor.systemBlue))
                } else {
                    GeometryReader { geometry in
                        Image(uiImage: self.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.width)
                            .onTapGesture {
                                self.didTapImageView()
                            }
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("CropViewController", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.actionSheetIsPresented.toggle()
            }) {
                Image(systemName: "plus")
            })
        }
        .actionSheet(isPresented: $actionSheetIsPresented) {
            ActionSheet(title: Text(""), message: nil, buttons: [
                .default(Text("Crop Image"), action: {
                    self.croppingStyle = .default
                    self.currentSheet = .imagePick
                    self.sheetIsPresented = true
                }),
                .default(Text("Make Profile Picture"), action: {
                    self.croppingStyle = .circular
                    self.currentSheet = .imagePick
                    self.sheetIsPresented = true
                })
            ])
        }
        .sheet(isPresented: $sheetIsPresented) {
            if (self.currentSheet == .imagePick) {
                ImagePickerView(croppingStyle: self.croppingStyle, sourceType: .photoLibrary, onCanceled: {
                    // on cancel
                }) { (image) in
                    guard let image = image else {
                        return
                    }
                    
                    self.originalImage = image
                    DispatchQueue.main.async {
                        self.currentSheet = .imageCrop
                        self.sheetIsPresented = true
                    }
                }
            } else if (self.currentSheet == .imageCrop) {
                ImageCropView(croppingStyle: self.croppingStyle, originalImage: self.originalImage!, onCanceled: {
                    // on cancel
                }) { (image, cropRect, angle) in
                    // on success
                    self.image = image
                }
            }
        }
    }
    
    internal func didTapImageView() {
        
    }
}*/
