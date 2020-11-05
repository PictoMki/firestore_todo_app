import Firebase

class Todo: NSObject {
    var id: String
    var title: String
    var detail: String
    var isDone: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(doc: QueryDocumentSnapshot) {
        self.id = doc.documentID
        
        let data = doc.data()
        
        self.title = data["title"] as! String
        self.detail = data["detail"] as! String
        self.isDone = data["isDone"] as! Bool
        
        let createdAtTimestamp = data["createdAt"] as! Timestamp
        let updatedAtTimestamp = data["updatedAt"] as! Timestamp
        
        self.createdAt = createdAtTimestamp.dateValue()
        self.updatedAt = updatedAtTimestamp.dateValue()
    }
    
    static func getTodoList(isDone: Bool, completion: @escaping ([Todo]?,Error?)->()){
        var todoList:[Todo] = []
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").getDocuments(completion: {(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let documents = querySnapshot.documents
                    for doc in documents {
                        let todo = Todo(doc: doc)
                        todoList.append(todo)
                    }
                    completion(todoList,nil)
                } else if let error = error {
                    completion([],error)
                }
            })
        }
    }
    
    static func todoListListener(isDone: Bool, completion: @escaping ([Todo]?,Error?)->()){
        var todoList:[Todo] = []
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let documents = querySnapshot.documents
                    for doc in documents {
                        let todo = Todo(doc: doc)
                        todoList.append(todo)
                    }
                    completion(todoList,nil)
                } else if let error = error {
                    completion([],error)
                }
            })
        }
    }
    
    static func create(title: String, detail: String, completion: @escaping (Error?)->()) {
        if let user = Auth.auth().currentUser {
            let createdTime = FieldValue.serverTimestamp()
            Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(
                [
                    "title": title,
                    "detail": detail,
                    "isDone": false,
                    "createdAt": createdTime,
                    "updatedAt": createdTime
            ], merge: true){ error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func isDoneUpdate(todo: Todo, completion: @escaping (Error?)->()) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").document().updateData(
                [
                    "isDone": !todo.isDone,
                    "updatedAt": FieldValue.serverTimestamp()
            ]){ error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func contentUpdate(todo: Todo, completion: @escaping (Error?)->()) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").document().updateData(
                [
                    "title": todo.title,
                    "detail": todo.detail,
                    "updatedAt": FieldValue.serverTimestamp()
            ]){ error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func delete(todo: Todo, completion: @escaping (Error?)->()) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").document(todo.id).delete(){ error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
