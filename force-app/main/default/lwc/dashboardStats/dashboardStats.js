import { LightningElement, wire } from 'lwc';
import getDashboardStats from '@salesforce/apex/TransactionController.getDashboardStats';

export default class DashboardStats extends LightningElement {

    total = 0;
    pending = 0;
    approved = 0;
    paid = 0;

    @wire(getDashboardStats)
    wiredStats({ data, error }) {

        if(data){
            this.total = data.total;
            this.pending = data.pending;
            this.approved = data.approved;
            this.paid = data.paid;
        }

        if(error){
            console.error(error);
        }
    }
}