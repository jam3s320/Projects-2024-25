//
//  TestDisplay.swift
//  Test
//
//  Created by Larry Liu on 2/23/24.
//

import SwiftUI

struct LunchView: View {
    @State private var date = Date()
    @State private var menuData: MenuData? = nil
    var stringDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: .date
                )
                    .onChange(of: date) {
                        loadMenu()
                    }
                    .padding(.horizontal, 25)

                if var menuData = menuData {
                    List(MenuCategory.allCases, id: \.self) { category in
                        Section(header: Text(category.rawValue)) {
                            ForEach(menuData.categories[category] ) { item in
                                Text(item.name)
                            }
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            .navigationTitle("Today's Menu")
            .onAppear { loadMenu() }
        }
    }

    private func loadMenu() {
        menuData = nil
        MenuService().getData(for: stringDate, completion: { result in
            switch result {
            case .success(let data):
                menuData = data
            case .failure(let error):
                print(error)
            }
        })
    }
}
