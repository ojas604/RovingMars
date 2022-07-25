import SwiftUI
import OSLog

class MarsData {
  let marsRoverAPI = MarsRoverAPI()
  
  func fetchAllRovers() async -> [Rover] {
    do {
      return try await marsRoverAPI.allRovers()
    } catch {
      log.error("Error fetching rovers: \(String(describing: error))")
      return []
    }
  }
  
  func fetchLatestPhotos() async -> [Photo] {
    await withTaskGroup(of: Photo?.self) { group in
      let rovers = await fetchAllRovers()
      
      for rover in rovers {
        group.addTask {
          let photos = try? await self.marsRoverAPI.latestPhotos(rover: rover)
          return photos?.first
          
        }
      }
      var latestPhotos: [Photo] = []
      
      for await result in group {
        
        if let photo = result {
          latestPhotos.append(photo)
        }
      }
      return latestPhotos
    }
  }
  
  func fetchPhotoManifests() async throws -> [PhotoManifest] {
    return try await withThrowingTaskGroup(of: PhotoManifest.self)
    { group in
      let rovers = await fetchAllRovers()
      
      try Task.checkCancellation()
      
      for rover in rovers {
        group.addTask {
          return try await self.marsRoverAPI.photoManifest(rover: rover)
        }
      }
      return try await group.reduce(into: []) { manifestArray, manifest in
        manifestArray.append(manifest)
      }
    }
  }
  
  func fetchPhotos(roverName: String, sol: Int) async -> [Photo] {
    do {
      return try await marsRoverAPI.photos(roverName: roverName, sol: sol)
    } catch {
      log.error("Error fetching rover photos: \(String(describing: error))")
      return []
    }
  }
}
