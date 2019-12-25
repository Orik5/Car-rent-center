public with sharing class SalesManagerController {
    
    public List<Deal__c> dealsList{get;set;}
    private Deal__c deal;
    private Sales_Manager__c sales{get;set;}
    private Car__c car;   
    private ApexPages.StandardSetController stdController{get;set;}
    private CarRentDAO carRentDAO{get;set;}
    public DateTime startDate{get;set;}
    public DateTime endDate{get;set;}
    public Set<ID> salesIds{get;set;}
    public List<Sales_Manager__c> salesList{get;set;}
    public Map<Id,Integer>wonDealsBySalesRepIds{get;set;}
    public Integer year{get;set;}
  
  public SalesManagerController() {
       DateTime startDate;
       DateTime endDate; 
       Integer year; 
       Sales_Manager__c sales;
       Set<ID> salesIds;

  }
    public SalesManagerController(ApexPages.StandardController stdController) {
        this.deal = (Deal__c)stdController.getRecord();
       
        DateTime startDate;
        DateTime endDate;  
        Integer year;
        Set<ID> salesIds;
       }
     
    public void getDeals() {        
        dealsList = [
            SELECT  Name, StartDate__c, EndDate__c, Status__c, Car__c, Sales_Manager__c, Sales_Manager__r.Name,
                    Sales_Manager__r.Id, Sales_Manager__r.Email__c, Sales_Manager__r.BirthDate__c,
                    Car__r.Id, Car__r.Name, Car__r.IsValidForRent__c, Car__r.Model__c, Car__r.Photo__c, Car__r.Type__c
            FROM Deal__c
            WHERE Status__c = 'Open'
        ];
    }
   
    public List<Deal__c> getWonDeals() {
        return carRentDao.getWonDeals(startDate, endDate);
    }

    public void getWonDealsBySalesRepIds() {
        Set<Id> salesIds = new Set<ID>();
        salesList = [
            SELECT ID ,Name, Email__c, BirthDate__c 
            FROM Sales_Manager__c
        ];
     
        for(Sales_Manager__c saleManager:salesList) {             
            salesIds.add(saleManager.Id);
        }
        CarRentDAO carRentDao = new CarRentDAO();
        carRentDao.getWonDealsBySalesRepIds(salesIds);
    }
    public Sales_Manager__c getTopRatedSalesRepOfYear() {      
       return carRentDao.getTopRatedSalesRepOfYear(year);

    }
    public Map<Id, Integer> getCarRentStatistic() {
        return CarRentDao.getCarRentStatistic();
    }
  }
