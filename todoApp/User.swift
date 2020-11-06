import Firebase

class User: NSObject {
    var id: String
    var name: String
    
    init(doc: QueryDocumentSnapshot) {
        self.id = doc.documentID
        
        let data = doc.data()
        
        self.name = data["name"] as! String
    }
    
    static func registerUserToAuthentication(email: String, password: String, completion: @escaping (Firebase.User?,Error?)->()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                completion(nil,error)
            } else {
                completion(result?.user,nil)
            }
        })
    }
    
    static func createUserToFirestore(userId: String, userName: String, completion: @escaping (Error?)->()) {
        Firestore.firestore().collection("users").document(userId).setData([
            "name": userName
        ]){ error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func loginUserToAuthentication(email: String, password: String, completion: @escaping (Error?)->()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
}
