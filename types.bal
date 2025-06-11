type Endpoints record {|
    int count;
    Endpoint[] list;
|};

type Endpoint record {|
    string name;
    string 'type;
|};

type API record {|
    string name;
    string[] urlList;
    string tracing;
    string url;
|};

type APIs record {|
    int count;
    API[] list;
|};
