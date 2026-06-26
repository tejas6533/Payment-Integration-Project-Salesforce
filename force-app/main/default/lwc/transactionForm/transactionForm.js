import { LightningElement } from 'lwc';
import createTransaction from '@salesforce/apex/TransactionController.createTransaction';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TransactionForm extends LightningElement {

    amount;
    receiver;

    handleAmount(event) {
        this.amount = event.target.value;
    }

    handleReceiver(event) {
        this.receiver = event.target.value;
    }

    handleSubmit() {

        createTransaction({
            amount: this.amount,
            receiver: this.receiver
        })
        .then(result => {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: result,
                    variant: 'success'
                })
            );

            this.amount = '';
            this.receiver = '';

        })
        .catch(error => {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            );

        });
    }
}