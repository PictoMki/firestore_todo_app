import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        if let email = registerEmailTextField.text,
            let password = registerPasswordTextField.text,
            let name = registerNameTextField.text {
            User.registerUserToAuthentication(email: email, password: password, completion: {(user, error) in
                if let user = user {
                    User.createUserToFirestore(userId: user.uid, userName: name, completion: { error in
                        if let error = error {
                            FuncUtil.showErrorDialog(error: error, title: "Firestore 新規登録失敗", viewController: self)
                        } else {
                            FuncUtil.presentNextViewController(nowViewController: self, withIdentifier: "TodoListViewController")
                        }
                    })
                } else if let error = error {
                    FuncUtil.showErrorDialog(error: error, title: "Auth 新規登録失敗", viewController: self)
                }
            })
        }
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        if let email = loginEmailTextField.text,
            let password = loginPasswordTextField.text {
            User.loginUserToAuthentication(email: email, password: password, completion: { error in
                if let error = error {
                    FuncUtil.showErrorDialog(error: error, title: "ログイン失敗", viewController: self)
                } else {
                    FuncUtil.presentNextViewController(nowViewController: self, withIdentifier: "TodoListViewController")
                }
            })
        }
    }
    

}

