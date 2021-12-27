import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    static let internet = NetworkReachabilityManager()!
          
    static var isConnectedToInternet:Bool {
        return self.internet.isReachable
      }
    
    func requestListOfBreeds(completion: @escaping(([List]) -> ())) {
        
        let url = "https://api.thedogapi.com/v1/breeds"
        
        AF.request(url).responseDecodable(of: [List].self) { responce in
            guard let value = responce.value else { return }
            completion(value)
        }
    }
    
    func requestFact(completion: @escaping((String) -> ())) {
        let url = "https://dog-api.kinduff.com/api/facts?number=1"
        AF.request(url).responseDecodable(of: Fact.self) { responce in
            guard let value = responce.value else { return }
            guard let fact = value.facts?.first else { return }
            completion(fact)
        }
    }
}
