//
//  RecentsView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct RecentsView: View {
    @AppStorage("userName") private var userName: String = ""
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                        Section {
                            Button {
                                
                            } label: {
                                Text("\(format(date: startDate, format: "dd MMM yy")) to \(format(date: endDate, format: "dd MMM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            .horizontalSpacing(.leading)
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .visualEffect{ content, geometry in
                content.scaleEffect(headerScale(size, proxy: geometry), anchor: .topLeading)
            }
            
            Spacer(minLength: 0)
            
            NavigationLink {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, userName.isEmpty ? 8 : 4)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()
            }
            .visualEffect{ content, geometry in
                content.opacity(headerBackgroundOpacity(geometry))
            }
            .padding(.horizontal, -16)
            .padding(.top, -(safeArea.top + 16))
        }
    }
    
    func headerBackgroundOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 16)
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.4
        
        return 1 + scale
    }
}

#Preview {
    RecentsView()
}
