//
//  ViewController.swift
//  SignUpValidation
//
//  Created by Apple on 10/06/23.
//

import UIKit

class SignUpViewController: UIViewController {

   
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtFieldDatePicker: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var txtCPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldDatePicker.delegate = self
      
    }
    private func removeInputValues() {
        txtName.text = ""
        txtEmail.text = ""
        txtFieldDatePicker.text = ""
        txtGender.text = ""
        txtPassword.text = ""
    }
    fileprivate func initialize() {
        // Set Date Picker on TxtFDOB
        txtFieldDatePicker.setDatePickerMode(mode: .date)
        txtFieldDatePicker.setDatePickerWithDateFormate(
            dateFormate: dateFormat,
            defaultDate: Date(),
            isPrefilledDate: false) { (date) in
            self.txtFieldDatePicker.text = "\(DateFormatter.sharedMIV().stringMIV(fromDate: date, dateFormat: dateFormat))"
        }

        // Set Picker on TxtFGender
        self.txtGender.setPickerData(
            arrPickerData: [CMale, CFemale, COther],
            selectedPickerDataHandler: { (text, row, component) in
                self.txtGender.text = text
            }, defaultPlaceholder: nil)
    }


    @IBAction func signUpAction(_ sender: UIButton) {
        
        let arrValidationModel = [
            ValidationModel(validation: .msgRange, value: txtName.text?.trim, message: CBlankFullName),
            
            ValidationModel(validation: .email, value: txtEmail.text?.trim, message: CBlankEmail),
           
            //ValidationModel(validation: .mobileNumber, value: numberFieldView.textField.text?.trim, message: CBlankPhoneNumber),
           
            
            ValidationModel(validation: .dateOfBirth, value: txtFieldDatePicker.text?.trim, message: CBlankDateOfBirth),
           
            ValidationModel(validation: .notEmpty, value:txtGender.text?.trim, message: CBlankGender),
           
            ValidationModel(validation: .password, value: txtPassword.text?.trim, message: CBlankPswd),
           
            ValidationModel(validation: .password, value: txtCPassword.text?.trim, message: CBlankConfirmPswd)
            
        ]
        // Check Validation Of SignUp
        if MIValidation.isValidData(arrValidationModel) {
            if MIValidation.isMatchedPasswords(txtPassword.text?.trim, txtCPassword.text?.trim) {
            self.view.endEditing(true)
            removeInputValues()
            // Navigate Home Screen
//            if let homeVc = UIStoryboard.main.get(controller: HomeVC.self) {
//                self.push(To: homeVc)
                
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                self.navigationController?.pushViewController(loginViewController, animated: true)
   //         }
            
        }
        }
 
    }
    
    
}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.openDatePicker()
    }
    


}
extension SignUpViewController{
    
    func openDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.set18YearValidation()
        datePicker.preferredDatePickerStyle = .wheels
        
        txtFieldDatePicker.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnClick))
        
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([cancelBtn,flexibleBtn,doneBtn], animated: true)
        txtFieldDatePicker.inputAccessoryView = toolbar
        
    }
    
    @objc func cancelBtnClick(){
        txtFieldDatePicker.resignFirstResponder()
        
    }
    
    @objc func doneBtnClick(){
        
        if let datePicker = txtFieldDatePicker.inputView as? UIDatePicker{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            txtFieldDatePicker.text = dateFormatter.string(from: datePicker.date)
            
            print(datePicker.date)
        }
        txtFieldDatePicker.resignFirstResponder()
        
        
    }
}
extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }
