import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    func requestListOfBreeds(completion: @escaping(([List]) -> ())) {
        
        let url = "https://api.thedogapi.com/v1/breeds"
        
        AF.request(url).responseDecodable(of: [List].self) { responce in
            guard let value = responce.value else { return }
            completion(value)
        }
    }
    
}
