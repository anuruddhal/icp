import ballerina/graphql;
import ballerina/log;
import ballerina/time;

// Define record types to match the response structure

public type DeploymentTrack record {|
    string id;
    string createdAt;
    string updatedAt;
    string apiVersion;
    string branch;
    string description?; // Field is optional
    string componentId;
    boolean latest;
    string versionStrategy;
    boolean autoDeployEnabled;
|};

public type Component record {|
    string projectId;
    string id;
    string description?; // Field is optional
    string status;
    string initStatus;
    string name;
    string handler;
    string displayName;
    string displayType;
    string version;
    string createdAt;
    string lastBuildDate;
    string orgHandler;
    string componentSubType?; // Field is optional
    Repository repository;
    ApiVersion[] apiVersions;
    DeploymentTrack[] deploymentTracks;
|};

public type Repository record {|
    BuildpackConfig buildpackConfig?; // Field is optional
    ByocWebAppBuildConfig byocWebAppBuildConfig?; // Field is optional
|};

public type Buildpack record {|
    string id?; // Field is optional
    string name?; // Field is optional
    string description?; // Field is optional
    string version?; // Field is optional
    string language?; // Field is optional
    string buildContext?; // Field is optional
    string languageVersion?; // Field is optional
    string buildpackType?; // Field is optional
    string buildpackUrl?; // Field is optional
    boolean latest?; // Field is optional
|};

public type BuildpackConfig record {|
    string versionId?; // Field is optional
    string buildContext?; // Field is optional
    string languageVersion?; // Field is optional
    Buildpack buildpack?; // Field is optional
|};

public type ByocWebAppBuildConfig record {|
    string id?; // Field is optional
    string dockerContext?; // Field is optional
    string webAppType?; // Field is optional
|};

public type ApiVersion record {|
    string apiVersion;
    string proxyName;
    string proxyUrl;
    string proxyId?; // Field is optional
    string id;
    string state?; // Field is optional
    boolean latest;
    string branch;
    string accessibility;
|};

// GraphQL service
@graphql:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowHeaders: ["content-type", "authorization"],
        allowCredentials: true
    }
}
service /graphql on new graphql:Listener(9090, {
    requestLimits: {
        maxHeaderSize: 1024000
    }
}) {

    // GraphQL query to return filtered components
    resource function get components(string orgHandler, string projectId) returns Component[]|error {
        log:printInfo("Fetching components for org: " + orgHandler + " and project: " + projectId);
        Component[] components = [
            // {
            //     projectId: "1d11abe4-cd3b-4cdd-bf67-96a1bf064adc",
            //     id: "6b3d7f0d-3993-4e4c-855e-e4c82a35d7e6",
            //     description: "Music for Weather APP 2",
            //     status: "SUCCESSFUL",
            //     initStatus: "completed",
            //     name: "musicforweather2",
            //     handler: "musicforweather2",
            //     displayName: "MusicForWeather2",
            //     displayType: "ballerinaService",
            //     'version: "v1.0",
            //     createdAt: time:utcToString(time:utcNow()),
            //     lastBuildDate: time:utcToString(time:utcNow()),
            //     orgHandler: "cloud",
            //     componentSubType: " ",
            //     repository: {
            //         buildpackConfig: null,
            //         byocWebAppBuildConfig: null
            //     },
            //     apiVersions: [
            //         {
            //             apiVersion: "v1.0",
            //             proxyName: "",
            //             proxyUrl: "",
            //             proxyId: null,
            //             id: "0231acff-1478-413f-a1d2-2d142829e5cb",
            //             state: null,
            //             latest: true,
            //             branch: "main",
            //             accessibility: "external"
            //         }
            //     ],
            //     deploymentTracks: [
            //         {
            //             id: "0231acff-1478-413f-a1d2-2d142829e5cb",
            //             createdAt: time:utcToString(time:utcNow()),
            //             updatedAt: time:utcToString(time:utcNow()),
            //             apiVersion: "v1.0",
            //             branch: "main",
            //             description: null,
            //             componentId: "6b3d7f0d-3993-4e4c-855e-e4c82a35d7e6",
            //             latest: true,
            //             versionStrategy: "MajorMinor",
            //             autoDeployEnabled: true
            //         }

            //     ]
            // }

        ];
        // Validate input parameters
        APIs apiList = check getAPIs();
        log:printInfo("Fetched APIs: " + apiList.toString());

        foreach API api in apiList.list {
            Component component = {
                projectId: "1d11abe4-cd3b-4cdd-bf67-96a1bf064adc",
                id: "6b3d7f0d-3993-4e4c-855e-e4c82a35d7e6",
                description: api.url,
                status: "SUCCESSFUL",
                initStatus: "completed",
                name: api.name,
                handler: api.name,
                displayName: api.name,
                displayType: "ballerinaService",
                'version: "v1.0",
                createdAt: time:utcToString(time:utcNow()),
                lastBuildDate: time:utcToString(time:utcNow()),
                orgHandler: "cloud",
                componentSubType: " ",
                repository: {
                    buildpackConfig: null,
                    byocWebAppBuildConfig: null
                },
                apiVersions: [
                    {
                        apiVersion: "v1.0",
                        proxyName: "",
                        proxyUrl: "",
                        proxyId: null,
                        id: "0231acff-1478-413f-a1d2-2d142829e5cb",
                        state: null,
                        latest: true,
                        branch: "main",
                        accessibility: "external"
                    }
                ],
                deploymentTracks: [
                    {
                        id: "0231acff-1478-413f-a1d2-2d142829e5cb",
                        createdAt: time:utcToString(time:utcNow()),
                        updatedAt: time:utcToString(time:utcNow()),
                        apiVersion: "v1.0",
                        branch: "main",
                        description: null,
                        componentId: "6b3d7f0d-3993-4e4c-855e-e4c82a35d7e6",
                        latest: true,
                        versionStrategy: "MajorMinor",
                        autoDeployEnabled: true
                    }

                ]

            };
            components.push(component);
        }

        // Filter components based on orgHandler and projectId
        Component[] filteredComponents = from var component in components
            where component.orgHandler == orgHandler && component.projectId == projectId
            select component;

        if filteredComponents.length() == 0 {
            return error("No components found for the given criteria");
        }

        return filteredComponents;
    }
}
