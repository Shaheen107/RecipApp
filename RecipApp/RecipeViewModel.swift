import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func deleteRecipe(at offsets: IndexSet) {
        recipes.remove(atOffsets: offsets)
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
        }
    }
    
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            recipes[index] = updatedRecipe
        }
    }
    
    func toggleFavorite(for recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
        }
    }
}
