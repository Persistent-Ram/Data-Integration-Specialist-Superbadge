@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    
    @TestSetup
    static void setup() {
        Opportunity opp = new Opportunity(Name='Test Opportunity', DeliveryInstallationStatus__c='In progress', CloseDate=System.today()+20, StageName='Submitted Project');
        insert opp;
        Project__c prj1 = new Project__c(ProjectRef__c = 'ProjectRef24', Name = 'ProjectName', Opportunity__c = opp.Id, Start_Date__c = System.today(), End_Date__c = System.today()+10, Billable_Amount__c = 1000, Status__c = 'Running');
        insert prj1;
        //Project__c prj2 = new Project__c(ProjectRef__c = 'ProjectRef21', Opportunity__c = opp.Id, Start_Date__c = System.today(), End_Date__c = System.today()+10, Billable_Amount__c = 1000, Status__c = 'Running');
        //insert prj2;
    }
    
    @isTest 
    static void testCreateProjectSucess() {
		Project__c prjt = [SELECT Id, ProjectRef__c, Name, Opportunity__c, Start_Date__c, End_Date__c, Billable_Amount__c, Status__c FROM Project__c LIMIT 1]; 
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(1,[SELECT count() FROM Opportunity]);
        String res = ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', String.valueOf(opp.Id),  Date.today(), Date.today(), 1000, 'Running');
        System.assertEquals(res, 'OK');
        Test.stopTest();
    }
    
    /*@isTest 
    static void testCreateProjectFailure() {
		Project__c prjt = [SELECT Id, ProjectRef__c, Name, Opportunity__c, Start_Date__c, End_Date__c, Billable_Amount__c, Status__c FROM Project__c WHERE ProjectRef__c = 'ProjectRef21']; 
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(0,[SELECT count() FROM Opportunity]);
        String res = ProjectRESTService.postProjectData('ProjectRef21', 'ProjectName', String.valueOf(opp.Id),  Date.today(), Date.today(), 1000, 'Running');
        System.assertEquals(res, 'OK');
        Test.stopTest();
    }*/
}