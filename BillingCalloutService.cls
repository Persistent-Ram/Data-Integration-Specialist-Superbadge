public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(List<Id> Ids) {
        List<Project__c> prjList = [SELECT ProjectRef__c, Billable_Amount__c, Status__c FROM Project__c WHERE Id IN :Ids]; 
        for(Project__c p :prjList) {
            if(p.Status__c == 'Billable') {
                ServiceCredentials__c sc = ServiceCredentials__c.getValues('BillingServiceCredential');
                String userName = sc.Username__c;
                String passWord = sc.Password__c;
                
                BillingServiceProxy.project billPrj = new BillingServiceProxy.project();
                billPrj.username = userName;
                billPrj.password = passWord;
                billPrj.projectid = p.ProjectRef__c;
                billPrj.billAmount = p.Billable_Amount__c;
                
                BillingServiceProxy.InvoicesPortSoap11 inv = new BillingServiceProxy.InvoicesPortSoap11();
                inv.billProject(billPrj);
            }
        }
    }
}