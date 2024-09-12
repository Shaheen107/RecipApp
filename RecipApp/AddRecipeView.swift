import SwiftUI

struct AddRecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Recipe Title", text: $title)
                }
                Section(header: Text("Ingredients")) {
                    TextEditor(text: $ingredients)
                        .frame(height: 200)
                }
                Section(header: Text("Instructions")) {
                    TextEditor(text: $instructions)
                        .frame(height: 200)
                }
            }
            .navigationBarTitle("Add Recipe")
            .navigationBarItems(trailing: Button("Save") {
                if title.isEmpty || ingredients.isEmpty || instructions.isEmpty {
                    alertTitle = "Error"
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                } else {
                    let newRecipe = Recipe(title: title, ingredients: ingredients, instructions: instructions)
                    viewModel.addRecipe(newRecipe)
                    alertTitle = "Success"
                    alertMessage = "Recipe added successfully."
                    showAlert = true
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(viewModel: RecipeViewModel())
    }
}
