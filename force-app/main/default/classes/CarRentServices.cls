public with sharing class CarRentServices {
    
    public CarRentServices() {

    }

    public static void setEndDate(List<Deal__c> endDateDeals){
        for(Deal__c deal :endDateDeals){
            deal.EndDate__c = Datetime.now();
          }
    }
    //done
    public List<Deal__c> filterFinished(List<Deal__c> deals){
      List<Deal__c> deals1 = [SELECT id,Name,Status__c FROM Deal__c];
      for (Deal__c deal :deals1){
          if(deal.Status__c != 'Lost'){
              deal.EndDate__c = Datetime.now();
               //setEndDate(deals1);
             }
          }
          //update deals;
        return deals;
    }
    //redo
    public Sales_Manager__c createSalesManager(String name, String email){
        Sales_Manager__c  salesManager = new Sales_Manager__c (Name = name, Email__c = email);
        Database.SaveResult sr = Database.insert(salesManager);
       
        if (sr.isSuccess()) {
            System.debug('Successfully inserted sales manager. Sales_Manager__c ID: ' + sr.getId());            
      }
        else {                   
           for(Database.Error err : sr.getErrors()) {
              System.debug('The following error has occurred.');                    
              System.debug(err.getStatusCode() + ': ' + err.getMessage());
              System.debug('Sales manager fields that affected this error: ' + err.getFields());
          }
        }
        return salesManager;             
  }

    public Deal__c createNewDeal(String name ,DateTime startDate, DateTime endDate, Id salesRepId, Id carId){
        Deal__c deal = new Deal__c( Name = name, StartDate__c = startDate,
        EndDate__c=endDate,Sales_Manager__c = salesRepId, Car__c = carId);
        Database.SaveResult sr = Database.insert(deal);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted deal. Deal ID: ' + sr.getId());            
    }
        else {                   
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Deal fields that affected this error: ' + err.getFields());
          }
        }
        return deal;
    }
  
    public  Car__c updateDeal(Id dealId, Map<SObjectField, Object> fieldName2Value){
        List<Deal__c> deals = [SELECT Car__c,Car__r.Name,Car__r.IsValidForRent__c,Car__r.Model__c,Car__r.Type__c
                             FROM Deal__c WHERE ID =: dealId ];
     // if(!deals.isEmpty()){
     //   Deal__c deal = deals.get(0);
     //  deal.Car__r.Name;
     // }
        Set<Id> carSetIds = new Set<Id>();
        for(Deal__c carId: deals){
            carSetIds.add(carId.Car__c);
        }
        Car__c car = [
                   SELECT Id, Name, IsValidForRent__c, Model__c,Type__c
                   FROM Car__c
                   WHERE Id
                   IN:carSetIds 
        ];

        Map<SObjectField, Object> OldFieldNameValue = new  Map<SObjectField, Object>();
        OldFieldNameValue.put(Car__c.Id,car.Id);
        OldFieldNameValue.put(Car__c.Name,car.Name);
        OldFieldNameValue.put(Car__c.IsValidForRent__c,car.IsValidForRent__c);
        OldFieldNameValue.put(Car__c.Model__c,car.Model__c);
        OldFieldNameValue.put(Car__c.Type__c,car.Type__c);
        for(SObjectField fieldName : fieldName2Value.keySet()){
            car.put(fieldName, fieldName2Value.get(fieldName));
            }
          
        Database.SaveResult saveResult = Database.update(car);      
        if (saveResult.isSuccess()) {
            System.debug('Old values is : '+ OldFieldNameValue);
            System.debug('Successfully updated car. Car ID: ' + saveResult.getId());     
        }
        else {                   
            for(Database.Error err : saveResult.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Car fields that affected this error: ' + err.getFields());
              }
            }
        return car;
    }
  
    public Id deactivateCar(Id carId){
        Integer countDeals;
        Id singleCarId;
        Car__c car = [
            SELECT Id, IsValidForRent__c,
                (SELECT Id, Name, Status__c
                 FROM Deals__r
                 WHERE Status__c = 'Open')
            FROM Car__c
            WHERE Id =: carId
        ];
        singleCarId = car.Id;
        AggregateResult[] dealsOpenStatusesCountAggr = [
            SELECT count(Id) recordCount
            FROM Deal__c
            WHERE Car__c =: singleCarId
            ORDER BY count(Id)
        ];
        for(AggregateResult agg : dealsOpenStatusesCountAggr){
            countDeals= (Integer) (agg.get('recordCount'));
            } 
        
        for(Deal__c deal : car.Deals__r){
            deal.Status__c='Lost';
            car.IsValidForRent__c = false;             
          }
                           
        Database.SaveResult sr = Database.update(car);
           if (sr.isSuccess()) {
           System.debug('Successfully updated car. Car ID: ' + sr.getId());      
           System.debug('Count of updated deals: ' + countDeals);
          }
           else {                   
              for(Database.Error err : sr.getErrors()) {
              System.debug('The following error has occurred.');                    
              System.debug(err.getStatusCode() + ': ' + err.getMessage());
              System.debug('Deal fields that affected this error: ' + err.getFields());
          }
        }
        return car.Id;
   } 
}