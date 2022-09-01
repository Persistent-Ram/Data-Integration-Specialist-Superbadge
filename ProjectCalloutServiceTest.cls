@isTest
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here
    
    @TestSetup
    private static void setup() {
        Opportunity opp1 = new Opportunity(Name='Test from Apex 1', CloseDate=System.today(), StageName='Prospecting', Type='New Project', Amount=150000);
        insert opp1;
        
        Opportunity opp2 = new Opportunity(Name='Test from Apex 2', CloseDate=System.today(), StageName='Prospecting', Type='New Project', Amount=200000);
        insert opp2;        
        
        //ServiceTokens__c mc = ServiceTokens__c.getValues('ProjectServiceToken');
        //String token = mc.Token__c;
        
        ServiceTokens__c mc = new ServiceTokens__c();
        mc.Name = 'ProjectServiceToken';
        mc.Token__c = 'kdsfodsjfposjfpsoj';
        insert mc;
    }
    
    @isTest
    private static void testSucess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        List<Id> Ids = new List<Id>();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Type='New Project' AND Name = 'Test from Apex 1' LIMIT 1];  
        opp.StageName = 'Closed Won';
        Ids.add(opp.Id);
        update opp;
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(ids);
        Test.stopTest();
        
        String actual = 'Submitted Project';
        Opportunity o = [SELECT StageName FROM Opportunity WHERE Id IN :Ids LIMIT 1];
        System.assertEquals(o.StageName, actual);
    }
    
    @isTest
    private static void testFailure() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        List<Id> Ids = new List<Id>();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Type='New Project' AND Name = 'Test from Apex 2' LIMIT 1];  
        opp.StageName = 'Closed Won';
        update opp;
        Ids.add(opp.Id);
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(ids);
        Test.stopTest();
        
        String actual = 'Resubmit Project';
        Opportunity o = [SELECT StageName FROM Opportunity WHERE Id IN :Ids LIMIT 1];
        System.assertEquals(o.StageName, actual);
    }
}