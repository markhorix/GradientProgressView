//
//  GradientProgressViewStyle.swift
//
//
//  Created by Muhammad Ibrar on 08/07/2024.
//

import SwiftUI

/// A custom progress view style that supports gradient colors based on the progress value.
struct GradientProgressViewStyle: ProgressViewStyle {
    
    var colors: [Color]
    var segmentedColors: [CGFloat: Color]? // Segmentation points for dynamic gradient
    var useSegmentedColors: Bool = false
    var height: CGFloat
    var backgroundColor: Color

    /// Initializes a new gradient progress view style.
    ///
    /// - Parameters:
    ///   - colors: The colors to use for the gradient.
    ///   - segmentedColors: A dictionary specifying colors at specific progress points.
    ///   - useSegmentedColors: A flag to enable or disable segmented colors.
    ///   - height: The height of the progress view.
    ///   - backgroundColor: The backgroundColor of the progress view. Default is gray.
    public init(colors: [Color],
                segmentedColors: [CGFloat: Color]? = nil,
                useSegmentedColors: Bool = false,
                backgroundColor: Color = .gray,
                height: CGFloat = 10) {
        self.colors = colors
        self.segmentedColors = segmentedColors
        self.useSegmentedColors = useSegmentedColors
        self.backgroundColor = backgroundColor
        self.height = height
    }

    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geometry.size.width, height: height)
                
                if useSegmentedColors, let segmentedColors = segmentedColors {
                    let gradient = dynamicGradient(for: CGFloat(configuration.fractionCompleted ?? 0))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(gradient)
                        .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: height)
                        .animation(.linear(duration: 0.5), value: configuration.fractionCompleted)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: height)
                        .animation(.linear(duration: 0.5), value: configuration.fractionCompleted)
                }
            }
        }
        .padding()
    }
    
    /// Generates a dynamic gradient based on the progress value.
    ///
    /// - Parameter progress: The current progress value.
    /// - Returns: A linear gradient with interpolated colors.
    private func dynamicGradient(for progress: CGFloat) -> LinearGradient {
        guard let segmentedColors = segmentedColors else {
            return LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        }
        
        var gradientColors: [Color] = []
        let sortedKeys = segmentedColors.keys.sorted()
        
        for i in 0..<sortedKeys.count {
            let key = sortedKeys[i]
            if key <= progress {
                gradientColors.append(segmentedColors[key]!)
            } else {
                if i > 0 {
                    let previousKey = sortedKeys[i - 1]
                    let previousColor = segmentedColors[previousKey]!
                    let nextColor = segmentedColors[key]!
                    let interpolatedColor = interpolateColor(from: previousColor, to: nextColor, progress: (progress - previousKey) / (key - previousKey))
                    gradientColors.append(interpolatedColor)
                }
                break
            }
        }
        
        if gradientColors.isEmpty {
            gradientColors.append(segmentedColors[sortedKeys.first!]!)
        }
        if gradientColors.count == 1 {
            gradientColors.append(gradientColors.first!)
        }
        
        return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
    }
    
    /// Interpolates between two colors based on the progress value.
    ///
    /// - Parameters:
    ///   - from: The starting color.
    ///   - to: The ending color.
    ///   - progress: The progress value.
    /// - Returns: The interpolated color.
    private func interpolateColor(from: Color, to: Color, progress: CGFloat) -> Color {
        let fromComponents = rgbaComponents(from)
        let toComponents = rgbaComponents(to)
        
        let r = fromComponents.red + (toComponents.red - fromComponents.red) * progress
        let g = fromComponents.green + (toComponents.green - fromComponents.green) * progress
        let b = fromComponents.blue + (toComponents.blue - fromComponents.blue) * progress
        let a = fromComponents.alpha + (toComponents.alpha - fromComponents.alpha) * progress
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    /// Extracts the RGBA components from a color.
    ///
    /// - Parameter color: The color to extract components from.
    /// - Returns: A tuple containing the RGBA components.
    private func rgbaComponents(_ color: Color) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let scanner = Scanner(string: color.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            let r, g, b, a: CGFloat
            switch color.description.count {
            case 9: // #RRGGBBAA
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
            case 7: // #RRGGBB
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                a = 1.0
            case 5: // #RGBA
                r = CGFloat((hexNumber & 0xf000) >> 12) / 15
                g = CGFloat((hexNumber & 0x0f00) >> 8) / 15
                b = CGFloat((hexNumber & 0x00f0) >> 4) / 15
                a = CGFloat(hexNumber & 0x000f) / 15
            case 4: // #RGB
                r = CGFloat((hexNumber & 0xf00) >> 8) / 15
                g = CGFloat((hexNumber & 0x0f0) >> 4) / 15
                b = CGFloat(hexNumber & 0x00f) / 15
                a = 1.0
            default:
                return (0, 0, 0, 1)
            }
            return (r, g, b, a)
        }
        return (0, 0, 0, 1)
    }
}
