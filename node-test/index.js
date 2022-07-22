const { MongoClient } = require("mongodb");
// Replace the uri string with your connection string.
const uri =
  "mongodb+srv://<user>:<password>@<cluster-url>?retryWrites=true&writeConcern=majority";
const client = new MongoClient("mongodb://localhost:27017");
async function run() {
  try {
    const dates = []
    dates.push(Date.now())
    const dbOld = client.db('test-node');
    await dbOld.dropDatabase()
    const db = client.db('test-node');
    const coll = db.collection('test-coll');

    console.log((await coll.estimatedDocumentCount()).toString())
    dates.push(Date.now())
    for (let i = 0; i < 100; i++) { 
      await coll.insertOne({ "key": i });
    }
    console.log((await coll.estimatedDocumentCount()).toString())
    dates.push(Date.now())
    for (let i = 0; i < 100; i++) { 
      await coll.findOne({ "key": i });
    }
    console.log((await coll.estimatedDocumentCount()).toString())
    dates.push(Date.now())
    for (let i = 0; i < 100; i++) { 
      await coll.updateOne({ "key": i }, { $set: { "key": i + 1 } });
    }
    console.log((await coll.estimatedDocumentCount()).toString())
    dates.push(Date.now())
    for (let i = 0; i < 100; i++) { 
      await coll.deleteOne({ "key": i + 1 });
    }
    console.log((await coll.estimatedDocumentCount()).toString())
    dates.push(Date.now())

    for (let i = 1; i < dates.length; i++) { 
      console.log(dates[i] - dates[i-1])
    }
    console.log(dates[dates.length - 1] - dates[0])
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);