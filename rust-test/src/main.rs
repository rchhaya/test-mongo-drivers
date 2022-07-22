use mongodb::{Client, options::ClientOptions, bson::{doc, Document}};
use std::{time::Instant, ops::Sub};
#[tokio::main]
    
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut time_vec: Vec<Instant> = vec![Instant::now(); 6];
    time_vec[0] = Instant::now();
    // Parse a connection string into an options struct.
    let mut client_options = ClientOptions::parse("mongodb://localhost:27017").await?;

    // Manually set an option.
    client_options.app_name = Some("My App".to_string());

    // Get a handle to the deployment.
    let client = Client::with_options(client_options)?;
    // Get a handle to a database.
    //let db = client.database("test-rust");
    let db_old = client.database("test-rust");
    db_old.drop(None).await?;
    let db = client.database("test-rust");
    let coll = db.collection::<Document>("test-coll");

    time_vec[1] = Instant::now();
    println!("{}", coll.estimated_document_count(None).await?);
    for i in 0..100 { 
        coll.insert_one(doc! {"key": i}, None).await?;
    }
    time_vec[2] = Instant::now();
    println!("{}", coll.estimated_document_count(None).await?);
    for i in 0..100 { 
        coll.find_one(doc! {"key": i}, None).await?;
    }
    time_vec[3] = Instant::now();
    println!("{}", coll.estimated_document_count(None).await?);
    for i in 0..100 { 
        coll.update_one(doc! {"key": i}, doc! {"$set" : {"key" : i+1}}, None).await?;
    }
    time_vec[4] = Instant::now();
    println!("{}", coll.estimated_document_count(None).await?);
    for i in 0..100 { 
        coll.delete_one(doc! {"key": i + 1}, None).await?;
    }
    time_vec[5] = Instant::now();
    println!("{}", coll.estimated_document_count(None).await?);
    
    for i in 1..time_vec.len() { 
        println!("{}", time_vec[i].sub(time_vec[i-1]).as_millis())
    }
    println!("{}", time_vec[time_vec.len() - 1].sub(time_vec[0]).as_millis());
    Ok(())
}