public with sharing class SalesManagerController {
    public List<Deal__c> dealsList{get;set;}
    private Deal__c deal;   
    private ApexPages.StandardSetController stdController{get;set;}
    private CarRentDAO carRentDAO{get;set;}
  
    public SalesManagerController(ApexPages.StandardController stdController){
        this.deal=(Deal__c)stdController.getRecord();
  
    }
     
    public void getDeals(){
        dealsList= [SELECT  Name, StartDate__c, EndDate__c, Status__c, Car__c, Sales_Manager__c
            FROM Deal__c
            WHERE Status__c ='Open'];
       }
    
  }
