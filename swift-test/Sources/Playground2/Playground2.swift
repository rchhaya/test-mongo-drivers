import MongoSwift
import NIO
import Foundation

@main
public struct Playground2 {
    
    public static func main() async throws {
        var dates : [Date] = []
        dates.append(Date())
        let elg = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = try MongoClient(using: elg)
 
        let dbOld = client.db("test-swift")
        try await dbOld.drop()
        let db = client.db("test-swift")
        let coll = db.collection("test-coll")
        defer {
            let _ = db.drop()
            let _ = client.close()
            try! elg.syncShutdownGracefully()
            }
        print(try await coll.estimatedDocumentCount())
        dates.append(Date())
        for i in 1...100 {
            try await coll.insertOne(["key" : BSON.int32(Int32(i))])
        }
        dates.append(Date())
        print(try await coll.estimatedDocumentCount())
        for i in 1...100 {
            let _ = try await coll.findOne(["key" : BSON.int32(Int32(i))])
        }
        dates.append(Date())
        print(try await coll.estimatedDocumentCount())
        for i in 1...100 {
            try await coll.updateOne(filter: ["key" : BSON.int32(Int32(i))], update: ["$set" : ["key": BSON.int32(Int32(i + 1))]])
        }
        dates.append(Date())
        print(try await coll.estimatedDocumentCount())
        for i in 1...100 {
            try await coll.deleteOne(["key" : BSON.int32(Int32(i + 1))])
        }
        dates.append(Date())
        print(try await coll.estimatedDocumentCount())
        
        for i in 1..<dates.count {
            print(dates[i].timeIntervalSince(dates[i-1]))
        }
        print(dates[dates.count-1].timeIntervalSince(dates[0]))
    
        
    }
    
    
}
