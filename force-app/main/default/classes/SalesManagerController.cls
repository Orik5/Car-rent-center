public with sharing class SalesManagerController {
   private Deal__c deal;
   private ApexPages.StandardSetController stdSetController{get;set;}
 private ApexPages.StandardSetController stdController{get;set;}
     public ApexPages.StandardSetController deals{
        get {
            //if(deals == null) {
                deals = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT  Name, StartDate__c, EndDate__c, Status__c, Car__c, Sales_Manager__c
           FROM Deal__c
           WHERE Status__c ='Open']));
           //  }
            return deals;
         }
        private set;
     }  
    // public SalesManagerController(ApexPages.StandardController stdController){
    //     this.stdController = stdController;
    //     this.deal = (Deal__c)stdController.getRecord();
    // }
    public SalesManagerController(ApexPages.StandardSetController stdController){
      //  this.deal=(Deal__c)controller.getRecord();
       this.stdController = stdSetController;
       stdController = new  ApexPages.StandardSetController(Database.getQueryLocator([
           SELECT  Name, StartDate__c, EndDate__c, Status__c, Car__c, Sales_Manager__c
           FROM Deal__c
           WHERE Status__c ='Open'
       ]));
    }
    
    public List<Deal__c> getDeals(){

        return (List<Deal__c>)deals.getRecords();
    }
    //  public String getGreeting() {
    //     return 'Hello ' + deal.Name + ' (' + deal.id + ')';
    // }
}
