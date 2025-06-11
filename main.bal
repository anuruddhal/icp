import ballerina/http;
import ballerina/log;

configurable string username = "admin";
configurable string password = "admin";
configurable string baseUrl = "https://localhost:9164/management";

function getAPIs() returns APIs|error {
    // Defines the HTTP client to call the APIs secured with basic authentication.
    // Send a request to the API endpoint to get the list of endpoints with bearer token
    log:printInfo("Fetching APIs from: " + baseUrl);
    http:Client endpointClient = check new (baseUrl,
        auth = {
            token: check getAccessToken()
        },
        secureSocket = {
            enable: false
        }
    );
    APIs apis = check endpointClient->get("/apis");
    return apis;
}

public function getAccessToken() returns string|error {
    // Simulate fetching an access token
    // Defines the HTTP client to call the APIs secured with basic authentication.
    http:Client endpointClient = check new (baseUrl,
        auth = {
            username: username,
            password: password
        },
        secureSocket = {
            enable: false
        }
    );

    // Invokes the API to get the list of all endpoints.
    http:Response response = check endpointClient->get("/login");
    if response.statusCode == 200 {
        json responseBody = check response.getJsonPayload();

        // Assuming the response contains an access token in a field named "access_token"
        json|error accessToken = responseBody.AccessToken;
        if accessToken is string {
            return accessToken;
        }

    }
    return error("Failed to get access token");
}
