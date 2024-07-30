import { Handler } from 'aws-lambda';
import { MongoClient } from "mongodb";

export const client = new MongoClient(process.env['MONGODB_CONNECTION_STRING'] as string);

export const handler: Handler = async(event: any) => {
    const db = await client.db("sample_mflix");
    const collection = await db.collection("movies");
    const body = await collection.find().limit(10).toArray();
    console.log(body);

    // We're done with MongoDB, close the client so that the function doesn't
    // hang.
    client.close();

    const response = {
        statusCode: 200,
        body
    };
    return response;
};