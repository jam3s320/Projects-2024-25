//
//  HomePage.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import SwiftUI

struct HomePage: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var webViewModel = WebViewModel()
    @State private var showWebView = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    TextField("Search or enter address", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .padding(.horizontal, 8)
                        .onSubmit {
                            if !searchText.isEmpty {
                                webViewModel.updateURL(searchText)
                                showWebView = true
                            }
                        }

                    Button(action: {
                        if !searchText.isEmpty {
                            webViewModel.updateURL(searchText)
                            showWebView = true
                        }
                    }) {
                        Text("GO")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4, style: .circular)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemGray6))
                )
                .padding(.horizontal)

                // Favorites Section
                if !homeViewModel.favorites.isEmpty {
                    Section(header: Text("Favorites")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 16)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(homeViewModel.favorites) { favorite in
                                    VStack {
                                        Image(systemName: favorite.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.blue)
                                        Text(favorite.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .onTapGesture {
                                        webViewModel.updateURL(favorite.url)
                                        showWebView = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Bookmarks Section
                if !homeViewModel.bookmarks.isEmpty {
                    Section(header: Text("Bookmarks")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 16)) {
                        List(homeViewModel.bookmarks) { bookmark in
                            HStack {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(bookmark.title)
                                        .font(.headline)
                                    Text(bookmark.url)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture {
                                webViewModel.updateURL(bookmark.url)
                                showWebView = true
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }

                Spacer()
            }
            .navigationTitle("Browser")
            .background(
                NavigationLink(
                    destination: WebsiteCreator(viewModel: webViewModel),
                    isActive: $showWebView,
                    label: { EmptyView() }
                )
            )
        }
    }
}