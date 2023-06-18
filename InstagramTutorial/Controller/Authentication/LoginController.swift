//
//  LoginController.swift
//  InstagramTutorial
//
//  Created by Murat on 28.04.2023.
//

import UIKit
import FirebaseAuth

protocol AuthenticationDelegate : AnyObject {
    func authenticationDidComplete()
}

class LoginController : UIViewController {
    
    //MARK: - Properties
    
   // var isSecureText : Bool = false
    
    private var viewModel = LoginViewModel()
    
    weak var delegate : AuthenticationDelegate?
    
    private let iconImage : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        
        let button = CustomTextFieldButton(systemname: "envelope")
        
        tf.rightView = button
        
        return tf
    }()
    
    private lazy var passwordTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.keyboardType = .emailAddress
        tf.isSecureTextEntry = false
        let button = CustomTextFieldButton(systemname: "eye")
        button.addTarget(self, action: #selector(isSecure), for: .touchUpInside)
        tf.rightView = button
        return tf
    }()
    
    private lazy var button : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .darkGray
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.isEnabled = false
        btn.setHeight(50)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    private let forgotPasswordButton : UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password? ", secondPart: "Get help signing in.")
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
        
    }()
    
    private let dontHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up.")
        button.addTarget(self, action: #selector(goRegister(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
        
        
    }
    //MARK: - Helpers
    
    func configureUI(){
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = true
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGray.cgColor,UIColor.black.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,button])
        stack.spacing = 20
        stack.axis = .vertical
        
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: iconImage.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stack.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 20)
    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - SelectorFuncs
    
    @objc func handleLogin(){

        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        
        AuthService.loginUser(email: email, password: password) { result,error in
            
            if error != nil {
                
                self.showMessage(withTitle: "\(error!.localizedDescription)", message: "Error")
                return
            }
            
            self.delegate?.authenticationDidComplete()

        }
    }
    
    @objc func handleShowResetPassword(){
        let controller = ResetPasswordController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func isSecure(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.setImage(UIImage(systemName: passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
    }
    
    @objc func goRegister(sender:UIButton) {
        
        let vc = RegisterController()
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
        updateForm()
    }
}

//MARK: - FormViewModel

extension LoginController : FormViewModel {
    func updateForm() {
        button.backgroundColor = viewModel.buttonBackgroundColor
        button.isEnabled = viewModel.isValid
    }
}

//MARK: - ResetPasswordControllerDelegate
extension LoginController : ResetPasswordControllerDelegate {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "SUCCESS", message: "We sent a link to your email to reset your password")
    }
    
    
    
    
}
