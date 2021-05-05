//
//  LogInActivityViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 04.03.2021.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInActivityViewController: UIViewController {
    
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var SecondNameLabel: UILabel!
    @IBOutlet weak var SecondNameTextField: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordLabel: UILabel!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var basicLabel: UILabel!
    @IBOutlet weak var iForgetPassword: UIButton!
    
    
    var email: String?
    var password: String?
    
    let db = Firestore.firestore()
    
    var isLoginModeActivated: Bool = true
    var isIForgetPassword: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil { //пользователь уже авторизован
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
        SendButton.layer.cornerRadius = 8
        SignInButton.layer.cornerRadius = 8
        SignInButton.layer.borderWidth = 1
        SignInButton.layer.borderColor = UIColor.blue.cgColor
        
        //EmailTextField.borderStyle = .roundedRect
        
        isLoginModeActivated = true
        
        FirstNameLabel.isHidden = true
        FirstNameTextField.isHidden = true
        SecondNameLabel.isHidden = true
        SecondNameTextField.isHidden = true
        ConfirmPasswordLabel.isHidden = true
        ConfirmPasswordTextField.isHidden = true
        iForgetPassword.isHidden = false
    
        SignInButton.isHidden = false
    }
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        
        if isIForgetPassword { //это часть, если нажимаем на кнопку после смены пароля
            isIForgetPassword = false
            self.basicLabel.text = ""
            isLoginModeActivated = false//сделали так, чтоб если человек передумал воостанавливать пароль, то оказался сразу на окне входа
        }
        
        if isLoginModeActivated {//метод вызван, когда открыт режим входа
            isLoginModeActivated = false
            
            FirstNameLabel.isHidden = false
            FirstNameTextField.isHidden = false
            SecondNameLabel.isHidden = false
            SecondNameTextField.isHidden = false
            ConfirmPasswordLabel.isHidden = false
            ConfirmPasswordTextField.isHidden = false
            
            SendButton.setTitle("Зарегистрироваться", for: .normal)
            SignInButton.setTitle("НАЗАД", for: .normal)
            iForgetPassword.isHidden = true
        } else {//метод вызван, когда открыт режим регистрации
            isLoginModeActivated = true
            
            FirstNameLabel.isHidden = true
            FirstNameTextField.isHidden = true
            SecondNameLabel.isHidden = true
            SecondNameTextField.isHidden = true
            PasswordLabel.isHidden = false
            PasswordTextField.isHidden = false
            ConfirmPasswordLabel.isHidden = true
            ConfirmPasswordTextField.isHidden = true
        
            SendButton.setTitle("ВОЙТИ", for: .normal)
            SignInButton.setTitle("Регистрация", for: .normal)
            iForgetPassword.isHidden = false
        }
    }
    
    
    @IBAction func SendButtonPressed(_ sender: Any) {
        
        email = EmailTextField.text
        password = PasswordTextField.text
        
        
        if isLoginModeActivated { //если у нас вход пользователя
            if EmailTextField.text != "" && PasswordTextField.text != "" && isIForgetPassword == false {
                Auth.auth().signIn(withEmail: email!, password: password!) {
                    [weak self] authResult, error in guard self != nil else {return}
                    if error != nil {//то есть ошибка есть
                        self!.basicLabel.text = "Ошибка авторизации"
                    } else {
                        print("Успешно")
                        self!.basicLabel.text = "Успешно"
                        
                        let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                        self?.present(viewController!, animated: true, completion: nil)
                        
                        //НИЖЕ ЭТО ЧТОБЫ МОЖНО БЫЛО ВЕРНУТЬСЯ НА ПРЕДЫДУЩЕЕ ОКНО, но вообще все смотрели в https://www.youtube.com/watch?v=ZSqEUFZOIzc
                        
//                        let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "NewsViewController")
//                        self?.navigationController?.pushViewController(viewController!, animated: true)
                        
                    }
                  }
            } else {self.basicLabel.text = "Заполните все поля"}
        } else { //если у нас регистрация пользователя идет
            if EmailTextField.text != "" && PasswordTextField.text != "" && FirstNameTextField.text != "" && SecondNameTextField.text != "" && ConfirmPasswordTextField.text != "" && isIForgetPassword == false {
                if PasswordTextField.text == ConfirmPasswordTextField.text {
                    Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                        if error != nil { //то есть ошибка есть
                            self.basicLabel.text = "Ошибка регистрации"
                        } else {
                            self.basicLabel.text = "Успешно"
                            print("Успешно")
                            self.createNewUser()
                        }
                    }
                } else {
                    self.basicLabel.text = "Пароли должны совпадать"
                }
            } else {self.basicLabel.text = "Заполните все поля"}
        }
        
        
        //код в случае, если мы забыли пароль
        if isIForgetPassword {
            if EmailTextField.text != "" {
                Auth.auth().sendPasswordReset(withEmail: EmailTextField.text!) { [self] error in
                    if error == nil {//те ошибки нет
                        self.basicLabel.text = "Письмо отправлено на \(self.EmailTextField.text!)"
                        //isLoginModeActivated = true
                    } else {self.basicLabel.text = "Произошла ошибка"}
                }
            } else {self.basicLabel.text = "Введите Email"}
        }
        
        
    }
    
    
    func createNewUser() {//создаем пользователя в базе данных
        
        let currentUserId: String = Auth.auth().currentUser!.uid
        db.collection("UsersRussia").document(currentUserId).setData([
                                                                        "email" : EmailTextField.text!,
                                                                        "firstName" : FirstNameTextField.text!,
                                                                        "secondName" : SecondNameTextField.text!,
                                                                        "director" : false,
                                                                        "id" : currentUserId])
    }
    
    
    @IBAction func iForgetPasswordPressed(_ sender: Any) {
        
        isIForgetPassword = true
        self.basicLabel.text = "Введите Email"
        
        PasswordLabel.isHidden = true
        PasswordTextField.isHidden = true
        iForgetPassword.isHidden = true
        
        SendButton.setTitle("Отправить пароль", for: .normal)
        SignInButton.setTitle("НАЗАД", for: .normal)
    }
    

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Переход вызван")
        guard segue.identifier == "showNewsAfterLogIn" else {return}//имя перехода от первого ко второму экрану
    }
    
    func showNewsActivity ( _ segue: UIStoryboardSegue) {
        guard segue.identifier == "showNewsAfterLogIn" else {return}//имя перехода от первого ко второму экрану
    }
    


}
