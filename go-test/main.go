package main

import (
	"context"
	"log"
	"time"
	//"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	// if err := godotenv.Load(); err != nil {
	// 	log.Println("No .env file found")
	// }
	var timeArr [6]time.Time
	timeArr[0] = time.Now()
	uri := "mongodb://localhost:27017" //os.Getenv("MONGODB_URI")
	// if uri == "" {
	// 	log.Fatal("You must set your 'MONGODB_URI' environmental variable. See\n\t https://www.mongodb.com/docs/drivers/go/current/usage-examples/#environment-variable")
	// }
	client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(uri))
	if err != nil {
		panic(err)
	}
	defer func() {
		if err := client.Disconnect(context.TODO()); err != nil {
			panic(err)
		}
	}()
	client.Database("test-go").Drop(context.Background())
	coll := client.Database("test-go").Collection("test-coll")
	timeArr[1] = time.Now()
	log.Println(coll.EstimatedDocumentCount(context.Background()))
	for i := 0; i < 100; i++ {
		coll.InsertOne(context.Background(), bson.D{{"key", i}})
	}
	timeArr[2] = time.Now()
	log.Println(coll.EstimatedDocumentCount(context.Background()))
	for i := 0; i < 100; i++ {
		coll.FindOne(context.Background(), bson.D{{"key", i}})
	}
	timeArr[3] = time.Now()
	log.Println(coll.EstimatedDocumentCount(context.Background()))
	
	for i := 0; i < 100; i++ {
		coll.UpdateOne(context.Background(), bson.D{{"key", i}},
			bson.D{{"$set", bson.D{{"key", i + 1}}}})
	}
	timeArr[4] = time.Now()
	log.Println(coll.EstimatedDocumentCount(context.Background()))
	for i := 0; i < 100; i++ {
		coll.DeleteOne(context.Background(), bson.D{{"key", i + 1}})
	}
	timeArr[5] = time.Now()
	log.Println(coll.EstimatedDocumentCount(context.Background()))

	for i:=1; i < len(timeArr); i++ {
		log.Println(timeArr[i].Sub(timeArr[i-1]).Milliseconds())
	}
	log.Println(timeArr[5].Sub(timeArr[0]).Milliseconds())
	
}
