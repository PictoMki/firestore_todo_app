import Firebase

class Todo: NSObject {
    var id: String
    var title: String
    var detail: String?
    var isDone: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(doc: QueryDocumentSnapshot) {
        self.id = doc.documentID
        
        let data = doc.data()
        
        self.title = data["title"] as! String
        self.detail = data["detail"] as? String
        self.isDone = data["isDone"] as! Bool
        
        let createdAtTimestamp = data["createdAt"] as! Timestamp
        let updatedAtTimestamp = data["updatedAt"] as! Timestamp
        
        self.createdAt = createdAtTimestamp.dateValue()
        self.updatedAt = updatedAtTimestamp.dateValue()
    }
}
