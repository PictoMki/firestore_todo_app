import UIKit
import Firebase

class SplashViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { bool in
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 20, y: 20)
            }) { bool in
                if Auth.auth().currentUser != nil {
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "TodoListViewController")
                    self.present(next, animated: true, completion: nil)
                } else {
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(next, animated: true, completion: nil)
                }
            }
        }
    }
}
