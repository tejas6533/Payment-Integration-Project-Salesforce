public with sharing class RazorpayController {

    @AuraEnabled
    public static String createOrder(Decimal amount) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint('https://api.razorpay.com/v1/orders');
        req.setMethod('POST');

        String keyId = 'rzp_test_T663MutemTAhPq';
        String keySecret = 'mZlcQm1DuqUSjqpjBHLLwOdW';

        String auth = EncodingUtil.base64Encode(
            Blob.valueOf(keyId + ':' + keySecret)
        );

        req.setHeader('Authorization', 'Basic ' + auth);
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String, Object>();

        body.put('amount', Integer.valueOf(amount * 100));
        body.put('currency', 'INR');
        body.put('receipt', 'TXN' + Datetime.now().getTime());

        req.setBody(JSON.serialize(body));

        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            return res.getBody();
        }

        throw new AuraHandledException(res.getBody());
    }
}