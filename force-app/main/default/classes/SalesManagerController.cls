public with sharing class SalesManagerController {

    public List<Deal__c> dealsList{get;set;}
    private Deal__c deal;
    private Sales_Manager__c sales{get;set;}
    private Car__c car;   
    private ApexPages.StandardSetController stdController{get;set;}
    public DateTime startDate{get;set;}
    public DateTime endDate{get;set;}
    public Set<ID> salesIds{get;set;}
    public List<Sales_Manager__c> salesList{get;set;}

    public SalesManagerController() {
        DateTime startDate;
        DateTime endDate; 
        Sales_Manager__c sales;
        Set<ID> salesIds;       
    }

    public SalesManagerController(ApexPages.StandardController stdController) {
        this.deal = (Deal__c)stdController.getRecord();       
        DateTime startDate;
        DateTime endDate; 
        Set<ID> salesIds;
        dealsList = [
            SELECT  Name, StartDate__c, EndDate__c, Status__c,
                Car__c, Sales_Manager__c, Sales_Manager__r.Name,             
                Sales_Manager__r.Id, Sales_Manager__r.Email__c,
                Sales_Manager__r.BirthDate__c, Car__r.Id, Car__r.Name,
                Car__r.IsValidForRent__c, Car__r.Model__c, Car__r.Photo__c,
                Car__r.Type__c
            FROM Deal__c
            WHERE Status__c = 'Open'
        ];            
    }  
}
