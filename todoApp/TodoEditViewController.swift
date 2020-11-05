import UIKit
import Firebase

class TodoEditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var isDoneLabel: UILabel!
    
    var todoId: String!
    var todoTitle: String!
    var todoDetail: String!
    var todoIsDone: Bool!
    
    var todo: Todo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = todo.title
        detailTextView.text = todo.detail
        
        switch todo.isDone {
        case false:
            isDoneLabel.text = "未完了"
            doneButton.setTitle("完了済みにする", for: .normal)
        default:
            isDoneLabel.text = "完了"
            doneButton.setTitle("未完了にする", for: .normal)
        }
    }
    
   override func viewDidLayoutSubviews() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        if let title = titleTextField.text,
            let detail = detailTextView.text {
            todo.title = title
            todo.detail = detail
            Todo.contentUpdate(todo: todo, completion: { error in
                if let error = error {
                    FuncUtil.showErrorDialog(error: error, title: "TODO更新失敗", viewController: self)
                } else {
                    print("TODO更新成功")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        Todo.isDoneUpdate(todo: todo, completion: { error in
            if let error = error {
                FuncUtil.showErrorDialog(error: error, title: "TODO更新失敗", viewController: self)
            } else {
                print("TODO更新成功")
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        Todo.delete(todo: todo, completion: { error in
            if let error = error {
                FuncUtil.showErrorDialog(error: error, title: "TODO削除失敗", viewController: self)
            } else {
                print("TODO削除成功")
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
