import 'package:mappls_gl/mappls_gl.dart';

void mapKey(){
    const String ACCESS_TOKEN = "c1a6d80c53849abdd8eaa476735396c5";
   const String REST_API_KEY = "c1a6d80c53849abdd8eaa476735396c5";
   const String ATLAS_CLIENT_ID =
      "33OkryzDZsL8vVpXsQoDK9AoKpHAsjNMxCgyC0xlH9kpExAsjgsHcQ3QZaGHdv1fDOs3yi3Ek-Pst93jw1D0gOuup5r_uVhv";
   const String ATLAS_CLIENT_SECRET =
      "lrFxI-iSEg-v-cGe8Jdmdqg7CD1P34ufGjObVmp3qgIzQMMi7eoOMy3c9f-4nYzFNKMpLrIdF1BdR1PHN5df8z3KGxyyloX1SL3JsB86py8=";

    MapplsAccountManager.setMapSDKKey(ACCESS_TOKEN);
    MapplsAccountManager.setRestAPIKey(REST_API_KEY);
    MapplsAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
    MapplsAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);   

}