using MongoDB.Bson;
using MongoDB.Driver;

class TestClass
{
    static void Main(string[] args)
    {
        DateTime[] timeArr = new DateTime[6];
        timeArr[0] = DateTime.Now;
        var settings = MongoClientSettings.FromConnectionString("mongodb://localhost:27018");
        settings.ServerApi = new ServerApi(ServerApiVersion.V1);
        var client = new MongoClient(settings);
        client.DropDatabase("test-csharp");

        var db = client.GetDatabase("test-csharp");
        var coll = db.GetCollection<BsonDocument>("test-coll");
        timeArr[1] = DateTime.Now;
        Console.WriteLine(coll.EstimatedDocumentCount());
        for (int i = 0; i < 100; i++)
        {
            coll.InsertOne(new BsonDocument("key", i));
        }
        timeArr[2] = DateTime.Now;
        Console.WriteLine(coll.EstimatedDocumentCount());
        for (int i = 0; i < 100; i++)
        {
            coll.Find(new BsonDocument("key", i));

        }
        timeArr[3] = DateTime.Now;
        Console.WriteLine(coll.EstimatedDocumentCount());
        for (int i = 0; i < 100; i++)
        {
            coll.UpdateOne(Builders<BsonDocument>.Filter.Eq("key", i),
                Builders<BsonDocument>.Update.Set("key", i + 1));
        }
        timeArr[4] = DateTime.Now;
        Console.WriteLine(coll.EstimatedDocumentCount());
        for (int i = 0; i < 100; i++)
        {
            coll.DeleteOne(new BsonDocument("key", i + 1));
        }
        timeArr[5] = DateTime.Now;
        Console.WriteLine(coll.EstimatedDocumentCount());

        for (int i = 1; i < timeArr.Length; i++)
        {
            Console.WriteLine(timeArr[i].Subtract(timeArr[i - 1]).TotalMilliseconds);
        }
        Console.WriteLine(timeArr[timeArr.Length - 1].Subtract(timeArr[0]).TotalMilliseconds);


    }
}


