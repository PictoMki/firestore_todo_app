import UIKit
import Firebase

class TodoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var isDone: Bool = false
    var todoArray: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ①ログイン済みかどうか確認
        if let user = Auth.auth().currentUser {
            // ②ログインしているユーザー名の取得
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.userNameLabel.text = data["name"] as? String
                    }
                } else if let error = error {
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
            })
        }
        Todo.todoListListener(isDone: isDone, completion: { (todoList, error) in
            if let todoList = todoList {
                self.todoArray = todoList
            } else if let error = error {
                print("TODO取得失敗: " + error.localizedDescription)
                self.todoArray = []
            }
            self.tableView.reloadData()
        })
    }
    
    func getTodoDataForFirestore() {
        Todo.getTodoList(isDone: self.isDone, completion: {(todoList, error) in
            if let todoList = todoList {
                self.todoArray = todoList
            } else if let error = error {
                print("TODO取得失敗: " + error.localizedDescription)
                self.todoArray = []
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit",
                                            handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                Todo.isDoneUpdate(todo: self.todoArray[indexPath.row], completion: { error in
                                                    if let error = error {
                                                        FuncUtil.showErrorDialog(error: error, title: "TODO更新失敗", viewController: self)
                                                    } else {
                                                        print("TODO更新成功")
                                                        self.getTodoDataForFirestore()
                                                    }
                                                })
        })
        editAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
        
        switch isDone {
        case true:
            editAction.image = UIImage(systemName: "arrowshape.turn.up.left")
        default:
            editAction.image = UIImage(systemName: "checkmark")
        }
        
        
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete",
                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                                                Todo.delete(todo: self.todoArray[indexPath.row], completion: { error in
                                                    if let error = error {
                                                        FuncUtil.showErrorDialog(error: error, title: "TODO削除失敗", viewController: self)
                                                    } else {
                                                        print("TODO削除成功")
                                                        self.getTodoDataForFirestore()
                                                    }
                                                })
            })
        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
        deleteAction.image = UIImage(systemName: "clear")
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        // fullスワイプ時に挙動が起きないように制御
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "TodoEditViewController") as! TodoEditViewController
        next.todo = todoArray[indexPath.row]
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        FuncUtil.presentNextViewController(nowViewController: self, withIdentifier: "TodoAddViewController")
    }
    
    @IBAction func tapLogoutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("ログアウト完了")
                FuncUtil.presentNextViewController(nowViewController: self, withIdentifier: "ViewController")
            } catch let error as NSError {
                FuncUtil.showErrorDialog(error: error, title: "ログアウト失敗", viewController: self)
            }
        }
    }
    
    @IBAction func changeDoneControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isDone = false
            getTodoDataForFirestore()
        case 1:
            isDone = true
            getTodoDataForFirestore()
        default:
            isDone = false
            getTodoDataForFirestore()
        }
    }
    
}
