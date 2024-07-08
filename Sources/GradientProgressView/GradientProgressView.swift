//
//  GradientProgressView.swift
//
//
//  Created by Muhammad Ibrar on 08/07/2024.
//

import SwiftUI

/// A customizable gradient progress view that supports segmented colors and smooth gradient transitions.
public struct GradientProgressView: View {
    
    @Binding var progress: CGFloat
    var colors: [Color]
    var segmentedColors: [CGFloat: Color]? // Segmentation points for dynamic gradient
    var useSegmentedColors: Bool = false
    var backgroundColor: Color
    var height: CGFloat

    /// Initializes a new gradient progress view.
    ///
    /// - Parameters:
    ///   - progress: The binding to the progress value.
    ///   - colors: The colors to use for the gradient.
    ///   - segmentedColors: A dictionary specifying colors at specific progress points.
    ///   - useSegmentedColors: A flag to enable or disable segmented colors.
    ///   - height: The height of the progress view.
    ///   - backgroundColor: The  backgroundColor of the progress view. Default is gray.
    public init(
        progress: Binding<CGFloat>,
        colors: [Color],
        segmentedColors: [CGFloat: Color]? = nil,
        useSegmentedColors: Bool = false,
        backgroundColor: Color = .gray,
        height: CGFloat = 10
    ) {
        self._progress = progress
        self.colors = colors
        self.segmentedColors = segmentedColors
        self.useSegmentedColors = useSegmentedColors
        self.backgroundColor = backgroundColor
        self.height = height
    }

    public var body: some View {
        ProgressView(value: progress, total: 1.0)
            .progressViewStyle(GradientProgressViewStyle(
                colors: colors,
                segmentedColors: segmentedColors,
                useSegmentedColors: useSegmentedColors,
                height: height
            ))
            .frame(height: height)
    }
}
