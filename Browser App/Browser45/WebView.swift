//
//  WebView.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: WebUrlType
    @ObservedObject var viewModel: WebViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: viewModel.currentURL ?? "https://www.google.com") {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Only reload the web view if the URL has changed and the web view is not currently loading
        if let currentURL = viewModel.currentURL, let url = URL(string: currentURL) {
            if webView.url?.absoluteString != currentURL && !webView.isLoading {
                print("Reloading WebView with URL: \(currentURL)")
                webView.load(URLRequest(url: url))
            }
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Page finished loading")
            DispatchQueue.main.async {
                self.parent.viewModel.showLoader = false
            }

            webView.evaluateJavaScript("document.title") { response, error in
                if let title = response as? String {
                    DispatchQueue.main.async {
                        self.parent.viewModel.showWebTitle = title
                    }
                }
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Page started loading")
            DispatchQueue.main.async {
                self.parent.viewModel.showLoader = true
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Page failed to load: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.parent.viewModel.showLoader = false
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Provisional navigation failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.parent.viewModel.showLoader = false
            }
        }
    }
}