library backend__root_url;

String serverRootURL = '';

void loadConfig(String env, String region) {
  if(env == "PROD") {
    serverRootURL = 'https://bus.hollinger.asia';
  }
  else {
    serverRootURL = 'http://192.168.1.100:5000';
  }
}