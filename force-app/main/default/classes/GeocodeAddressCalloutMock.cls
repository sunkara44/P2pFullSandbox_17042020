@isTest
global class GeocodeAddressCalloutMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"location":{'+'"lat" : 37.79410130,'+'"lon":-122.39510960'+'}}');
        res.setStatusCode(200);
        return res; 
    }
}