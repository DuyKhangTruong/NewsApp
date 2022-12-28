//
//  RetryView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/21/22.
//

import SwiftUI

struct RetryView: View {
    let text: String
    let retryAction: () -> ()
    var body: some View {
        VStack(spacing:8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            Button {
                retryAction()
            } label: {
                Text("Try again")
            }

        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "ERROR with retry view") {
            // Dummy
        }
    }
}
