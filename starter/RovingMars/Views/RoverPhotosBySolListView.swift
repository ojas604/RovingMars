import SwiftUI

struct RoverPhotosBySolListView: View {
  let name: String
  let sol: Int
  private let marsData = MarsData()
  @State private var photos: [Photo] = []
    var body: some View {
      ZStack {
        
        ScrollView {
          LazyVStack (spacing: 0) {
            ForEach(photos) { photo in
              MarsImageView(photo: photo)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
          }
        }
        if photos.isEmpty {
          MarsProgressView()
        }
      }
      .navigationTitle(name)
      .task {
        photos = await marsData.fetchPhotos(roverName: name, sol: sol)
      }
    }
}

struct RoverPhotosBySolListView_Previews: PreviewProvider {
    static var previews: some View {
        RoverPhotosBySolListView(name: "hi", sol: 1)
    }
}
