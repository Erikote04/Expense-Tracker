//
//  LockView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 31/10/24.
//

import LocalAuthentication
import SwiftUI

struct LockView<Content: View>: View {
    @Environment(\.scenePhase) private var phase
    
    @State private var pin: String = ""
    @State private var isUnlocked: Bool = false
    @State private var animateField: Bool = false
    @State private var noBiometricAccess: Bool = false
    
    private let context = LAContext()
    
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var isAppLockInBackground: Bool = false
    var forgotPin: () -> Void = { }
    
    var isBiometricAvailable: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    @ViewBuilder var content: Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentication in Settings to unlock the view.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(48)
                            } else {
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 96, height: 96)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 96, height: 48)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && isAppLockInBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    private func unlockView() {
        Task {
            if isBiometricAvailable && lockType != .pin {
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View"), result {
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }

                }
            }
            
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 16) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both && isBiometricAvailable {
                        Button {
                            pin = ""
                            noBiometricAccess = false
                        } label: {
                            Image(systemName: "arrow.backward")
                                .font(.title3)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            HStack(spacing: 8) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 48, height: 56)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField){ content, value in
                content
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            }
            .padding(.top, 16)
            .overlay(alignment: .bottom) {
                Button("Forgot Pin?", action: forgotPin)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .offset(y: 48)
            }
            .frame(maxHeight: .infinity)
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(1...9, id: \.self) { number in
                        Button {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        } label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                    }
                    
                    Button {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                    
                    Button {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    } label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    HomeView()
}
