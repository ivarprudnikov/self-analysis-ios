import SwiftUI

struct About: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("A solution to a tiny problem. How to regularly assess yourself by following a fixed list of questions and keep track of your answers.")
                
            Text("There is no fixed interval at which you must do the assessment.")
            
            Text("Inspiration and questions came from a relatively old book 'Think and Grow Rich' written by Napoleon Hill in 1937.")
            
            Text("Storage")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("Answers are stored on your device only.")
            
            Spacer()
        }
        .padding(16)
        .navigationTitle("About")
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            About()
        }
    }
}
