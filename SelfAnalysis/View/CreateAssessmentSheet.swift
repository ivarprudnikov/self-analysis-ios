import SwiftUI

struct CreateAssessmentSheet: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Adding ...")
            Spacer()
        }
        .navigationTitle("New assessment")
        .onAppear(perform: {
            let newAssessment = Assessment(context: viewContext)
            newAssessment.createdAt = Date()
            newAssessment.id = UUID()
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error.localizedDescription)
            }
        })
    }
}

struct CreateAssessmentSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateAssessmentSheet()
    }
}
