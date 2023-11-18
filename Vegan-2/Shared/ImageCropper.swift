//
//  ImageCropper.swift
//  AppleCameraSample
//
//  Created by Gorkem Gurel on 15.10.2023.
//

import Mantis
import SwiftUI

struct ImageCropper: UIViewControllerRepresentable {
    @ObservedObject var recipeAddViewModel: RecipeAddViewModel
    @StateObject var cameraViewModel: CameraViewModel
    @Binding var image: UIImage?
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
            switch parent.cameraViewModel.imageType {
            case .cover:
                parent.recipeAddViewModel.recipe.coverPhoto = cropped
            case .step(let value):
                parent.recipeAddViewModel.recipe.steps[value].stepPhoto = cropped
            default:
                print("It's another type")
            }
            parent.recipeAddViewModel.imageType = nil
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            Task {
                await parent.cameraViewModel.camera.start()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return makeImageCropperHiddingRotationDial(context: context)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

extension ImageCropper {
    
    func makeImageCropperHiddingRotationDial(context: Context) -> UIViewController {
        var config = Mantis.Config()
        config.cropViewConfig.showAttachedRotationControlView = false
        config.cropToolbarConfig.toolbarButtonOptions = [.reset]
        config.cropViewConfig.cropShapeType = .rect
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 3.0 / 4.0)
        //config.cropViewConfig.maximumZoomScale = maximumZoomScale(size: image!.size)
        //let cropViewController = Mantis.cropViewController(image: image!, config: config)
        let cropViewController = Mantis.cropViewController(image: image!, config: config)
        cropViewController.delegate = context.coordinator

        return cropViewController
    }
    
    func minSize(size: Int, x: Int, y: Int) -> CGSize {
        let min = Swift.min(x, y)
        return CGSize(
            width: CGFloat(Swift.max(x, size / min * x)),
            height: CGFloat(Swift.max(y, size / min * y))
        )
    }
    
    func maximumZoomScale(size: CGSize) -> CGFloat {
        let minSizeValue = minSize(size: 3000, x: 3, y: 4)
        let widthRatio = size.width / minSizeValue.width
        let heightRatio = size.height / minSizeValue.height

        if (size.width > size.height) {
            return Swift.max(widthRatio, heightRatio)
        } else {
            return Swift.min(widthRatio, heightRatio)
        }
    }
}
