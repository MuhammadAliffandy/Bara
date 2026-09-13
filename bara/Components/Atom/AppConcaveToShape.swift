//
//  AppConcaveToShape.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

// 1. Membuat Custom Shape
struct AppConcaveTopShape: Shape {
    var dip: CGFloat = 60         // Seberapa dalam lengkungan di bagian atas
    var cornerRadius: CGFloat = 40 // Tingkat kelengkungan di sudut bawah

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Titik mulai dari kiri atas
        path.move(to: CGPoint(x: 0, y: 0))

        // Lengkungan melengkung ke dalam (concave) menuju kanan atas
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: 0),
            control: CGPoint(x: rect.width / 2, y: dip) // Titik kontrol ditarik ke bawah (Y positif)
        )

        // Garis lurus ke sudut kanan bawah
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))

        // Membuat lengkungan siku di kanan bawah
        path.addArc(
            center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )

        // Garis lurus ke sudut kiri bawah
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))

        // Membuat lengkungan siku di kiri bawah
        path.addArc(
            center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )

        // Menutup bentuk kembali ke kiri atas
        path.closeSubpath()

        return path
    }
}
