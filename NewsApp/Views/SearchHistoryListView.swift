//
//  SearchHistoryListView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/25/22.
//

import SwiftUI

struct SearchHistoryListView: View {
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubmit : (String) -> ()
    var body: some View {
        List {
            HStack {
                Text("Recently Searched")
                Spacer()
                Button {
                    searchVM.removeAllHistory()
                } label: {
                    Text("Clear")
                }

            }
            .listRowSeparator(.hidden)
            
            
            ForEach(searchVM.historySearch, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                }
            }
        }
        
        .listStyle(.sidebar)
       
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(searchVM: ArticleSearchViewModel.shared) {_ in
            //TODO: Later
        }
    }
}
