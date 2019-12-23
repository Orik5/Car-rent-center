public with sharing class SalesManagerController {
    public List<Deal__c> dealsList{get;set;}
    private Deal__c deal;   
    private ApexPages.StandardSetController stdController{get;set;}
    private CarRentDAO carRentDAO{get;set;}
  
    public SalesManagerController(ApexPages.StandardController stdController){
        this.deal=(Deal__c)stdController.getRecord();
  
    }
     
  public void getDeals(){
        dealsList= [SELECT  Name, StartDate__c, EndDate__c, Status__c, Car__c, Sales_Manager__c,Sales_Manager__r.Name,
                    Sales_Manager__r.Id,Sales_Manager__r.Email__c,Sales_Manager__r.BirthDate__c,
                    Car__r.Id,Car__r.Name,Car__r.IsValidForRent__c,Car__r.Model__c,Car__r.Photo__c,Car__r.Type__c
            FROM Deal__c
            WHERE Status__c ='Open'];
       }
    
  }
