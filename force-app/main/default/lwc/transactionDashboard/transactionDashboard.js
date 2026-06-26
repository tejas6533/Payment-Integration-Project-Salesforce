import { LightningElement, wire } from 'lwc';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Transaction', fieldName: 'Name' },
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
    { label: 'Receiver', fieldName: 'Receive__c' },
    { label: 'Risk Level', fieldName: 'Risk_Level__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Payment Status', fieldName: 'Payment_Status__c' },

    {
        type: 'button',
        typeAttributes: {
            label: 'Pay',
            name: 'pay',
            variant: 'brand'
        }
    }
];

export default class TransactionDashboard extends LightningElement {

    columns = COLUMNS;
    transactions = [];
    wiredResult;

    @wire(getTransactions)
    wiredTransactions(result) {

        this.wiredResult = result;

        if (result.data) {
            this.transactions = result.data;
        } else if (result.error) {
            console.error(result.error);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Unable to load transactions',
                    variant: 'error'
                })
            );
        }
    }

    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'pay') {

            window.open(
                '/apex/RazorpayCheckout?transactionId=' +
                row.Id +
                '&amount=' +
                row.Amount__c,
                '_blank'
            );

            refreshApex(this.wiredResult);
        }
    }
}