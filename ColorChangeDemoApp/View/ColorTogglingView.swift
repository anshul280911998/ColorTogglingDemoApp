//
//  ColorTogglingView.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import SwiftUI


struct ColorTogglingView: View {
    @StateObject private var viewModel: ColorTogglingViewModel
    
    init(viewModel: ColorTogglingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Full-screen white background - must be first
            Color.white
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Loading indicator
                    if viewModel.isLoading && viewModel.vehicle1 == nil {
                        ProgressView("Loading vehicles...")
                            .padding(.top, 100)
                    } else {
                        
                        // Two vehicle boxes
                        VStack(spacing: 20) {
                            
                            // First vehicle box (Car)
                            VStack(spacing: 8) {
                                Text(viewModel.vehicle1Name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Rectangle()
                                    .fill(viewModel.vehicle1Color)
                                    .frame(width: 100, height: 50)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                
                                Text("Current color: \(viewModel.vehicle1?.color ?? "N/A")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // Second vehicle box (Truck)
                            VStack(spacing: 8) {
                                Text(viewModel.vehicle2Name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Rectangle()
                                    .fill(viewModel.vehicle2Color)
                                    .frame(width: 100, height: 50)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                
                                Text("Current color: \(viewModel.vehicle2?.color ?? "N/A")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Swap Colors Button
                        Button(action: {
                            Task { await viewModel.swapColors() }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                
                                Text("Swap Colors")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(viewModel.isLoading ? Color.gray : Color.blue)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 30)
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // API Status Text Field
                        VStack(alignment: .leading, spacing: 4) {
                            Text("API Status:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            TextField("API Status", text: .constant(viewModel.apiStatus))
                                .font(.system(size: 12, design: .monospaced))
                                .padding(8)
                                .background(getStatusBackgroundColor(for: viewModel.lastStatusCode))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(getStatusBorderColor(for: viewModel.lastStatusCode), lineWidth: 1)
                                )
                                .disabled(true)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                }
                .padding()
            }
            
            // Full-screen loader overlay when API call is in progress
            if viewModel.isLoading && viewModel.vehicle1 != nil {
                Color.black.opacity(0.3)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("Processing...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(30)
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .task {
            await viewModel.loadVehicles()
        }
    }
}

#Preview {
    let container = DependencyContainer()
    return ColorTogglingView(viewModel: container.makeColorTogglingViewModel())
        .preferredColorScheme(.light)
}

// MARK: - Helper Functions
extension ColorTogglingView {
    private func getStatusBackgroundColor(for statusCode: Int) -> Color {
        if statusCode >= 200 && statusCode < 300 { return Color.green.opacity(0.1) }
        if statusCode >= 400 && statusCode < 500 { return Color.orange.opacity(0.1) }
        if statusCode >= 500 { return Color.red.opacity(0.1) }
        return Color.gray.opacity(0.1)
    }
    
    private func getStatusBorderColor(for statusCode: Int) -> Color {
        if statusCode >= 200 && statusCode < 300 { return Color.green }
        if statusCode >= 400 && statusCode < 500 { return Color.orange }
        if statusCode >= 500 { return Color.red }
        return Color.gray
    }
}
