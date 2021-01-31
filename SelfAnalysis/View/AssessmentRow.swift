import SwiftUI

struct AssessmentRow: View {
    var assessment: Assessment
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var metrics: Metrics {
        return Metrics(cornerRadius: 16, rowPadding: 0, textPadding: 8)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Group {
                ProgressCircular(value: Double(assessment.answers?.count ?? 0), maxValue: Double(AssessmentForm.questionSchema.properties.count))
            }
            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(assessment.id?.uuidString ?? "N/A")
                    .font(.headline)
                    .lineLimit(1)
                if let createdAt = assessment.createdAt { Text("Created at: " + AssessmentRow.dateFormatter.string(from: createdAt)) }
                if let updatedAt = assessment.updatedAt { Text("Updated at: " + AssessmentRow.dateFormatter.string(from: updatedAt)) }
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
