//
//  ContentView.swift
//  AnimatedTags
//
//  Created by Yuriy Pashkov on 17.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: TagsViewModel = TagsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // header
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(viewModel.selectedTags, id: \.self) { tag in
                        TagView(tag: tag, color: .pink, icon: "checkmark")
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    viewModel.removeTag(tag)
                                }
                            }
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 36)
                .padding(.vertical, 16)
            }
            .background(.white)
            .overlay {
                if viewModel.selectedTags.isEmpty {
                    Text("Select 3 or more tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            
            // body
            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 12) {
                    ForEach(viewModel.filterSelectedTags(), id: \.self) { tag in
                        TagView(tag: tag, color: .blue, icon: "plus")
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    viewModel.selectedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding(16)
            }
            .background(.black.opacity(0.075))
            
            // footer
            ZStack {
                Button(action: {
                     
                }, label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.pink.gradient)
                        }
                })
                .disabled(viewModel.selectedTags.count < 3)
                .opacity(viewModel.selectedTags.count < 3 ? 0.5 : 1)
                .padding()
            }
            .background(.white)
        } // main vstack ends
    }
    
    // make tag
    @ViewBuilder
    private func TagView(tag: String, color: Color, icon: String) -> some View {
        HStack(spacing: 12) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            Image(systemName: icon)
        }
        .frame(height: 36)
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .background {
            Capsule()
                .fill(color.gradient)
        }
    }
}

#Preview {
    ContentView()
}
