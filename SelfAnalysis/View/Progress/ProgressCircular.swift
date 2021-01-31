import SwiftUI

struct ProgressCircular: View {
    let value: Double
    let maxValue: Double
    let backgroundColor: Color = Color(UIColor(red: 222/255,
                                               green: 222/255,
                                               blue: 222/255,
                                               alpha: 0.5))
    let foregroundColor: Color = Color.green
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(self.backgroundColor)
            Circle()
                .trim(from: 0, to: self.progress())
                .stroke(style: StrokeStyle(
                    lineWidth: 5,
                    lineCap: .round
                ))
                .foregroundColor(self.foregroundColor)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeIn)
            Text(String(format: "%.0f", value))
                .font(.footnote)
        }
    }
    
    func progress() -> CGFloat {
        let percentage = self.value / self.maxValue
        return CGFloat(percentage)
    }
}

struct ProgressCircular_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            Group {
                ProgressCircular(value: 0, maxValue: 100)
                ProgressCircular(value: 3, maxValue: 7)
                ProgressCircular(value: 10, maxValue: 10)
            }
            .frame(width: 50, height: 50, alignment: .leading)
            .padding(.all)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(scheme)
        }
    }
}
