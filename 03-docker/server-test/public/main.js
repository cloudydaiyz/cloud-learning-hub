const BACKEND_URL = "http://localhost:3000";

let submitButton = document.getElementById("submit_button");
let mainMessage = document.getElementById("main_message");
let textboxToSend = document.getElementById("to_send");

console.log(submitButton);
submitButton.onclick = () => {
    // Update the text of the main message
    mainMessage.innerText = "You clicked the submit button!";
    setTimeout(()=> {
        console.log("After 3 seconds");
        mainMessage.innerText = "Hello there world!";
    }, 3000);

    // Configure options for the fetch function
    const fetchOptions = {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            message: textboxToSend.value
        })
    };

    // Send a POST request to the backend
    fetch(BACKEND_URL, fetchOptions)
        .then((response) => {
            return response.json();
        }).then((data) => {
            console.log(data);
        }).catch((error) => {
            console.log(`Request failed: ${error}`);
        });
};