import Foundation


class WorkoutCreationModel {
    
    
    func checkDuration(from startDate: Date, to endDate: Date) -> Bool {

        let timeDifference = Int(endDate.timeIntervalSince(startDate).rounded(.up))
        
        print(timeDifference / 60)
        
        if timeDifference / 60 < 2 {
            return false
        }
        
        return true
    }
    
    func checkCaloriesPerMinuite(caloriesPerMinute: String) -> Bool{
        
        guard let cpm = Int(caloriesPerMinute) else { return false }
        
        if cpm < 1 {
            return false
        }
        
        return true
        
    }
    
}
