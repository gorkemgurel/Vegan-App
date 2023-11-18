//
//  CameraView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 15.10.2023.
//

import SwiftUI
import PhotosUI
import Mantis

struct CameraView: View {
    
    @StateObject var cameraViewModel: CameraViewModel
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                CameraView16(cameraViewModel: cameraViewModel, recipeAddViewModel: recipeAddViewModel)
            } else {
                CameraView15(cameraViewModel: cameraViewModel, recipeAddViewModel: recipeAddViewModel)
            }
        }
    }
}

@available(iOS 16.0, *)
struct CameraView16: View {
    
    @StateObject var cameraViewModel: CameraViewModel
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    @State private var photosPickerItem: PhotosPickerItem?
    
    var flashIconName: String {
        switch cameraViewModel.camera.flashMode {
        case .auto:
            return "bolt.badge.a.fill"
        case .on:
            return "bolt.fill"
        case .off:
            return "bolt.slash.fill"
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button(action: {
                            //readyToGoToCamera = false
                            recipeAddViewModel.imageType = nil
                            cameraViewModel.camera.stop()
                        }) {
                            Image(systemName: "xmark")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                        }
                        Spacer()
                        Button(action: {
                            cameraViewModel.toggleFlashMode()
                        }) {
                            Image(systemName: flashIconName)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                        }
                    }
                    if let viewFinderImage = cameraViewModel.viewfinderImage {
                        viewFinderImage
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3 * 4)
                    } else {
                        Image(uiImage: UIImage())
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3 * 4)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                cameraViewModel.showingImagePicker = true
                                cameraViewModel.camera.stop()
                            } label: {
                                Label("Gallery", systemImage: "photo.fill.on.rectangle.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            Spacer()
                            Button {
                                cameraViewModel.camera.takePhoto()
                            } label: {
                                Label {
                                    Text("Take Photo")
                                } icon: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 3)
                                            .frame(width: 62, height: 62)
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                            Spacer()
                            Button {
                                cameraViewModel.camera.switchCaptureDevice()
                            } label: {
                                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath.camera")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }.buttonStyle(.plain)
                            .labelStyle(.iconOnly)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .photosPicker(isPresented: $cameraViewModel.showingImagePicker, selection: $photosPickerItem)
            .onChange(of: photosPickerItem) { _ in
                Task {
                    if let data = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            cameraViewModel.actualImage = uiImage
                            return
                        }
                    }
                }
            }
            .onChange(of: cameraViewModel.actualImage) { _ in
                cameraViewModel.showingCropper = true
            }
            .onChange(of: cameraViewModel.showingImagePicker) { _ in
                if (photosPickerItem == nil) {
                    Task {
                        await cameraViewModel.camera.start()
                    }
                }
            }
            .onAppear {
                Task {
                    await cameraViewModel.camera.start()
                }
            }
            .fullScreenCover(isPresented: $cameraViewModel.showingCropper, content: {
                ImageCropper(recipeAddViewModel: recipeAddViewModel, cameraViewModel: cameraViewModel, image: $cameraViewModel.actualImage)
                    .onAppear {
                        cameraViewModel.camera.stop()
                    }
            })
        }
    }
}

struct CameraView15: View {
    
    @StateObject var cameraViewModel: CameraViewModel
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    
    var flashIconName: String {
        switch cameraViewModel.camera.flashMode {
        case .auto:
            return "bolt.badge.a.fill"
        case .on:
            return "bolt.fill"
        case .off:
            return "bolt.slash.fill"
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button(action: {
                            //readyToGoToCamera = false
                            recipeAddViewModel.imageType = nil
                            cameraViewModel.camera.stop()
                        }) {
                            Image(systemName: "xmark")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                        }
                        Spacer()
                        Button(action: {
                            cameraViewModel.toggleFlashMode()
                        }) {
                            Image(systemName: flashIconName)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                        }
                    }
                    if let viewFinderImage = cameraViewModel.viewfinderImage {
                        viewFinderImage
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3 * 4)
                    } else {
                        Image(uiImage: UIImage())
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 3 * 4)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                cameraViewModel.showingImagePicker = true
                            } label: {
                                Label("Gallery", systemImage: "photo.fill.on.rectangle.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            Spacer()
                            Button {
                                cameraViewModel.camera.takePhoto()
                            } label: {
                                Label {
                                    Text("Take Photo")
                                } icon: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 3)
                                            .frame(width: 62, height: 62)
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                            Spacer()
                            Button {
                                cameraViewModel.camera.switchCaptureDevice()
                            } label: {
                                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath.camera")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }.buttonStyle(.plain)
                            .labelStyle(.iconOnly)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $cameraViewModel.showingImagePicker) {
                ImagePicker(image: $cameraViewModel.actualImage, didCancel: $cameraViewModel.didCancel)
                    .onAppear {
                        cameraViewModel.camera.stop()
                    }
                    .onDisappear {
                        if cameraViewModel.didCancel {
                            Task {
                                await cameraViewModel.camera.start()
                            }
                        }
                    }
            }
            .onChange(of: cameraViewModel.actualImage) { _ in
                cameraViewModel.showingCropper = true
            }
            .onAppear {
                Task {
                    await cameraViewModel.camera.start()
                }
            }
            .fullScreenCover(isPresented: $cameraViewModel.showingCropper, content: {
                ImageCropper(recipeAddViewModel: recipeAddViewModel, cameraViewModel: cameraViewModel, image: $cameraViewModel.actualImage)
                    .onAppear {
                        cameraViewModel.camera.stop()
                    }
            })
        }
    }
}
