import SwiftUI

struct RoversListView: View {
  let marsData = MarsData()
  @State var manifests: [PhotoManifest] = []
  var body: some View {
    NavigationView {
      ZStack {

        List(manifests, id: \.name) { manifest in
          NavigationLink {
            RoverManifestView(manifest: manifest)
          } label : {
            HStack {
              Text("\(manifest.name) (\(manifest.status))")
              Spacer()
              Text("\(manifest.totalPhotos) \(Image(systemName: "photo"))")
            }
          }
        }
        if manifests.isEmpty {
          MarsProgressView()
        }
      }
      .navigationTitle("Mars Rovers")
    }
    .task {
      manifests = []
      do {
        manifests = try await marsData.fetchPhotoManifests()
      } catch {
        log.error("Error fetching rover manifests: \(String(describing: error))")
      }
    }
  }
}

struct RoversListView_Previews: PreviewProvider {
  static var previews: some View {
    RoversListView()
  }
}
