# GradientProgressView

**GradientProgressView** is a customizable SwiftUI view that displays a progress bar with dynamic gradient colors. It supports smooth gradient transitions and segmented colors, allowing you to create visually appealing progress indicators with customizable colors and heights.


![Demo](https://github.com/markhorix/GradientProgressView/assets/28727450/f98eae70-b159-4f8d-9122-fa3238c585fe)


## Features

- **Dynamic Gradient**: Smoothly transitions between colors based on progress.
- **Segmented Colors**: Define color segments at specific progress points.
- **Customizable Background Color**: Change the background color of the progress view.
- **Customizable Height**: Adjust the height of the progress view.
- **Animation**: Animated transitions for progress changes.

## Installation

To include `GradientProgressView` in your SwiftUI project, add it as a Swift Package Manager (SPM) dependency. Follow these steps:

1. Open your Xcode project.
2. Go to **File** > **Add Packages**.
3. Enter the repository URL: `https://github.com/markhorix/GradientProgressView.git`.
4. Choose the version and add the package to your project.

## Usage

To use `GradientProgressView`, follow these steps:

### Import the Package

```swift
import SwiftUI
import GradientProgressView
```

# Basic Example
Here’s a simple example of how to use GradientProgressView:

```
import SwiftUI
import GradientProgressView

struct ContentView: View {
    @State private var progress: CGFloat = 0.0

    var body: some View {
        VStack {
            GradientProgressView(
                progress: $progress,
                colors: [.blue, .green, .red], // Default colors
                segmentedColors: [
                    0.4: .blue,
                    0.6: .green,
                    1.0: .red
                ],
                useSegmentedColors: true,
                height: 20
            )
            .frame(height: 20)
            
            Button("Increase Progress") {
                withAnimation {
                    if progress < 1.0 {
                        progress += 0.1
                    }
                }
            }
        }
        .padding()
    }
}
```

## Customization
You can customize the GradientProgressView in the following ways:

- **Custom Background Color**: Set a background color for the progress view.
- **Gradient Segmented Based on Progress**: Define color segments that change based on the progress value.
- **Without Gradient Segments**: Use a simple gradient that transitions between specified colors without segmentation.
- **Custom Height**: Adjust the height of the progress view to fit your design needs.
  
## Parameters
- **progress**: A Binding to a CGFloat representing the current progress (0.0 to 1.0).
- **colors**: An array of Color used for the gradient if useSegmentedColors is false.
- **segmentedColors**: An optional dictionary mapping progress values to colors for segmented gradient. Use with useSegmentedColors set to true.
- **useSegmentedColors**: A Bool to enable or disable segmented colors. Defaults to false.
- **height**: The height of the progress view. Defaults to 18.
## License
**GradientProgressView** is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Contributions to **GradientProgressView** are welcome! If you have suggestions, improvements, or bug fixes, please open an issue or submit a pull request on the GitHub repository.

## Contact
For any questions or support, please contact **ibrar.connect@gmail.com**.
