//
//  ResetPasswordController.swift
//  InstagramTutorial
//
//  Created by Murat on 17.06.2023.
//

import UIKit
import FirebaseAuth

protocol ResetPasswordControllerDelegate : AnyObject {
    func controllerDidSendResetPasswordLink(_ controller : ResetPasswordController)
}

class ResetPasswordController : UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate : ResetPasswordControllerDelegate?
    
    private let emailTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
    
    
    private lazy var resetPasswordButton : CustomButton = {
        let btn = CustomButton(title: "Reset Password")
        btn.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGray.cgColor,UIColor.black.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        iconImage.contentMode = .scaleAspectFill
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,resetPasswordButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32,height: 120)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 16,paddingLeft: 16)
    }
    
    func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .allEditingEvents)
    }
    
    //MARK: - Actions
    
    @objc func handleResetPassword(){
        
        guard let email = emailTextField.text else {return}
        showLoader(true)
        AuthService.resetPassword(with: email) { error in
            
            if let error = error {
                self.showLoader(false)
                self.showMessage(withTitle: "ERROR", message: error.localizedDescription)
                return
            }
            self.showLoader(false)
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
        
    }
    @objc func handleDissmiss(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        
            viewModel.email = sender.text
            
            updateForm()
    }
}

//MARK: - FormViewModel

extension ResetPasswordController : FormViewModel {
    func updateForm() {
        resetPasswordButton.isEnabled = viewModel.isValid
        
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
    }
}
