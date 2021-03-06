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
                Section {
                    Text(field.title)
                        .foregroundColor(.secondary)
                        .font(.body)
                        .bold()
                    
                    if let description = field.description {
                        Text(description)
                            .italic()
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    
                    TextEditor(text: createBindingToAnswer(forKey: key))
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .onTapGesture {
            self.dismissKeyboard()
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
    }
}

struct AssessmentForm_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentForm(assessment: Assessment())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
