import SwiftUI
import CoreData

struct AnswerPreview: View {
    var key: String
    var answer: Answer?
    var body: some View {
        let field = AssessmentForm.questionSchema.properties[key]
        Section {
            if let title = field?.title {
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .bold()
            }
            
            if let description = field?.description {
                Text(description)
                    .italic()
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            
            Text(answer?.value ?? "")
                .font(.body)
        }
    }
}

struct AnswerEditor: View {
    var key: String
    var answer: Answer?
    var assessment: Assessment
    
    @Environment(\.managedObjectContext) private var viewContext
    
    func createBindingToAnswer() -> Binding<String> {
        return Binding<String>( get: {
            return answer?.value ?? ""
        }, set: { newValue in
            let ans: Answer
            if let existing = answer {
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
        let field = AssessmentForm.questionSchema.properties[key]
        Section {
            if let title = field?.title {
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .bold()
            }
            
            if let description = field?.description {
                Text(description)
                    .italic()
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            
            TextEditor(text: createBindingToAnswer())
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .disableAutocorrection(true)
                .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
        }
    }
}

struct AssessmentForm: View {
    var assessment: Assessment
    var fetchRequest: FetchRequest<Answer>
    var dbAnswers: FetchedResults<Answer> { fetchRequest.wrappedValue }
    
    init(assessment: Assessment) {
        self.assessment = assessment
        self.fetchRequest = FetchRequest<Answer>(entity: Answer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "assessment.id == %@", assessment.id! as CVarArg))
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentingDetailsSheet = false
    @State private var selectedAnswerKey: String? = nil
    
    static let questionSchema: QuestionSchema = {
        return try! loadQuestionSchema()
    }()
    
    func isPresentingAnswerEditorSheet() -> Binding<Bool> {
        return Binding<Bool>( get: {
            return selectedAnswerKey != nil
        }, set: { newValue in selectedAnswerKey = nil })
    }
    
    func answerForKey(forKey key: String) -> Answer? {
        return dbAnswers.first(where: { $0.question == key })
    }
    
    func answerValueForKey(forKey key: String) -> String {
        if let existing = answerForKey(forKey: key) {
            return existing.value ?? ""
        }
        return ""
    }
    
    func createBindingToAnswer(forKey key: String) -> Binding<String> {
        return Binding<String>( get: {
            return answerValueForKey(forKey: key)
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
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var showDetailsBtn: some View {
        Button(action: {
            presentingDetailsSheet = true
        }, label: {
            Image(systemName: "info.circle")
                .imageScale(.large)
        })
    }
    
    var bottomToolbarProgress: some View {
        HStack(alignment: .center, spacing: 40) {
            ProgressHorizontal(value: Double(dbAnswers.count), maxValue: Double(AssessmentForm.questionSchema.properties.count))
                .frame(width: 100, height: 3, alignment: .center)
        }.frame(maxWidth: .infinity)
    }
    
    var body: some View {
        Form {
            ForEach(AssessmentForm.questionSchema.properties.sorted(by: { $0.key < $1.key }), id: \.key) { key, field in
                AnswerPreview(key: key, answer: answerForKey(forKey: key))
                    .onTapGesture {
                        selectedAnswerKey = key
                    }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                showDetailsBtn
            }
            ToolbarItem(placement: .bottomBar) {
                bottomToolbarProgress
            }
        })
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
        .sheet(isPresented: isPresentingAnswerEditorSheet()) {
            VStack(spacing: 0) {
                Rectangle()
            }
        }
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: PersistenceController.preview.createAssessment())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
