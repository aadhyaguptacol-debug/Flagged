import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy",
        "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Game state tracking
    @State private var score = 0
    @State private var questionCount = 1
    
    // Alert state
    @State private var showingScore = false
    @State private var showingFinalAlert = false
    @State private var scoreTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        // Round summary alert
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        // Final game-over alert after 8 questions
        .alert("Game Over", isPresented: $showingFinalAlert) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your final score is \(score) out of 8.")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            alertMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Wrong! That's the flag of \(countries[number]).\nYour score is \(score)"
        }
        
        if questionCount == 8 {
            showingFinalAlert = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        questionCount += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        score = 0
        questionCount = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        askQuestion()
    }
}

#Preview {
    ContentView()
}
