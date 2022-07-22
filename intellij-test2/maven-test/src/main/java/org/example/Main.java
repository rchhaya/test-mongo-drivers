package org.example;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;

import static com.mongodb.client.model.Filters.eq;

public class Main {
    public static void main(String[] args) {

        Long[] timeArr = new Long[6];
        timeArr[0] = System.currentTimeMillis();
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27018");
        MongoDatabase oldDb = mongoClient.getDatabase("test-java");
        oldDb.drop();
        MongoDatabase db = mongoClient.getDatabase("test-java");
        MongoCollection coll = db.getCollection("test-coll");
        timeArr[1] = System.currentTimeMillis();
        System.out.println(coll.estimatedDocumentCount());
        for (int i = 0; i < 100; i++) {
            coll.insertOne(new Document()
                    .append("key", i));
        }
        timeArr[2] = System.currentTimeMillis();
        System.out.println(coll.estimatedDocumentCount());
        for (int i = 0; i < 100; i++) {
            coll.find(eq("key", i));
        }
        timeArr[3] = System.currentTimeMillis();
        System.out.println(coll.estimatedDocumentCount());
        for (int i = 0; i < 100; i++) {
            Document query = new Document().append("key",  i);
            Bson updates = Updates.combine(
                    Updates.set("key", i  +1 ));
            coll.updateOne(query, updates);
        }
        timeArr[4] = System.currentTimeMillis();
        System.out.println(coll.estimatedDocumentCount());
        for (int i = 0; i < 100; i++) {
            coll.deleteOne(eq("key", i+1));
        }
        timeArr[5] = System.currentTimeMillis();
        System.out.println(coll.estimatedDocumentCount());

        for (int i = 1; i < timeArr.length; i++) {
            System.out.println(timeArr[i] - timeArr[i-1]);
        }
        System.out.println(timeArr[timeArr.length - 1] - timeArr[0]);

    }
}