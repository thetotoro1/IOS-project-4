
import Foundation

protocol WorkoutListModelDelegate: class {
    func dataRefreshed()
}

protocol WorkoutListModelInterface {
    weak var delegate: WorkoutListModelDelegate? { get set }
    var count: Int { get }
    func workout(atIndex index: Int) -> Workout?
    func save(workout: Workout)
}

class WorkoutListModel: WorkoutListModelInterface {
    
    weak var delegate: WorkoutListModelDelegate?
    
    private var workouts = [Workout]()
    private let persistence: WorkoutPersistenceInterface?
    
    init() {
        self.persistence = ApplicationSession.sharedInstance.persistence
        workouts = self.persistence?.savedWorkouts ?? []
    }
    
    var count: Int {
        return workouts.count
    }
    
    func workout(atIndex index: Int) -> Workout? {
        return workouts.element(at: index)
    }
    
    func save(workout: Workout) {
        workouts.append(workout)
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }

    
}


