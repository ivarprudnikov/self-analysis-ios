import SwiftUI
import CoreData

struct AssessmentForm: View {
    
    var assessment: Assessment
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<Answer>
    var dbAnswers: FetchedResults<Answer> { fetchRequest.wrappedValue }
    
    @State private var answers: [String: String] = [:]
    
    static let questionSchema: QuestionSchema = {
        return try! loadQuestionSchema()
    }()
    
    init(assessment: Assessment) {
        self.assessment = assessment
        self.fetchRequest = FetchRequest<Answer>(entity: Answer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "assessment.id == %@", assessment.id! as CVarArg))
    }
    
    func createBindingToAnswer(forKey key: String) -> Binding<String> {
        return Binding<String>( get: {
            if let existing = dbAnswers.first(where: { $0.question == key }) {
                return existing.value ?? ""
            }
            return ""
        }, set: { newValue in
            let ans: Answer
            if let existing = dbAnswers.first(where: { $0.question == key }) {
                ans = existing
            } else {
                ans = Answer(context: viewContext)
                ans.question = key
                ans.assessment = assessment
            }
            ans.value = newValue
            
            do {
                try viewContext.save()
            } catch {
                print("failed")
            }
        })
    }
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("ID: \(assessment.id?.uuidString ?? "")")
                if let createdAt = assessment.createdAt { Text("Created at: " + AssessmentRow.dateFormatter.string(from: createdAt)) }
                if let updatedAt = assessment.updatedAt { Text("Updated at: " + AssessmentRow.dateFormatter.string(from: updatedAt)) }
            }
            ForEach(AssessmentForm.questionSchema.properties.sorted(by: { $0.key < $1.key }), id: \.key) { key, field in
                Section(header: Text(field.title), footer: Text(field.description ?? "")) {
                    TextEditor(text: createBindingToAnswer(forKey: key))
                }
            }
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: Assessment())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
