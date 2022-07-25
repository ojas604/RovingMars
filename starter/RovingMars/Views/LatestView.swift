import SwiftUI


struct LatestView: View {
  @State var latestPhotos: [Photo] = []
  let marsData = MarsData()
  
  
  func latestPhotos(rover: String) async throws -> [Photo] {
    
    let apiRequest = APIRequest<LatestPhotos>(
      urlString: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/latest_photos"
    )
    
    let source = MarsRoverAPI()
    
    let container = try await source.request(apiRequest, apiKey: source.apiKey)
    
    return container.photos
    
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        
        /*
         AsyncImage(
           url: URL(string: "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/03373/opgs/edr/ncam/NRB_696919762EDR_S0930000NCAM00594M_.JPG")
         ) { phase in
           switch phase {
           //1
           case .empty:
             MarsProgressView()
           //2
           case .success(let image):
             image
               .resizable()
               .aspectRatio(contentMode: .fit)
           //3
           case .failure(let error):
             VStack {
               Image(systemName: "exclamationmark.triangle.fill")
                 .foregroundColor(.orange)
               Text(error.localizedDescription)
                 .font(.caption)
                 .multilineTextAlignment(.center)
             }
           @unknown default:
             EmptyView()
           }
         }
         */
        
        ScrollView(.horizontal) {
          HStack(spacing: 0) {
            ForEach(latestPhotos) { photo in
              MarsImageView(photo: photo)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
          }
          .task {
//            latestPhotos = []
//            do {
//              let curiosityPhotos = try await latestPhotos(rover: "curiosity")
//              let perseverancePhotos = try await latestPhotos(rover: "perseverance")
//              let spiritPhotos = try await latestPhotos(rover: "spirit")
//              let opportunityPhotos = try await latestPhotos(rover: "opportunity")
//
//              let result = [
//                curiosityPhotos.first,
//                perseverancePhotos.first,
//                spiritPhotos.first,
//                opportunityPhotos.first
//              ]
//
//              latestPhotos = result.compactMap { $0 }
//            } catch {
//
//              log.error("Error fetching latest photos: \(error.localizedDescription)")
//            }
              
            latestPhotos = await marsData.fetchLatestPhotos()
          }
        }
        if latestPhotos.isEmpty {
          MarsProgressView()
        }
      }
      .navigationTitle("Latest Photos")
    }
  }
}

struct LatestView_Previews: PreviewProvider {
  static var previews: some View {
    LatestView()
  }
}
