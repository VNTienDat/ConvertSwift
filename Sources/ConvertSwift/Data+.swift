import Foundation

public extension Data {
    
    func toString(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
    
    func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D: Decodable {
        let decoder = decoder ?? JSONDecoder()
        return try? decoder.decode(type, from: self)
    }
    
    func toDictionary() -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self)
            return json as? [String: Any]
        } catch {
            return nil
        }
    }
    
    func toData(keyPath: String? = nil) -> Self? {
        guard  let keyPath = keyPath else {return self}
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                guard JSONSerialization.isValidJSONObject(nestedJson) else {
                    return nil
                }
                let data = try JSONSerialization.data(withJSONObject: nestedJson)
                return data
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func toDataPrettyPrinted() -> Self {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: self)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return self // fallback to original data if it can't be serialized.
        }
    }

    subscript(_ keyPath: String? = nil) -> Self? {
        toData(keyPath: keyPath)
    }
    
}
