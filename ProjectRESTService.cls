@RestResource(urlMapping='/Project__c/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, 
                                         String ProjectName,
                                         String OpportunityId,
                                         Date StartDate,
                                         Date EndDate,
                                         Double Amount,
                                         String Status) {
                                             
                                             Project__c thisProject = new Project__c(
                                                 ProjectRef__c = ProjectRef,
                                                 Name = ProjectName,
                                                 Opportunity__c = OpportunityId,
                                                 Start_Date__c = StartDate,
                                                 End_Date__c = EndDate,
                                                 Billable_Amount__c = Amount,
                                                 Status__c = Status);
                                             
                                             try {
                                                 insert thisProject;
                                                 
                                                 Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :thisProject.Opportunity__c LIMIT 1];
                                                 opp.DeliveryInstallationStatus__c = 'In progress';
                                                 update opp;
                                                 
                                                 Savepoint sp = Database.setSavepoint();
                                                 Project__c prj = new Project__c(Name=opp.Name+' Project', Opportunity__c=opp.Id);
                                                 insert prj;
                                                 Database.rollback(sp);
                                                 
                                                 return 'OK';    
                                             } 
                                             catch(Exception e) {
                                                 return e.getMessage();
                                             }   
                                         }
}