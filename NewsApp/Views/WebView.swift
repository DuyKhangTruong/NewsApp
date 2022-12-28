//
//  WebView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/20/22.
//

import SafariServices
import SwiftUI

struct WebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        let webVC = SFSafariViewController(url: url)
        return webVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
