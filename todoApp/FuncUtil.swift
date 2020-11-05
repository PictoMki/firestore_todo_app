import UIKit

class FuncUtil {
    static func showErrorDialog(error: Error, title: String, viewController: UIViewController) {
        print(title + error.localizedDescription)
        let dialog = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(dialog, animated: true, completion: nil)
    }
    
    static func presentNextViewController(nowViewController: UIViewController, withIdentifier: String) {
        let storyboard: UIStoryboard = nowViewController.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: withIdentifier)
        nowViewController.present(next, animated: true, completion: nil)
    }
}
