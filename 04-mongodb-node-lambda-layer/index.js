"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = exports.client = void 0;
const mongodb_1 = require("mongodb");
exports.client = new mongodb_1.MongoClient(process.env['MONGODB_CONNECTION_STRING']);
const handler = (event) => __awaiter(void 0, void 0, void 0, function* () {
    const db = yield exports.client.db("sample_mflix");
    const collection = yield db.collection("movies");
    const body = yield collection.find().limit(10).toArray();
    console.log(body);
    // We're done with MongoDB, close the client so that the function doesn't
    // hang.
    exports.client.close();
    const response = {
        statusCode: 200,
        body
    };
    return response;
});
exports.handler = handler;
