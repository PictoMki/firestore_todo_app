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
                    // 成功の場合
                    print("ユーザー作成完了 uid:" + user.uid)
                    Firestore.firestore().collection("users").document().setData([
                        "email": email,
                        "name": name
                    ], completion: { error in
                        if let error = error {
                            // 失敗した場合
                            print("Firestore 新規登録失敗 " + error.localizedDescription)
                            let dialog = UIAlertController(title: "Firestore 新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            // 成功の場合
                            print("ユーザー作成完了 name:" + name)
                            let storyboard: UIStoryboard = self.storyboard!
                            let next = storyboard.instantiateViewController(withIdentifier: "TodoViewController")
                            self.present(next, animated: true, completion: nil)
                        }
                    })
                } else if let error = error {
                    // 失敗した場合
                    print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "Firebase Auth 新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        if let email = loginEmailTextField.text,
            let password = loginPasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    // 成功した場合
                    print("ログイン完了 uid:" + user.uid)
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "TodoViewController")
                    self.present(next, animated: true, completion: nil)
                } else if let error = error {
                    // 失敗した場合
                    print("ログイン失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "ログイン失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }
    

}

