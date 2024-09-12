import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State var recipe: Recipe
    @State private var isEditing = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var showDeleteAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    var body: some View {
        VStack {
            if isEditing {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Recipe Title", text: $recipe.title)
                    }
                    Section(header: Text("Ingredients")) {
                        TextEditor(text: $recipe.ingredients)
                            .frame(height: 200)
                    }
                    Section(header: Text("Instructions")) {
                        TextEditor(text: $recipe.instructions)
                            .frame(height: 200)
                    }
                }
                .navigationBarTitle("Edit Recipe", displayMode: .inline)
                .navigationBarItems(trailing: Button("Save") {
                    if recipe.title.isEmpty || recipe.ingredients.isEmpty || recipe.instructions.isEmpty {
                        alertTitle = "Error"
                        alertMessage = "Please fill in all fields."
                        showErrorAlert = true
                    } else {
                        viewModel.updateRecipe(recipe)
                        alertTitle = "Success"
                        alertMessage = "Recipe updated successfully."
                        showSuccessAlert = true
                        isEditing = false
                    }
                })
                .alert(isPresented: $showSuccessAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                            .font(.largeTitle)
                            .padding(.bottom, 10)
                        Text("Ingredients")
                            .font(.headline)
                        Text(recipe.ingredients)
                            .padding(.bottom, 10)
                        Text("Instructions")
                            .font(.headline)
                        Text(recipe.instructions)
                    }
                    .padding()
                }
                .navigationBarTitle(recipe.title, displayMode: .inline)
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        recipe.isFavorite.toggle()
                        viewModel.updateRecipe(recipe)
                    }) {
                        Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                            .foregroundColor(recipe.isFavorite ? .yellow : .gray)
                    }
                    Button(action: {
                        isEditing = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        showDeleteAlert = true
                        alertTitle = "Confirm Delete"
                        alertMessage = "Are you sure you want to delete this recipe?"
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                })
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteRecipe(recipe)
                        alertTitle = "Deleted"
                        alertMessage = "Recipe deleted successfully."
                        showSuccessAlert = true
                    }, secondaryButton: .cancel())
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .onAppear {
            // This will re-bind the recipe object to reflect changes immediately
            if let updatedRecipe = viewModel.recipes.first(where: { $0.id == recipe.id }) {
                recipe = updatedRecipe
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(viewModel: RecipeViewModel(), recipe: Recipe(title: "Sample", ingredients: "Sample Ingredients", instructions: "Sample Instructions"))
    }
}
