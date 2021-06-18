import Foundation

public extension Encodable {
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    func toDictionary() -> [String: Any]? {
        toData()?.toDictionary()
    }
    
    func toModel<D>(_ type: D.Type, using decoder: JSONDecoder?) -> D? where D: Decodable {
        toData()?.toModel(type)
    }
    
}
