public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    
    // static String endPoint = 'https://sb-integration-pms-2.herokuapp.com/projects';
    
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> Ids) {
        List<Opportunity> oppList = [SELECT Id, Name, AccountId, CloseDate, Amount FROM Opportunity WHERE ID IN :Ids];
        ServiceTokens__c mc = ServiceTokens__c.getValues('ProjectServiceToken');
        String token = mc.Token__c;
        // ServiceCredentials__c nm = ServiceCredentials__c.getValues('BillingServiceCredential');
        // String userName = nm.Username__c;
        // String passWord = nm.Password__c;
        System.enqueueJob(new QueueablePMSCall(oppList,token));
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private List<Opportunity> oppList;
        private String token;
        private String endPoint;
        // private String userName;
        // private String passWord;
        
        public QueueablePMSCall(List<Opportunity> opp, String tkn){
            this.oppList = opp;
            this.token = tkn;
            // this.endPoint = ep;
            // this.userName = user;
            // this.password = pass;
        }
        
        public void execute(QueueableContext context) {
            // awesome code here
            for(Opportunity opp :oppList) {
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://sb-integration-pms-2.herokuapp.com/projects');
                request.setEndpoint('callout:ProjectService/');
                request.setMethod('POST');
                request.setHeader('token', token);
                // request.setHeader('username', userName);
                // request.setHeader('password', passWord);
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody('{"opportunityId": ' + opp.Id + ',' +
                                + '"opportunityName": ' + opp.Name + ',' +
                                + '"accountName": '+ opp.AccountId + ',' +
                                + '"closeDate": ' + opp.CloseDate + ',' +
                                + '"amount": ' + opp.Amount + '}');
                HttpResponse response = http.send(request);
                if(response.getStatusCode() == 201) {
                    opp.StageName = 'Submitted Project';
                } else {
                    opp.StageName = 'Resubmit Project';
                }
            }
            update oppList;
        }
    }
}