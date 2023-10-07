import SwiftUI
import PhotosUI

struct CameraView: View {
    
    @ObservedObject var camera = CameraViewModel()
    //@ObservedObject var recipeAddViewModel: RecipeAddViewModel
    @ObservedObject var recipeViewModel = RecipeViewModel.shared
    @State private var selectedPhoto: PhotosPickerItem?
    var index: Int
    //@State var selectedItems: [PhotosPickerItem] = [] //Testing PhotosPicker
    
    var body: some View{
        
        ZStack{
            
            /*CameraPreview(camera: camera) //CAMERA PREVIEW
                .ignoresSafeArea(.all, edges: .all)*/
            
            VStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(camera.allSelectedPhotos.indices, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: camera.allSelectedPhotos[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .clipped()
                                    .border(Color.gray, width: 2)
                                
                                Button(action: {
                                    withAnimation {
                                        DispatchQueue.main.async {
                                            // Remove the image from the array
                                            camera.allSelectedPhotos.remove(at: index)
                                        }
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding(4)
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    /*PhotosPicker(selection: $recipeAddViewModel.selectedItems, //ÇOKLU FOTO KODU
                                         matching: .images) {
                                Text("Select Multiple Photos")
                            }*/
                    PhotosPicker(selection: $recipeViewModel.selectedPhoto) {
                                Text("Select Photo")
                            }
                    Spacer()
                    /*Button(action: camera.takePhoto, label: { //CAMERA BUTTON MOVE IT ELSEWHERE MAYBE?
                        
                        ZStack{
                            Circle()
                                .fill(Color.black)
                                .frame(width: 65, height: 65)
                            
                            Circle()
                                .stroke(Color.black,lineWidth: 2)
                                .frame(width: 75, height: 75)
                        }
                    })*/
                }.onChange(of: recipeViewModel.selectedPhoto) { newItem in
                    Task {
                        if let data = try? await newItem!.loadTransferable(type: Data.self),
                           let photo = UIImage(data: data) {
                            if (index == -1) {
                                print("ZORTTTTTTT")
                                recipeViewModel.coverPhoto = photo
                            }
                            else {
                                /*if let steps = recipeViewModel.steps {
                                    recipeViewModel.steps?[index].image = image
                                }*/
                                //recipeViewModel.steps[index].image = image
                                recipeViewModel.steps?[index].stepPhoto = photo
                            }
                        }
                    }
                }
                
                /*.onChange(of: recipeAddViewModel.selectedPhoto ?? PhotosPickerItem(itemIdentifier: "")) { newValue in
                    Task {
                        print("HMMM")
                        /*if let imageData = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                            let uiImage = UIImage(data: imageData)
                            recipeAddViewModel.steps[0].image = uiImage
                            print("Hello")
                        }*/
                    }
                }*/

                /*.onChange(of: camera.selectedItems) { newItems in //CAMERA İÇİN
                    Task {
                        camera.session.startRunning()
                        camera.selectedPhotos = []
                        for item in newItems {
                            guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
                            guard let image = UIImage(data: data) else { continue }
                            camera.selectedPhotos.append(image)
                        }
                    }
                }*/
                /*.onChange(of: recipeAddViewModel.selectedItems) { newItems in
                    Task {
                        camera.session.startRunning()
                        recipeAddViewModel.selectedPhotos = []
                        for item in newItems {
                            guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
                            guard let image = UIImage(data: data) else { continue }
                            recipeAddViewModel.selectedPhotos.append(image)
                        }
                        //print(recipeAddViewModel.selectedItems.count)
                        //print(recipeAddViewModel.selectedPhotos.count)
                    }
                }*/
                /*ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(camera.images.indices, id: \.self) { index in
                            Image(uiImage: camera.images[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipped()
                        }
                    }
                }*/
            }
        }
        /*.onAppear(perform: { /// CAMERA CHECK
            camera.check()
        })
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }*/
    }
}

/*struct Previews_CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}*/
