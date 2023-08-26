import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var Male = 0
    @State var Female = 1
    @State var imageOpacity = 0.0
    @State private var audioPlayer: AVAudioPlayer?

    
    var body: some View {
        NavigationView {
            if let image = viewModel.importedImage {
                ZStack() {
                        if Male == 1 && viewModel.classifications.contains("Male") {
                            Image("heaven")
                                .resizable()
                                .frame(width: 400, height: 800)
                                .onAppear{
                                    stopAudio()
                                    playHeavenMusic()
                                    imageOpacity = 1.0
                                }
                        }
                        if Male == 1 && viewModel.classifications.contains("Female") {
                            Image("HELL")
                                .resizable()
                                .frame(width: 400, height: 800)
                                .onAppear{
                                    stopAudio()
                                    playHellMusic()
                                    imageOpacity = 1.0
                                }
                        }
                        if Female == 1 && viewModel.classifications.contains("Female") {
                            Image("heaven")
                                .resizable()
                                .frame(width: 400, height: 800)
                                .onAppear{
                                    stopAudio()
                                    playHeavenMusic()
                                    imageOpacity = 1.0
                                }
                        }
                        if Female == 1 && viewModel.classifications.contains("Male") {
                            Image("HELL")
                                .resizable()
                                .frame(width: 400, height: 800)
                                .onAppear{
                                    stopAudio()
                                    playHellMusic()
                                    imageOpacity = 1.0
                                }
                        }
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .opacity(imageOpacity)
                        .padding()
 
                    Text(viewModel.classifications)
                        .font(.custom("Impact", size: 40))
                        .shadow(color: .black, radius: 1)
                        .multilineTextAlignment(.center)
                            .bold()
                            .padding(.top,400)
                            .padding()
                    }
                } else {
                ZStack{
                    Image("gaytector splash")
                        .resizable()
                    VStack {
                        Text("Do you have COCK???")
                            .font(.custom("Impact", size: 50))
                        HStack{
                            Button {
                                viewModel.displayImagePicker.toggle()
                                Male = 1
                                Female = 0
                            } label: {
                                Text("YES 👍👍👍")
                                    .font(.custom("Arial", size: 25))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                            Button {
                                viewModel.displayImagePicker.toggle()
                                Male = 0
                                Female = 1
                            } label: {
                                Text("NO 👎👎👎")
                                    .font(.custom("Arial", size: 25))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
                .onAppear{
                    playSkullMusic()
                }
            }
        }
        .onChange(of: viewModel.importedImage) { _ in viewModel.onChangeImage() }
        .sheet(isPresented: $viewModel.displayImagePicker) {
            ImagePicker(image: $viewModel.importedImage)
        }
    }
    
    private func playSkullMusic() {
           if let audioFilePath = Bundle.main.path(forResource: "skull music", ofType: "mp3") {
               let audioFileURL = URL(fileURLWithPath: audioFilePath)
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                   audioPlayer?.numberOfLoops = -1 // Set looping to -1 for infinite looping
                   audioPlayer?.play()
               } catch {
                   // Handle any errors that occur during audio file loading
                   print("Error loading audio file: \(error.localizedDescription)")
               }
           }
       }
    
    private func playHeavenMusic() {
           if let audioFilePath = Bundle.main.path(forResource: "heaven", ofType: "mp3") {
               let audioFileURL = URL(fileURLWithPath: audioFilePath)
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                   audioPlayer?.numberOfLoops = -1 // Set looping to -1 for infinite looping
                   audioPlayer?.play()
               } catch {
                   // Handle any errors that occur during audio file loading
                   print("Error loading audio file: \(error.localizedDescription)")
               }
           }
       }
    
    private func playHellMusic() {
           if let audioFilePath = Bundle.main.path(forResource: "hell", ofType: "mp3") {
               let audioFileURL = URL(fileURLWithPath: audioFilePath)
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                   audioPlayer?.numberOfLoops = -1 // Set looping to -1 for infinite looping
                   audioPlayer?.play()
               } catch {
                   // Handle any errors that occur during audio file loading
                   print("Error loading audio file: \(error.localizedDescription)")
               }
           }
       }
    
    func stopAudio() {
            audioPlayer?.stop()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            ContentView(
                viewModel:
                    ContentViewModel(
                        image: UIImage(named: "PhotoPlaceholder")!
                    )
            )
        }
    }
}
