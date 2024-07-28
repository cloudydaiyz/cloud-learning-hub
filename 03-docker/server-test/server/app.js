import express from "express";
import path from "path";
import cors from "cors"; // to allow CORS

const app = express();
const port = 3000;
const CWD = new URL('.', import.meta.url).pathname;

let messages = [];

// MIDDLEWARE //
// Enable CORS for all routes
app.use(cors());

// Access to all static files in /public through /static route
app.use("/static", express.static(path.join(CWD, "../public")));

// Body-parsing middleware for parsing application/json
app.use(express.json()); 
// app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded

// ROUTES //
app.get("/", (req, res) => {
    const data = {
        message: "Hello world!"
    };
    res.send(data);
});

app.post("/", (req, res) => {
    console.log(req.body);
    if(req.body.message) {
        messages.push(req.body.message);
    }
    res.send({
        message: "Request received!",
        total_messages: messages
    });
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
});