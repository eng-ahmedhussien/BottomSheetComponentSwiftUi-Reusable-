//
//  BottomSheetView.swift
//
//  Created by ahmed hussien on 13/08/2023.
//


import SwiftUI



fileprivate enum Constants {
      static let radius: CGFloat = 16
      static let indicatorHeight: CGFloat = 4
      static let indicatorWidth: CGFloat = 60
      static let snapRatio: CGFloat = 0.25
      static let minHeightRatio: CGFloat = 0.3
  }
  
struct BottomSheetView<Content: View>: View {
      @Binding var isOpen: Bool
      let maxHeight: CGFloat
      let minHeight: CGFloat
      let content: Content
      @State var animted  = false

      @GestureState private var translation: CGFloat = 0

      private var offset: CGFloat {
          isOpen ? 0 : maxHeight - minHeight
      }

      private var indicator: some View {
          RoundedRectangle(cornerRadius: Constants.radius)
              .fill(Color.gray)
          .frame(
            width: Constants.indicatorWidth,
            height: Constants.indicatorHeight
          ).onTapGesture {
              withAnimation(.linear) {
                  self.isOpen.toggle()
              }
          }
      }

      init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
          self.minHeight = maxHeight * Constants.minHeightRatio
          self.maxHeight = maxHeight
          self.content = content()
          self._isOpen = isOpen
         
      }

      var body: some View {
          GeometryReader {
              geometry in
              VStack(spacing: 0) {
                  self.indicator.padding()
                  Text("Update profile photo")
                 // Spacer()
                  Divider()
                      .padding()
                  self.content
                  
              }
              .cornerRadius(25)
              .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
              .background(Color.theme.bgWhite)
              .cornerRadius(Constants.radius)
              .frame(height: geometry.size.height, alignment: .bottom)
              .offset(y:max(self.offset + self.translation, 0))
              .gesture(DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                       }.onEnded { value in
                        let snapDistance = self.maxHeight * Constants.snapRatio
                        guard abs(value.translation.height) > snapDistance else { return}
                        self.isOpen = value.translation.height < 0
                       })
          }
      }
  }
