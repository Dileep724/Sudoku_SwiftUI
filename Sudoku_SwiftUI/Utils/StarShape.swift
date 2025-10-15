//
//  StarShape.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let starPoints = 5
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()
        let angle = Double.pi / Double(starPoints)

        for i in 0..<starPoints * 2 {
            let length = i % 2 == 0 ? radius : radius / 2
            let x = center.x + CGFloat(cos(Double(i) * angle - Double.pi/2) * length)
            let y = center.y + CGFloat(sin(Double(i) * angle - Double.pi/2) * length)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}
