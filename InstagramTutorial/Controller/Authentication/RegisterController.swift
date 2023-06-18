//
//  RegisterController.swift
//  InstagramTutorial
//
//  Created by Murat on 28.04.2023.
//

import UIKit

class RegisterController : UIViewController {
    
    //MARK: - Properties
    
    private var selectedImage = UIImage(systemName: "plus.viewfinder")!
    
    private var picker = UIImagePickerController()
    
    private var viewModel = RegistrationViewModel()
    
    weak var delegate : AuthenticationDelegate?
         
    private lazy var pickerButton : UIButton = {
        
        var button = UIButton(type: .system)
        
        button.setImage(selectedImage, for: .normal)
       
        button.backgroundColor = .clear
        
        button.layer.borderWidth = 2
        
        button.layer.borderColor = CGColor(gray: 1, alpha: 0.5)
        
        button.imageView?.contentMode = .scaleAspectFill
        
        button.addTarget(self, action: #selector(pickImg), for: .touchUpInside)
        
        button.tintColor = .white
        
        button.layer.cornerRadius = 100/2
        
        return button
     
        
    }()
    
    
    private let emailTextField : UITextField = {
       
        let tf = CustomTextField(placeholder: "Email")
        
        return tf
    }()
    
    private let passwordTextField : UITextField = {
       
        let tf = CustomTextField(placeholder: "Password")
        
        return tf
    }()
    
    private let fullnameTextField : UITextField = {
       
        let tf = CustomTextField(placeholder: "Fullname")
        
        return tf
    }()
    
    private let usernameTextField : UITextField = {
       
        let tf = CustomTextField(placeholder: "Username")
        
        return tf
    }()
    
    private let singUpButton : UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setHeight(50)
        button.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        return button
    }()
    
    private let alreadyAccountButton : UIButton = {
       
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart: "Already have an account? ", secondPart: "Log In")
        
        button.addTarget(self, action: #selector(goToLogin(sender:)), for: .touchUpInside)

        return button
    }()
    
    //MARK: - LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObserver()
    }

    //MARK: - Helpers
    
    func configureUI(){
        
        configureGradientLayer()
        picker.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,fullnameTextField,usernameTextField,singUpButton])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(pickerButton)
        pickerButton.setDimensions(height: 100, width: 100)
        pickerButton.centerX(inView: view,topAnchor: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
      
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: pickerButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.centerX(inView: view)
        alreadyAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 32)
        
    }
    
    func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - SelectorFuncs
    
    @objc func createUser(){
        
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let username = usernameTextField.text else{return}
        guard let fullname = fullnameTextField.text else{return}
        var profileImg = selectedImage
        
        let credentials = AuthCredentials(email: email,password: password,fullname: fullname,username: username,profileImage: profileImg)
        
        AuthService.registerUser(with: credentials) { error in
            
            if error != nil {
                self.showMessage(withTitle: "ERROR", message: error!.localizedDescription)
                return
            }
            
            self.delegate?.authenticationDidComplete()
            
        }
        
    }
    
    @objc func goToLogin(sender:UIButton){
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pickImg(){
        
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        case fullnameTextField:
            viewModel.fullname = sender.text
        case usernameTextField:
            viewModel.username = sender.text
        default:
            print("ERROR")
        }
        
        updateForm()
    }
}

//MARK: - UIImagePickerDelegate

extension RegisterController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImage = image
            pickerButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            pickerButton.layer.masksToBounds = true
            pickerButton.layer.cornerRadius = pickerButton.frame.width / 2
            
            self.dismiss(animated: true)
        }
    }
}

//MARK: - FormViewModel

extension RegisterController : FormViewModel {
    func updateForm() {
        singUpButton.backgroundColor = viewModel.buttonBackgroundColor
        singUpButton.isEnabled = viewModel.isValid
    }
    
    
}
