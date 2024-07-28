// Client script to test the server running on app.js
import PersistedArray from "./persist.js";
import axios from "axios";

// persist = require("./persist.js");

// axios = require("axios");

function test_server() {
    axios.get("http://localhost:3000").then((res) => {
        console.log(res.data);
    });
}

function test_persist() {
    var url = new URL('.', import.meta.url).pathname;
    var arr = new PersistedArray();
    test_server();

    arr.append("Hello");
    arr.append("World");
    arr.append("How");
    arr.append("Are");
    arr.append("You");
    console.log(arr.size());
    arr.clear(1, 3);
    console.log(arr.size());
    arr.clear();
    console.log(arr.size());

    arr.save();
}

test_persist();