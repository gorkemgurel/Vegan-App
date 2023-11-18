//
//  CameraViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 15.10.2023.
//

import AVFoundation
import SwiftUI
import PhotosUI
import Mantis

final class CameraViewModel: ObservableObject {
    let camera = Camera()
    
    var imageType: ImageType
    
    @Published var viewfinderImage: Image?
    @Published var actualImage: UIImage?
    @Published var showingCropper = false
    @Published var showingImagePicker = false
    @Published var didCancel: Bool = false
    
    init(imageType: ImageType) {
        self.imageType = imageType
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func toggleFlashMode() {
        camera.flashMode.toggle()
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                actualImage = photoData
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> UIImage? {
        guard photo.fileDataRepresentation() != nil else { return nil }
        
        guard let primaryCGImage = photo.cgImageRepresentation(),
           let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        return UIImage(cgImage: primaryCGImage, scale: 1, orientation: UIImage.Orientation(cgImageOrientation))
    }
}

extension UIImage.Orientation {
    init(_ cgOrientation: CGImagePropertyOrientation) {
        switch cgOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
