//
//  ContentView.swift
//  FreeTv
//
//  Created by James Mallari on 5/9/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = context.coordinator

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow only freetv.xconnect.to
            if let url = navigationAction.request.url,
               url.host?.contains("freetv.xconnect.to") == true {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        WebView(urlString: "https://freetv.xconnect.to")
            .edgesIgnoringSafeArea(.all)
    }
}
