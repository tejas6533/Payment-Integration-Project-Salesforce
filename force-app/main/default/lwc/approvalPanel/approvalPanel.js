import { LightningElement, wire } from 'lwc';
import getPendingTransactions from '@salesforce/apex/TransactionController.getPendingTransactions';
import approveTransaction from '@salesforce/apex/TransactionController.approveTransaction';
import rejectTransaction from '@salesforce/apex/TransactionController.rejectTransaction';
import { refreshApex } from '@salesforce/apex';

export default class ApprovalPanel extends LightningElement {

    transactions;
    wiredResult;

    @wire(getPendingTransactions)
    wiredTransactions(result){
        this.wiredResult = result;

        if(result.data){
            this.transactions = result.data;
        }
    }

    approve(event){

        const recordId = event.target.dataset.id;

        approveTransaction({
            transactionId: recordId
        }).then(() => {

            refreshApex(this.wiredResult);

        });
    }

    reject(event){

        const recordId = event.target.dataset.id;

        rejectTransaction({
            transactionId: recordId
        }).then(() => {

            refreshApex(this.wiredResult);

        });
    }
}