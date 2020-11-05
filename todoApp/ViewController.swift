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
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ユーザー作成完了 uid:" + user.uid)
                    Firestore.firestore().collection("users").document(user.uid).setData([
                        "name": name
                    ], completion: { error in
                        if let error = error {
                            FuncUtil.showErrorDialog(error: error, title: "Firestore 新規登録失敗", viewController: self)
                        } else {
                            print("ユーザー作成完了 name:" + name)
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
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ログイン完了 uid:" + user.uid)
                    FuncUtil.presentNextViewController(nowViewController: self, withIdentifier: "TodoListViewController")
                } else if let error = error {
                    FuncUtil.showErrorDialog(error: error, title: "ログイン失敗", viewController: self)
                }
            })
        }
    }
    

}

