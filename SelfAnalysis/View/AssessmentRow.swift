import SwiftUI

struct AssessmentRow: View {
    var assessment: Assessment
    
    var metrics: Metrics {
        return Metrics(cornerRadius: 16, rowPadding: 0, textPadding: 8)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(assessment.id?.uuidString ?? "N/A")
                    .font(.headline)
                    .lineLimit(1)
            }
            .padding(.vertical, metrics.textPadding)
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .padding(.vertical, metrics.rowPadding)
        .accessibilityElement(children: .combine)
    }
    
    struct Metrics {
        var cornerRadius: CGFloat
        var rowPadding: CGFloat
        var textPadding: CGFloat
    }
}

struct AssessmentRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AssessmentRow(assessment: Assessment())
        }
        .frame(width: 250, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}
