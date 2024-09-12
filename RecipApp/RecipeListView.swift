import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel = RecipeViewModel()
    @State private var showingAddRecipeView = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var deleteOffsets: IndexSet?
    @State private var showFavoritesOnly = false
    @State private var searchText = ""

    var filteredRecipes: [Recipe] {
        let baseRecipes = showFavoritesOnly ? viewModel.recipes.filter { $0.isFavorite } : viewModel.recipes
        return baseRecipes.filter { $0.title.lowercased().contains(searchText.lowercased()) || searchText.isEmpty }
    }

    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Show Favorites Only")
                }
                .padding()
                
                SearchBar(text: $searchText)
                
                List {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(viewModel: viewModel, recipe: recipe)) {
                            HStack {
                                Text(recipe.title)
                                Spacer()
                                if recipe.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        deleteOffsets = indexSet
                        alertTitle = "Confirm Delete"
                        alertMessage = "Are you sure you want to delete this recipe?"
                        showAlert = true
                    }
                }
                .navigationBarTitle("Recipes")
                .navigationBarItems(trailing: Button(action: {
                    showingAddRecipeView = true
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddRecipeView) {
                    AddRecipeView(viewModel: viewModel)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .destructive(Text("Delete")) {
                        if let offsets = deleteOffsets {
                            viewModel.deleteRecipe(at: offsets)
                        }
                    }, secondaryButton: .cancel())
                }
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
