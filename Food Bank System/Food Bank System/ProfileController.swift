//
//  profileController.swift
//  Food Bank System
//
//  Created by Riad El Mahmoudy on 6/5/20.
//  Copyright © 2020 MeetTheNeed. All rights reserved.
//
import Foundation
import UIKit

class ProfileController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //global variables
    @IBOutlet weak var moneyGiven: UITextField!
    @IBOutlet weak var studentProofLabel: UILabel!
    @IBOutlet weak var residentProofLabel: UILabel!
    @IBOutlet weak var textFieldStudent: UITextField!
    @IBOutlet weak var textFieldResident: UITextField!
    var memberFirstName: String?
    var memberLastName: String?
    var memberDateOfBirth: String?
    var balance: String? = "0.00";
    var livraison: Bool? = false;
    var depannage: Bool? = false;
    var christmas: Bool? = false;
    var residencyProofMember: String?
    var studentProofMember: String?
    var isJsonBuilt = false
    
 
    var optionList = ["Oui", "Oui, pas de preuves", "Non"]
    /*
     PICKER FOR STUDENT STATUS
     */
     var selectedOptionStudent: String?
     var selectedOptionResident: String?
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           textFieldStudent.inputView = pickerView
           textFieldResident.inputView = pickerView
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       textFieldStudent.inputAccessoryView = toolBar
       textFieldResident.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1 // number of session
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return optionList.count // number of dropdown items
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return optionList[row] // dropdown item
       }
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(textFieldStudent.isEditing){
           selectedOptionStudent = optionList[row] // selected item
           textFieldStudent.text = selectedOptionStudent
            studentProofMember = textFieldStudent.text
        }else{
            selectedOptionResident = optionList[row] // selected item
            textFieldResident.text = selectedOptionResident
            residencyProofMember = textFieldResident.text
        }
       }
    
    // FIELD
    @IBOutlet weak var moneyGivenField: UITextField!
    
    @IBAction func moneyFieldAction(_ sender: Any) {
        balance = moneyGivenField.text;
    }
    
    
    
    
    
    
    @IBOutlet weak var livraisonSwitch: UISwitch!
    @IBOutlet weak var emergencySwitch: UISwitch!
    @IBOutlet weak var christmasSwitch: UISwitch!

    @IBAction func livraisonSwitch(_ sender: Any) {
    
        if(livraisonSwitch.isOn){
            livraison = true;
            livraisonSwitch.setOn(true, animated:true)
        }else{
            livraison = false;
            livraisonSwitch.setOn(false, animated:true)
        }
    }
   
    @IBAction func emergencySwitch(_ sender: Any) {
        if(emergencySwitch.isOn){
            depannage = true;
            emergencySwitch.setOn(true, animated:true)
        }else{
            depannage = false;
            emergencySwitch.setOn(false, animated:true)
        }
    }
    
    @IBAction func christmasSwitch(_ sender: Any) {
        if(christmasSwitch.isOn){
            christmas = true;
            christmasSwitch.setOn(true, animated:true)
        }else{
            christmas = false;
            christmasSwitch.setOn(false, animated:true)
        }
    }
    

    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet var buttons: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var basketsRemainingLabel: UILabel!
    var id:Int=0;
    
    struct Member: Decodable{
        let firstName: String
        let lastName: String
        let dateOfBirth: String
        let message: String
        let numberOfBaskets: Int
        let residencyProofStatus: String
        let studentStatus: String
        //let typeOfBasket: String
    }
    @objc func dismissKeyboard() {
             //Causes the view (or one of its embedded text fields) to resign the first responder status.
             view.endEditing(true)
         }
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  buttons.backgroundColor = .clear
        buttons.topAnchor.constraint(equalTo: lastPickupLabel.bottomAnchor, constant: 30).isActive = true
        buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        */
        //hide keyboard
        self.moneyGivenField.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

           //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
           //tap.cancelsTouchesInView = false

           view.addGestureRecognizer(tap)
         
       
      
        //switch selector
        self.livraisonSwitch.setOn(false, animated:true)
        self.emergencySwitch.setOn(false, animated:true)
        self.christmasSwitch.setOn(false, animated:true)
        
        self.livraisonSwitch.addTarget(self, action: #selector(self.livraisonSwitch(_:)), for: .valueChanged)
        self.emergencySwitch.addTarget(self, action: #selector(self.emergencySwitch(_:)), for: .valueChanged)
        self.christmasSwitch.addTarget(self, action: #selector(self.christmasSwitch(_:)), for: .valueChanged)
        
         //default hiding of proof fields
        self.textFieldResident.isHidden = true;
        self.textFieldStudent.isHidden = true;
        self.studentProofLabel.isHidden = true;
        self.residentProofLabel.isHidden = true;
       
        createPickerView();
        dismissPickerView();
        //display information
        print("-------!!!!!-------!!!!-----")
        print(id)
        print("-------!!!!!-------!!!!-----")
        let parameter = ["id":id]
        
        guard let url = URL(string: "http://192.168.2.15:8000/api/crmid") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
            else {return}
        request.httpBody = httpBody;
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json);
                
                    let memberInfo = try JSONDecoder().decode(Member.self, from: data)
                  
                   
                    
                    //show information
                       DispatchQueue.main.async {
                        //show and hide proof questions
                                           
                    if(memberInfo.residencyProofStatus=="Oui" || memberInfo.studentStatus=="Oui"){
                self.textFieldResident.isHidden = true;
                  self.textFieldStudent.isHidden = true;
                  self.studentProofLabel.isHidden = true;
                   self.residentProofLabel.isHidden = true;
                    }else{
                   self.textFieldResident.isHidden = false;
                    self.textFieldStudent.isHidden = false;
                   self.studentProofLabel.isHidden = false;
                    self.residentProofLabel.isHidden = false;
                        }
                        
                   self.nameLabel.text = memberInfo.firstName+" "+memberInfo.lastName;
                 self.nameLabel.textAlignment = .center;
                        
                        
                    self.basketsRemainingLabel.text = String(memberInfo.numberOfBaskets);
                    self.basketsRemainingLabel.textAlignment = .center;
                        
                    self.dateOfBirthLabel.text = memberInfo.dateOfBirth;
                    self.dateOfBirthLabel.textAlignment = .center;
                        
                        
                        self.memberFirstName = memberInfo.firstName;
                        self.memberLastName = memberInfo.lastName;
                        self.memberDateOfBirth = memberInfo.dateOfBirth;
                        self.residencyProofMember = memberInfo.residencyProofStatus;
                        self.studentProofMember = memberInfo.studentStatus;
                    }
                    
                    
                    
                    
                    
                   } catch {
                    print(error)
                   }
                
            }
        }.resume()
    
    
        
        
      
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    //MARK: - Navigation
     @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func giveBasket(_ sender: UIButton) {
     //check if there
        
       
        
       if let cost = Double(balance!) {
            print("The user entered a value price of \(cost)")
        if((memberFirstName != nil) && (memberLastName != nil) && (memberDateOfBirth != nil) && (livraison != nil) && (depannage != nil) && (christmas != nil) && (studentProofMember != nil) && (residencyProofMember != nil) && (balance != nil)){
                   //create json
                          let jsonObject: [String: Any] = [
                              
                                  "firstName": memberFirstName!,
                                  "lastName":memberLastName!,
                                  "dateOfBirth":memberDateOfBirth!,
                                  "balance": Double(String(format: "%.3f",Double(balance!)!))!,
                                  "livraison": livraison!,
                                  "depannage": depannage!,
                                  "christmasBasket": christmas!,
                                  "residencyProofStatus": residencyProofMember!,
                                  "studentStatus": studentProofMember!,
                              
                          ]
              
                   //let basket = JSONSerialization.isValidJSONObject(jsonObject);
                       print("issaJSON");
                   print(jsonObject);
                   
                  let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
            print(jsonData!);
                  // create post request
                  let url = URL(string: "http://192.168.2.15:8000/api/addbasket")!
                  var request = URLRequest(url: url)
                  request.httpMethod = "POST"
                   

                  // insert json data to the request
                  request.httpBody = jsonData
                   request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                   request.addValue("application/json", forHTTPHeaderField: "Accept")


                  let task = URLSession.shared.dataTask(with: request) { data, response, error in
                      guard let data = data, error == nil else {
                          print(error?.localizedDescription ?? "No data")
                          return
                      }
                      let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("jsonli");
                  
                      if let responseJSON = responseJSON as? [String: Any] {
                          print(responseJSON)
                       
                      }
                  }

                  task.resume()
            let refreshAlert = UIAlertController(title: "SUCCÈS", message: "Vous avez ajouté un panier au dépendant "+self.memberFirstName!+" "+self.memberLastName!, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
           }))

        refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
           print("Handle Cancel Logic here")
             }))

         self.present(refreshAlert, animated: true, completion: nil)
                          
               }else{
                   let alert = UIAlertController(title: "ATTENTION", message: "Entrez toutes les informations nécessaires", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   
               }
               
        
        } else {
            print("Not a valid number: \(balance!)")
            let alert = UIAlertController(title: "ATTENTION", message: "Vous devez entrer un nombre valide. Exemple: 15.00", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        
       
    
        

    }
    @IBAction func scanAgain(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
       // self.presentingViewController?.dismiss(animated: false, completion: nil)
        let QRController = QRScannerController();
        QRController.dismiss(animated: true, completion: nil);
}
    
}
