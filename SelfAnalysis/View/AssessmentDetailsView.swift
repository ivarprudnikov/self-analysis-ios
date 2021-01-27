import SwiftUI

struct AssessmentDetailsView: View {
    @EnvironmentObject private var assessment: Assessment
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title)
                
            Text("ID: \(assessment.id?.uuidString ?? "")")
            if let createdAt = assessment.createdAt { Text("Created at: " + AssessmentRow.dateFormatter.string(from: createdAt)) }
            if let updatedAt = assessment.updatedAt { Text("Updated at: " + AssessmentRow.dateFormatter.string(from: updatedAt)) }
        }
        .padding(20)
    }
}

struct AssessmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentDetailsView()
            .environmentObject(Assessment())
    }
}
