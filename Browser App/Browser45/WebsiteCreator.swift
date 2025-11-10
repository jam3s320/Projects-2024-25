//
//  WebsiteCreator.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import SwiftUI

struct WebsiteCreator: View {
    @ObservedObject var viewModel: WebViewModel

    var body: some View {
        ZStack {
            WebView(url: .publicUrl, viewModel: viewModel)

            if viewModel.showLoader {
                LoadingView()
            }
        }
    }
}