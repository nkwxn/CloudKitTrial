//
//  TODOView.swift
//  TODOSync (iOS)
//
//  Created by Nicholas on 25/10/21.
//

import SwiftUI

struct TODOView: View {
    @StateObject var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(viewModel.todos.enumerated()), id: \.0) {
                    Text($1.name ?? "")
                }
                .onDelete(perform: viewModel.deletItem)
            }
            .navigationTitle("TODO List")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {viewModel.addNewItem("Todo at \(Date())")}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct TODOView_Previews: PreviewProvider {
    static var previews: some View {
        TODOView()
    }
}
