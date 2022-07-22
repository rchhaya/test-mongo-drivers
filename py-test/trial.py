import pymongo 
import time 

times = []
times.append(time.time())
client = pymongo.MongoClient("localhost", 27018)
client.drop_database("test-python")
db = client.get_database("test-python")
coll = db.get_collection("test-coll")
times.append(time.time())
print(coll.estimated_document_count())
for i in range(0, 100):
    coll.insert_one({"key": i})
times.append(time.time())
print(coll.estimated_document_count())
for i in range(0, 100):
    coll.find_one({"key": i})
times.append(time.time())
print(coll.estimated_document_count())
for i in range(0, 100):
    coll.update_one({"key": i}, {"$set" : {"key" : i + 1}})
times.append(time.time())
print(coll.estimated_document_count())
for i in range(0, 100):
    coll.delete_one({"key": i + 1})
times.append(time.time())
print(coll.estimated_document_count())
for i in range(1, len(times)):
    print(times[i] - times[i-1])
print(times[-1] - times[0])