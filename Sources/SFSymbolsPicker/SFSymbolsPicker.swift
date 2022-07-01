//
//  SFSymbolsPicker.swift
//
//
//  Created by Alessio Rubicini on 05/01/21.
//

import SwiftUI
import Foundation

public struct SFSymbolsPicker: View {
    
    // MARK: - View properties
    
    @Binding public var isPresented: Bool
    @Binding public var icon: String
    @State var category: Category
    let axis: Axis.Set
    let haptic: Bool
    let searchText: String?
    let canSelectCategory: Bool
    let scrollable: Bool
    
    var list: [String] {
        if category == .none {
            var returningArray = [String]()
            
            for name in Category.allCases {
                returningArray.append(contentsOf: symbols[name.rawValue] ?? [])
            }
            
            return returningArray
        } else {
            return symbols[category.rawValue] ?? []
        }
    }
    
    var filtredList: [String] {
        if searchText?.isEmpty ?? true {
            return list
        } else {
            return list.filter {
                $0.lowercased().contains(searchText!.lowercased())
            }
        }
    }
    
    /// Show a picker to select SF Symbols
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier's
    ///   - icon: A binding to a String value that determines which icon has been selected
    ///   - category: Custom enum Category that determines which type of icons should be displayed
    ///   - axis: ScrollView axis (vertical by default)
    ///   - haptic: If true a small haptic feedback is generated when an icon is selected (true by default)
    public init(isPresented: Binding<Bool>, icon: Binding<String>, category: Category, axis: Axis.Set = .horizontal, haptic: Bool = true, searchText: String? = nil, canSelectCategory: Bool = false, scrollable: Bool = false) {
        self._isPresented = isPresented
        self._icon = icon
        self._category = State(initialValue: category)
        self.axis = axis
        self.haptic = haptic
        self.searchText = searchText
        self.canSelectCategory = canSelectCategory
        self.scrollable = scrollable
    }

    
    // MARK: - View body
    
    public var body: some View {
        if isPresented {
            VStack {
                if canSelectCategory {
                    ScrollView(.horizontal) {
                        HStack {
                            Button {
                                category = .none
                            } label: {
                                Text("All")
                                    .padding(3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.blue, lineWidth: 1)
                                    )
                                    .padding()
                                    .font(.caption)
                            }
                            
                            ForEach(Category.allCases) { caseCategory in
                                if caseCategory != .none {
                                    Button {
                                        category = caseCategory
                                    } label: {
                                        Text(caseCategory.rawValue)
                                            .padding(3)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.blue, lineWidth: 1)
                                            )
                                            .padding()
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if scrollable {
                    ScrollView(axis) {
                       icons()
                    }
                } else {
                    icons()
                }
            }
        }
    }
    
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
    }
    
    func icons() -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 20)]) {
            ForEach(filtredList, id: \.hash) { icon in
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .animation(.linear)
                    .foregroundColor(self.icon == icon ? Color.blue : Color.primary)
                    .onTapGesture {
                        
                        // Assign binding value
                        withAnimation {
                            self.icon = icon
                        }
                        
                        // Generate haptic
                        if self.haptic {
                            self.impactFeedback(style: .medium)
                        }
                    }
                
            }
            .padding(.horizontal, 5)
        }
    }
}




struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsPicker(isPresented: .constant(false), icon: .constant("pencil"), category: .commerce, axis: .horizontal)
    }
}
