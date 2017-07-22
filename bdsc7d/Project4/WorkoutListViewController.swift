

import UIKit

class WorkoutListViewController: UIViewController {

    @IBOutlet weak fileprivate var tableView: UITableView!
    
    @IBOutlet weak var sortView: UIView!
    
    fileprivate var model: WorkoutListModelInterface = WorkoutListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        sortView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let creationViewController = segue.destination as? WorkoutCreationViewController {
            creationViewController.delegate = self
        }
    }

}

extension WorkoutListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? WorkoutListTableViewCell,
            let workout = model.workout(atIndex: indexPath.row)
        else {
            return UITableViewCell()
        }
        
        cell.decorate(with: workout)
        
        return cell
    }
    
}

extension WorkoutListViewController: WorkoutCreationViewControllerDelegate {
    func save(workout: Workout) {
        model.save(workout: workout)
    }
}

extension WorkoutListViewController: WorkoutListModelDelegate {
    func dataRefreshed() {
        tableView.reloadData()
    }
}
