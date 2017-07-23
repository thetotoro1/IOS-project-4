

import UIKit

protocol WorkoutCreationViewControllerDelegate: class {
    func save(workout: Workout)
}

class WorkoutCreationViewController: UIViewController {

    weak var delegate: WorkoutCreationViewControllerDelegate?
    
    fileprivate var model = WorkoutCreationModel()
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var dateField: UITextField!
    @IBOutlet private weak var minutesLabel: UILabel!
    
    @IBOutlet weak var timeStartTextField: UITextField!
    @IBOutlet weak var timeEndTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
//    @IBOutlet private weak var minutesStepper: UIStepper!
//    @IBOutlet private weak var highIntensitySwitch: UISwitch!
    
    @IBOutlet private weak var addWorkoutButton: UIButton!
    @IBOutlet fileprivate weak var tappableBackgroundView: UIView!
    
    private var datePicker: UIDatePicker!
    private var timePickerStart: UIDatePicker!
    private var timePickerEnd: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure date picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)

        // Configure date text field
        dateField.inputView = datePicker   // use picker as input view
        dateField.text = datePicker.date.toString(format: .yearMonthDay)  // uses toString() extension I made
        
        
        
        
        //Configure time picker
        timePickerStart = UIDatePicker()
        timePickerStart.datePickerMode = .time
        timePickerStart.addTarget(self, action: #selector(timeStartValueChanged), for: .valueChanged)
        
        //configure time text field
        timeStartTextField.inputView = timePickerStart
        
        //Configure time start picker
        timePickerStart = UIDatePicker()
        timePickerStart.datePickerMode = .time
        timePickerStart.addTarget(self, action: #selector(timeStartValueChanged), for: .valueChanged)
        timeStartTextField.inputView = timePickerStart

        
        
        //Configure time end picker
        timePickerEnd = UIDatePicker()
        timePickerEnd.datePickerMode = .time
        timePickerEnd.addTarget(self, action: #selector(timeEndValueChanged), for: .valueChanged)
        timeEndTextField.inputView = timePickerEnd

        

        //Configure starting text for start/end time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        timeStartTextField.text = dateString
        timeEndTextField.text = dateString
        
        
        // Configure minutes stepper and label
//        minutesStepper.minimumValue = 0
//        minutesStepper.maximumValue = 90
//        minutesStepper.value = 10
//        minutesLabel.text = "\(Int(minutesStepper.value))"

        // Turn off switch by default
//        highIntensitySwitch.isOn = false

        // Configure tappable background when keyboard or picker is displayed
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tappableBackgroundView.addGestureRecognizer(tapGestureRecognizer)
        tappableBackgroundView.isHidden = true
        
        //turn off workout button
        addWorkoutButton.isEnabled = false
        
        // Configure delegates
        nameField.delegate = self
        dateField.delegate = self
        timeStartTextField.delegate = self
        timeEndTextField.delegate = self
        caloriesTextField.delegate = self
        
    }
    
//    @IBAction private func minutesValueChanged(_ sender: UIStepper) {
//        minutesLabel.text = "\(Int(sender.value))"
//    }
 
    

    
    @IBAction private func addWorkoutButtonTapped(_ sender: UIButton) {
        var name = nameField.text ?? ""
        if name == "" { name = "No Name" }
//        let duration = Int(minutesStepper.value)
        let date = datePicker.date
//        let isHighIntensity = highIntensitySwitch.isOn
        
        let duration = Int(timePickerEnd.date.timeIntervalSince(timePickerStart.date).rounded(.up)) / 60
        
        let calories = Int(caloriesTextField.text!)! * duration
        
        let workout = Workout(id: UUID(), name: name, date: date, duration: duration, calories: calories)
        
        delegate?.save(workout: workout)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func caloriesEdited(_ sender: UITextField) {
        checkValidInputs()
    }
    
    @objc private func dateValueChanged() {
        dateField.text = datePicker.date.toString(format: .yearMonthDay)
    }
    
    @objc private func timeStartValueChanged() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = timePickerStart.date
        
        // To convert the date into an HH:mm format
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        timeStartTextField.text = dateString
        
        checkValidInputs()
    }
    
    
    @objc private func timeEndValueChanged() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = timePickerEnd.date
        
        // To convert the date into an HH:mm format
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        timeEndTextField.text = dateString
        
        checkValidInputs()
    }
    
    @objc private func backgroundTapped() {
        // this actually loops through all this view's subviews and resigns the first responder on all of them
        self.view.endEditing(true)
        
        tappableBackgroundView.isHidden = true
    }

    func checkValidInputs(){
        
        guard let cpm = caloriesTextField.text else {
            addWorkoutButton.isEnabled = false
            return
        }
        
        if model.checkDuration(from: timePickerStart.date, to: timePickerEnd.date) && model.checkCaloriesPerMinuite(caloriesPerMinute: cpm) {
            addWorkoutButton.isEnabled = true
        }
        else {
            addWorkoutButton.isEnabled = false
        }
        
    }

}

extension WorkoutCreationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tappableBackgroundView.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        tappableBackgroundView.isHidden = true
        return true
    }
    
}
