import SwiftUI

struct ProgressHorizontal: View {
    
    let value: Double
    let maxValue: Double
    let backgroundColor: Color = Color(UIColor(red: 222/255,
                                               green: 222/255,
                                               blue: 222/255,
                                               alpha: 0.5))
    let foregroundColor: Color = Color.green
    
    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Capsule()
                    .foregroundColor(self.backgroundColor)
                Capsule()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width))
                    
                    .foregroundColor(self.foregroundColor)
                    .animation(.easeIn)
            }
        }
    }
    
    func progress(value: Double,
                  maxValue: Double,
                  width: CGFloat) -> CGFloat {
        let percentage = value / maxValue
        return width *  CGFloat(percentage)
    }
}

struct ProgressHorizontal_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            Group {
                ProgressHorizontal(value: 0, maxValue: 100)
                ProgressHorizontal(value: 3, maxValue: 7)
                ProgressHorizontal(value: 10, maxValue: 10)
            }
            .frame(width: 250, height: 10, alignment: .leading)
            .padding(.all)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(scheme)
        }
        
    }
}
