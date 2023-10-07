import AVFoundation
import SwiftUI
import PhotosUI


class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    //@Published var output = AVCapturePhotoOutput()
    @Published var photoOutput: AVCapturePhotoOutput? = AVCapturePhotoOutput()
    @Published var deviceInput: AVCaptureDeviceInput?
    @Published var preview : AVCaptureVideoPreviewLayer!
    //@Published var takenPhotos: [UIImage] = [UIImage(named: "Image 1")!]
    
    @Published var takenPhotos: [UIImage] = [] {
        didSet {
            updateAllImages()
        }
    }
    
    @Published var selectedItems: [PhotosPickerItem] = []
    //@Published var selectedPhotos: [UIImage] = []
    
    @Published var selectedPhotos: [UIImage] = [] {
        didSet {
            updateAllImages()
        }
    }
    
    @Published var allSelectedPhotos: [UIImage] = []
    
    private func updateAllImages() {
            self.allSelectedPhotos = takenPhotos + selectedPhotos
        }
    
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var format = CMVideoDimensions(width: 0, height: 0)
    
    func check(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setUp()
                }
            }
        case.denied:
            self.alert.toggle()
            return
        default:
            return
        }
        
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            
            var unwrappedDevice: AVCaptureDevice
            
            if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                unwrappedDevice = device
                format = unwrappedDevice.activeFormat.supportedMaxPhotoDimensions.max(by: { $0.width * $0.height < $1.width * $1.height })!
            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                unwrappedDevice = device
                format = unwrappedDevice.activeFormat.supportedMaxPhotoDimensions.max(by: { $0.width * $0.height < $1.width * $1.height })!
            } else {
                fatalError("Missing expected back camera device.")
            }
            
            
            
            let input = try AVCaptureDeviceInput(device: unwrappedDevice)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            /*if self.session.canAddOutput(photoOutput) {
                self.session.addOutput(photoOutput)
            }*/
            
            if let photoOutput = self.photoOutput {
                if self.session.canAddOutput(photoOutput) {
                    self.session.addOutput(photoOutput)
                }
            }
            
            self.session.commitConfiguration()
        }
        catch {
            print(error.localizedDescription + "Zort")
        }
    }
    
    /*func takePic(){
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                
                withAnimation{self.isTaken.toggle()}
            }
        }
    }*/
    
    func takePhoto() {
        
            guard let photoOutput = self.photoOutput else { return }
            
            sessionQueue.async {
            
                var photoSettings = AVCapturePhotoSettings()


                if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                    photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
                }
                
                let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
                photoSettings.flashMode = isFlashAvailable ? .auto : .off
                //photoSettings.maxPhotoDimensions = self.format
                //photoSettings.isHighResolutionPhotoEnabled = true
                if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                    photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
                }
                photoSettings.photoQualityPrioritization = .balanced
                
                /*if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
                    if photoOutputVideoConnection.isVideoOrientationSupported,
                        let videoOrientation = self.videoOrientationFor(self.deviceOrientation) {
                        photoOutputVideoConnection.videoOrientation = videoOrientation
                    }
                }*/
                
                photoOutput.capturePhoto(with: photoSettings, delegate: self)
            }
        print("test")
        print(self.takenPhotos.count)
        }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        print("photooutput")
        if (photo.previewPixelBuffer == nil) {
            print("bu nil")
        }
        else if (photo.previewPixelBuffer != nil) {
            print("bu nil deil")
        }
        showPreview(for: photo)
        if error != nil{
            //Testing thumbnail shit.
            print(error!.localizedDescription + "Zort2")
        }
        
        
    }
    
    func showPreview(for photo: AVCapturePhoto) {
            print("showpreview")
        if (photo.previewPixelBuffer == nil) {
            print("this is nil")
        }
        else if (photo.previewPixelBuffer != nil) {
            print("this is not nil")
        }
            guard let previewPixelBuffer = photo.previewPixelBuffer else { return }
            print("showpreview2")
            /*let ciImage = CIImage(cvPixelBuffer: previewPixelBuffer)
            print("showpreview3")
            let uiImage = UIImage(ciImage: ciImage)
            print("showpreview4")
            self.images.append(uiImage)
            //self.images.append(UIImage(systemName: "house")!)
            print("showpreview5")
        //print(self.images.count)*/
        
        if let previewPixelBuffer = photo.previewPixelBuffer,
           let uiImage = convertPixelBufferToUIImage(pixelBuffer: previewPixelBuffer) {
            // Now you have a UIImage that you can work with
            self.takenPhotos.append(uiImage)
        }
        
        }
    
    func convertPixelBufferToUIImage(pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraViewModel
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
