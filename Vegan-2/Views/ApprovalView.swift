//
//  ApprovalView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 20.08.2023.
//

/*import Foundation
import SwiftUI

struct ApprovalView: View {
    @ObservedObject var recipeStore = RecipeManager.shared
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    @State private var isModalPresented = false
    
    /*@State private var steps: [Step] = [
        Step("Mix the ingredients."),
        Step(Image(systemName: "person.fill")),
        Step("Bake for 30 minutes."),
        Step(Image(systemName: "circle.fill"))
    ]*/
    
    var body: some View {
        /*List(recipeStore.recipes) { recipe in
                    HStack {
                        recipe.images[0]
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(recipe.title)
                    }
                }*/
        List {
            /*ForEach(0..<items.count, id: \.self) { index in
                TextField("Item Name", text: $items[index])
            }
            .onDelete(perform: deleteItem)
            .onMove(perform: moveItem)*/
            /*ForEach(steps.indices, id: \.self) { index in
                switch steps[index].type {
                        case .text(let text):
                            Text(text)
                        case .image(let image):
                            image
                                .resizable()
                                .scaledToFit()  // Or any other view modifier you want
                        }
            }
            .onDelete(perform: deleteItem)
                .onMove(perform: moveItem)*/
        }
        .navigationTitle("Editable List")
        .toolbar {
            EditButton()
            /*Button("Preview", action: {
                isModalPresented.toggle()
                    }).sheet(isPresented: $isModalPresented) {
                        RecipeView(index: 0)
                    }*/
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
            //steps.remove(atOffsets: offsets)
        }
        
        func moveItem(from source: IndexSet, to destination: Int) {
            //steps.move(fromOffsets: source, toOffset: destination)
        }
}

struct ApprovalView_Previews: PreviewProvider {
    static var previews: some View {
        ApprovalView()
    }
}*/
