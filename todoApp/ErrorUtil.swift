import UIKit

class ErrorUtil {
    static func showErrorDialog(error: Error, title: String, viewController: UIViewController) {
        print(title + error.localizedDescription)
        let dialog = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(dialog, animated: true, completion: nil)
    }
}
