import SwiftUI

struct AssessmentForm: View {
    
    var assessment: Assessment?
    
    @State private var answers: [String: String] = [:]
    
    static let questionSchema: QuestionSchema = {
        return try! loadQuestionSchema()
    }()
    
    var body: some View {
        if let a = assessment {
            Form {
                Section(header: Text("Details")) {
                    Text("ID: \(a.id?.uuidString ?? "")")
                    if let createdAt = a.createdAt { Text("Created at: " + AssessmentRow.dateFormatter.string(from: createdAt)) }
                    if let updatedAt = a.updatedAt { Text("Updated at: " + AssessmentRow.dateFormatter.string(from: updatedAt)) }
                }
                ForEach(AssessmentForm.questionSchema.properties.sorted(by: { $0.key < $1.key }), id: \.key) { key, field in
                    Section(header: Text(field.title), footer: Text(field.description ?? "")) {
                        TextEditor(text: Binding<String>(
                            get: { self.answers[key] ?? "" },
                            set: { self.answers[key] = $0})
                        )
                    }
                }
            }
        } else {
            Text("Assessment not found 😭")
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: Assessment())
    }
}
