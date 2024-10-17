//
//  StartGameView.swift
//  Movidle
//
//  Created by Sidharth Datta on 10/10/24.
//

import SwiftUI

struct StartGameView: View {
    @Binding var path: [Route]
    @ObservedObject var viewModel: StartGameViewModel

    @Environment(\.presentationMode) var presentationMode
    @State private var isKeyboardVisible = false

    var body: some View {
        ZStack {
            // Background
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image(.film)
                    .foregroundColor(Constants.primaryColor)
                
                Text(StaticText.gameCode)
                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                    .foregroundColor(Constants.primaryColor)
                
                Text(viewModel.gameCode)
                    .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .padding(.bottom, -30)
                
                Button(action: viewModel.shareGameCode) {
                    Image(.share)
                        .foregroundColor(Constants.primaryColor)
                    
                    OutlinedText(text: StaticText.share,
                                 fontSize: Constants.secondaryFontSize, fontFamily: Constants.fontFamily, strokeWidth: 4, strokeColor: .white)
                    .frame(width: 200, height: 30, alignment: .center)
                }.padding(.horizontal, 40)
                
                Text(StaticText.startGameSubtitle)
                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                StyledTextField(text: $viewModel.userName, placeholder: StaticText.enterUsername)
                    .padding(.horizontal, 80)
                
                Button(action: viewModel.startGame) {
                    Text(StaticText.startGame)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.secondaryColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.primaryColor)
                        .cornerRadius(30)
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.horizontal, 40)
                .disabled(!viewModel.isStartGameButtonEnabled())
                .opacity(viewModel.isStartGameButtonEnabled() ? 1.0 : 0.5)
            }
        }
        .navigationBarHidden(true)
        .overlay(
            CustomBackButton(action: {
                path.removeLast()
            })
            .padding(.leading, 16)
            .padding(.top, 8),
            alignment: .topLeading
        ).onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }.sheet(isPresented: $viewModel.isSharePresented) {
            ShareSheet(activityItems: ["Join my Movidle game with code: \(viewModel.gameCode)"])
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView(path: .constant([.StartGameView]), viewModel: StartGameViewModel())
    }
}
