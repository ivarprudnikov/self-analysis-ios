import SwiftUI
import CoreData

struct AssessmentForm: View {
    
    var assessment: Assessment
    var fetchRequest: FetchRequest<Answer>
    var dbAnswers: FetchedResults<Answer> { fetchRequest.wrappedValue }
    
    init(assessment: Assessment) {
        self.assessment = assessment
        self.fetchRequest = FetchRequest<Answer>(entity: Answer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "assessment.id == %@", assessment.id! as CVarArg))
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var answers: [String: String] = [:]
    @State private var presentingDetailsSheet = false
    
    static let questionSchema: QuestionSchema = {
        return try! loadQuestionSchema()
    }()
    
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
            assessment.updatedAt = Date()
            
            do {
                try viewContext.save()
            } catch {
                print("failed")
            }
        })
    }
    
    var body: some View {
        Form {
            ForEach(AssessmentForm.questionSchema.properties.sorted(by: { $0.key < $1.key }), id: \.key) { key, field in
                Section(header: Text(field.title), footer: Text(field.description ?? "")) {
                    TextEditor(text: createBindingToAnswer(forKey: key))
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            presentingDetailsSheet = true
        }, label: {
            Text("Details")
        }))
        .sheet(isPresented: $presentingDetailsSheet) {
            VStack(spacing: 0) {
                AssessmentDetailsView()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentingDetailsSheet = false }) {
                        Text("Done")
                    }
                }
            }
            .environmentObject(assessment)
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: Assessment())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
