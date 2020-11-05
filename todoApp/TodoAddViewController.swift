import UIKit
import Firebase

class TodoAddViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        // TextViewのレイアウトをTextField似合わせるためのコード
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        if let title = titleTextField.text,
            let detail = detailTextView.text {
            Todo.create(title: title, detail: detail, completion: { error in
                if let error = error {
                    FuncUtil.showErrorDialog(error: error,title: "TODO追加失敗", viewController: self)
                } else {
                    print("TODO作成成功")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
