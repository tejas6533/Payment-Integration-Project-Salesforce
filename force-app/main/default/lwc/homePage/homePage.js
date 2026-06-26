import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class HomePage extends NavigationMixin(LightningElement) {

    openTransactionForm() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/Zero_Trust'
            }
        });
    }

    openDashboard() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/Transaction_Dashboard'
            }
        });
    }

    openApproval() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/approvalPage'
            }
        });
    }
}