@isTest
private class BillingCalloutServiceTest {
    //Implement mock callout tests here
    @TestSetup
    private static void setup() {
        Opportunity opp = new Opportunity(Name='Test Opp', CloseDate=System.today(), StageName='Prospecting');
        insert opp;
        
        Project__c p = new Project__c(Name='Test Project', Opportunity__c=opp.Id, ProjectRef__c='Proj11', Billable_Amount__c=200000, Status__c='Running');
        insert p;    
        
        ServiceCredentials__c sc = new ServiceCredentials__c();
        sc.Name = 'BillingServiceCredential';
        sc.Username__c = 'Username';
        sc.Password__c = 'Password';
        insert sc;
    }
    
    @isTest
    private static void sucessTest() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        List<Project__c> prjList = [SELECT Status__c FROM Project__c WHERE ProjectRef__c='Proj11'];

        Test.startTest();
        prjList[0].Status__c = 'Billable';
        update prjList;
        Test.stopTest();
    }
    
    @isTest
    private static void failureTest() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        List<Project__c> prjList = [SELECT Status__c FROM Project__c WHERE ProjectRef__c='Proj11'];

        Test.startTest();
        prjList[0].Status__c = 'Running';
        update prjList;
        Test.stopTest();
    }
}