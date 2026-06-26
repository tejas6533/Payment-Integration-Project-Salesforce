public with sharing class RazorpayVFController {

    public String paymentId {get;set;}
    public Decimal amount {get;set;}
    public String transactionId {get;set;}

    public RazorpayVFController() {

        transactionId = ApexPages.currentPage().getParameters().get('transactionId');

        String amt = ApexPages.currentPage().getParameters().get('amount');

        if(amt != null){
            amount = Decimal.valueOf(amt);
        }
    }

    public PageReference updatePayment() {

        if(transactionId != null && paymentId != null){

            Transaction__c tr = [

                SELECT Id

                FROM Transaction__c

                WHERE Id=:transactionId

                LIMIT 1

            ];

            tr.Payment_ID__c = paymentId;
            tr.Payment_Status__c='Success';
            tr.Status__c='Paid';

            update tr;
        }

        PageReference page = new PageReference('/lightning/n/Zero_Trust');
        page.setRedirect(true);
        return page;
    }
}