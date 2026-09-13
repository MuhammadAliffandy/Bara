//
//  Home.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI
import SwiftData

struct HomeView: View{
    
    @EnvironmentObject private var router: AppRouter
    
    @State private var viewModel = HomeViewModel()
    @State private var showSettings = false
    @State private var showRecapLog = false
    @Query private var sessions: [WorkSession]
    
    // Animation States
    @State private var isFadingContent = false
    @State private var isAnimatingFrontTrees = false
    @State private var isAnimatingBackTrees = false
    
    var body: some View{
        VStack(spacing : AppSpacing.regular ){
            
            
            HStack{
                Spacer()
                
                AppIconCircleButton(
                    icon: AppIcon.GearShapeFill,
                    iconSize: AppIconSize.regular * 1.2,
                    backgroundColor: Color(UIColor.systemGray2),
                    action:{
                        showSettings = true
                    }
                )
            
                .padding(.top, AppPadding.regular * 3)
            }
            
            Spacer()
            
            AppButton(
                action: {
                    // 1. Pudar konten Home
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isFadingContent = true
                    }
                    
                    // 2. Pohon depan bergerak keluar
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isAnimatingFrontTrees = true
                    }
                    
                    // 3. Pohon belakang bergerak keluar menyusul setelah 0.4 detik
                    withAnimation(.easeInOut(duration: 1.0).delay(0.4)) {
                        isAnimatingBackTrees = true
                    }
                    
                    // 4. Setelah animasi hampir selesai (sekitar 1.4 detik), masuk ke WorkStart
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        AppStorageService.shared.isWorking = true
                        AppFamilyControlService.shared.startShielding()
                        
                        // Reset state animasi agar saat kembali tidak tersangkut
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isFadingContent = false
                            isAnimatingFrontTrees = false
                            isAnimatingBackTrees = false
                        }
                    }
                },
                textButton: "Start Work",
                textColor: .white,
                backgroundColor: Color.primaryColorPurple
            )
            
            Button(action: {
                showRecapLog = true
            }) {
                HStack(alignment : .center){
                    
                    Image(systemName: "list.clipboard.fill")
                        .foregroundStyle(Color.primaryColorPurple)
                        .font(.system(size: AppIconSize.regular * 4))
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: AppSpacing.regular){
                        AppText(
                            text: "Today's Recap",
                            textColor: .black,
                            fontStyle: .appTitle
                        )
                        
                        HStack{
                            HStack{
                                AppText(
                                    text:  "\(viewModel.todayCommitCount)",
                                    textColor: .primaryColorPurple,
                                    fontStyle: .appTitle
                                )
                                AppText(
                                    text: "Commit",
                                    textColor: .primaryColorPurple,
                                    fontStyle: .appHeadline
                                )
                                .bold()
                            }
                            
                            HStack{
                                AppText(
                                    text: "\(viewModel.todayDismissCount)",
                                    textColor: .textColorPrimaryOrange,
                                    fontStyle: .appTitle
                                )
                                AppText(
                                    text: "Dismiss",
                                    textColor: .textColorPrimaryOrange,
                                    fontStyle: .appHeadline
                                )
                                .bold()
                            }
                            
                        }
                        
                        AppText(
                            text: "See full summary",
                            textColor: .textColorSecondaryBlackGrey,
                            fontStyle: .appCaption
                        )
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: AppIcon.ChevronRightIcon)
                        .foregroundStyle(Color.primaryColorPurple)
                        .font(.system(size: AppIconSize.regular))
                    
                        
                }
                .padding(.vertical, AppPadding.regular)
                .padding(.horizontal , AppPadding.medium * 1.5)
                .background(Color.secondaryColorPurple)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.regular))
            }
            
            
            
            
        }
        .padding(AppPadding.medium)
        .padding(.bottom, AppPadding.medium * 2)
        .opacity(isFadingContent ? 0 : 1)
        .background(
            ZStack {
                    // Layer 1 (Paling Belakang)
                    Image(AppImage.ImageFireHome)
                        .resizable()
                        .scaledToFill()
                    
                    Image(AppImage.ImageTreeBackLeft)
                        .resizable()
                        .scaledToFill()
                        .offset(x: isAnimatingBackTrees ? -1000 : 0)
                        .opacity(isAnimatingBackTrees ? 0 : 1)
                    
                    
                    Image(AppImage.ImageTreeBackRight)
                        .resizable()
                        .scaledToFill()
                        .offset(x: isAnimatingBackTrees ? 1000 : 0)
                        .opacity(isAnimatingBackTrees ? 0 : 1)
                
                    Image(AppImage.ImageTreeFrontLeft)
                        .resizable()
                        .scaledToFill()
                        .offset(x: isAnimatingFrontTrees ? -1000 : 0)
                        .opacity(isAnimatingFrontTrees ? 0 : 1)
                
                    Image(AppImage.ImageTreeFrontRight)
                        .resizable()
                        .scaledToFill()
                        .offset(x: isAnimatingFrontTrees ? 1000 : 0)
                        .opacity(isAnimatingFrontTrees ? 0 : 1)
                    
                }
                
            
            
            
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear {
           viewModel.updateRecap(from: sessions)
        }
        .onChange(of: sessions) { oldValue, newValue in
            viewModel.updateRecap(from: newValue)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showRecapLog) {
            RecapLogView()
        }
        
    }
    
}

#Preview{
    HomeView()
}
