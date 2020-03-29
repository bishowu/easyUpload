//
//  ViewController.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/26.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textIP: UITextField!
    @IBOutlet weak var textId: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var segProtocol: UISegmentedControl!
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textIP.delegate = self
        self.textIP.addTarget(self, action: #selector(self.textDidChanged), for: .editingChanged)
        self.textId.delegate = self
        self.textEmail.delegate = self
        self.textEmail.addTarget(self, action: #selector(self.textDidChanged), for: .editingChanged)
        self.textPassword.delegate = self
        
        if let ip = UserDefaults.standard.value(forKey: "XnBayIp") as? String {
            self.textIP.text = ip
            
            if ip.hasPrefix("https") {
                segProtocol.selectedSegmentIndex = 1
            } else {
                segProtocol.selectedSegmentIndex = 0
            }
        } else {
            // Test account
            self.textIP.text = "http://4170720224.u2.xnbay.com:5050"
        }
        
        if let email = UserDefaults.standard.value(forKey: "Email") as? String {
            self.textEmail.text = email
            
            if let id = UserDefaults.standard.value(forKey: "UserId_\(email)") as? String {
                self.textId.text = id
            }
        } else {
            // Test account
            self.textEmail.text = "developex.xnbay@gmail.com"
            self.textId.text = "4253cec6-d3fe-1ce8-531c-b637c06a334f"
        }
        
        if let pass = UserDefaults.standard.value(forKey: "Password") as? String {
            self.textPassword.text = pass
        }
        
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.systemBlue.cgColor
        self.btnLogin.layer.cornerRadius = 20
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        
        // Login
        if var ip = self.textIP.text, let id = self.textId.text, var email = self.textEmail.text, let pass = self.textPassword.text {
            email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            // Remove old tasks
            if let last = UserDefaults.standard.value(forKey: "Email") as? String, last != email {
                TaskManager.shared.removeAllTasks()
            }
            
            self.textIP.resignFirstResponder()
            self.textId.resignFirstResponder()
            self.textEmail.resignFirstResponder()
            self.textPassword.resignFirstResponder()
            
            
            if !ip.hasPrefix("http") {
                let ptcol = segProtocol.selectedSegmentIndex == 0 ? "http://" : "https://"
                ip = ptcol + ip
            }
            
            UserDefaults.standard.set(id, forKey: "UserId_\(email)")
            UserDefaults.standard.set(ip, forKey: "XnBayIp")
            UserDefaults.standard.set(email, forKey: "Email")
            UserDefaults.standard.set(pass, forKey: "Password")
            
            DispatchQueue.main.async {
                self.alert = UIAlertController(title: "Login", message: "Please wait...", preferredStyle: .alert)
                self.present(self.alert!, animated: true, completion: nil)
            }
            
            XnBayUtil.shared.login(id: id, ip: ip, email: email, password: pass) { (errno) in
                DispatchQueue.main.async {
                    if errno == 0 {
                        self.alert?.dismiss(animated: true, completion: {
                            // NOTICE: Show a new viewcontroller afer dismiss is completed, otherwise perform fails
                            self.performSegue(withIdentifier: "SegueToMain", sender: self)
                        })
                    } else {
                        self.alert?.message = "Error occurs, errno = \(errno)"
                        self.alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                }
            }
            
        } else {
            self.showAlertMessage("Please input the email and password !")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textIP {
            self.textId.becomeFirstResponder()
        } else if textField == self.textId {
            self.textEmail.becomeFirstResponder()
        } else if textField == self.textEmail {
            self.textPassword.becomeFirstResponder()
        } else {
            self.textPassword.resignFirstResponder()
            self.btnLoginClick(textField)
        }
        return true
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        if textField == self.textIP {
            if var ip = textField.text {
                ip = ip.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if ip.hasPrefix("https") {
                    segProtocol.selectedSegmentIndex = 1
                } else {
                    segProtocol.selectedSegmentIndex = 0
                }
            }
        } else if textField == self.textEmail {
            let isIdEmpty = (self.textId.text ?? "").isEmpty
            if isIdEmpty, var email = textField.text {
                email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if let id = UserDefaults.standard.value(forKey: "UserId_\(email)") as? String {
                    self.textId.text = id
                    print("cctest ===>userId: \(id)")
                }
            }
        }
    }
    
    func showAlertMessage(_ msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
