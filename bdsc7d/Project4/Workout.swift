
import Foundation

struct Workout {
    let id: UUID
    let name: String
    let date: Date
    let duration: Int
    let calories: Int}

extension Workout {
    func toDictionary() -> JsonDictionary {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "date": self.date.timeIntervalSince1970,
            "duration": self.duration,
            "calories": self.calories
        ]
    }
    
    static func createFrom(dict: JsonDictionary) -> Workout? {
        guard
            let idString = dict["id"] as? String,
            let id = UUID(uuidString: idString),
            let name = dict["name"] as? String,
            let timeInterval = dict["date"] as? TimeInterval,
            let duration = dict["duration"] as? Int
        else {
            print("Error in first half")
            return nil
        }
        
        
        
//        guard
//            let calories = dict["calPerMin"] as? Int
//        else {
//            print("error in second half")
//            return nil
//        }
        let date = Date(timeIntervalSince1970: timeInterval)
        return Workout(id: id, name: name, date: date, duration: duration, calories: 10)
    }
}
