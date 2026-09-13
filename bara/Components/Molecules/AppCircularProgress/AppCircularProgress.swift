//
//  AppCircularProgress.swift
//  bara
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import SwiftUI
import WidgetKit

struct AppCircularCountdownView: View {
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        ZStack(alignment: .center){

            ProgressView(
                timerInterval: startDate...endDate,
                countsDown: true
            ) {
                // Empty label
            } currentValueLabel: {
                // Sembunyikan label bawaan
                EmptyView()
            }
            .progressViewStyle(.circular) // Mengubah style menjadi lingkaran
            .tint(Color.primaryColorPurple) // Warna garis progress
            .scaleEffect(1.3) // Memperbesar sedikit ukuran lingkaran jika diperlukan
            
            // 2. Teks Waktu Countdown di Tengah Lingkaran
            HStack{
                Spacer()
                Text(timerInterval: startDate...endDate, countsDown: true)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .monospacedDigit() // Supaya ukuran angka stabil/tidak bergoyang
                    .foregroundColor(Color.primaryColorPurple)
                Spacer()
            }
                
        }
        .frame(width: 44, height: 44) // Ukuran container circular
    }
}
