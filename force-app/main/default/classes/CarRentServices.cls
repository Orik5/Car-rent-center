public with sharing class CarRentServices {
    
    public CarRentServices() {

    }
  
    public Date dateTimeToDateConverter(Datetime inputDatetime) {
        String stringDate = String.valueOf(inputDatetime.Date());
        Date outputDate = Date.valueOf(stringDate);
        return outputDate;
    }

    public static void setEndDate(List<Deal__c> endDateDeals) {
        for(Deal__c deal :endDateDeals) {
            deal.EndDate__c = Datetime.now();
        }
    }
    
    public List<Deal__c> filterFinished(List<Deal__c> deals) {
        List<Deal__c> deals1 = [
            SELECT id, Name, Status__c
            FROM Deal__c
        ];
        for (Deal__c deal : deals1){
            if(deal.Status__c != 'Open') {
                setEndDate(deals);
            }
        }
        return deals;
    }
 
    public Database.SaveResult createSalesManager(String name, Date birthday) {
        Sales_Manager__c  salesManager = new Sales_Manager__c (Name = name, BirthDate__c = birthday);
        Database.SaveResult saveResult = Database.insert(salesManager);
        if (saveResult.isSuccess()) {
            System.debug('Successfully inserted sales manager. Sales_Manager__c ID: ' + saveResult.getId());            
        } else {                   
            for(Database.Error err : saveResult.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Sales manager fields that affected this error: ' + err.getFields());
            }
        }
        return saveResult;             
    }

    public Database.SaveResult createNewDeal(String name, DateTime startDate, DateTime endDate, Id salesRepId, Id carId) {
        Deal__c deal = new Deal__c( Name = name, StartDate__c = startDate,
        EndDate__c = endDate, Sales_Manager__c = salesRepId, Car__c = carId);
        Database.SaveResult saveResult = Database.insert(deal);
        if (saveResult.isSuccess()) {
            System.debug('Successfully inserted deal. Deal ID: ' + saveResult.getId());            
        } else {                   
            for(Database.Error err : saveResult.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Deal fields that affected this error: ' + err.getFields());
            }
        }
        return saveResult;
    }
     
    public  Database.SaveResult updateDeal(Id dealId, Map<SObjectField, Object> fieldName2Value) {
        String inputDealIdQuery = 'SELECT Car__c, Car__r.Name, Car__r.IsValidForRent__c, Car__r.Model__c, Car__r.Type__c  FROM Deal__c  WHERE ID =: dealId';
        List<Deal__c> deals = Database.query(inputDealIdQuery);
        Set<Id> carSetIds = new Set<Id>();
        for(Deal__c carId : deals) {
            carSetIds.add(carId.Car__c);
        }
        Car__c car = [
            SELECT Id, Name, IsValidForRent__c, 
                Model__c, Type__c 
            FROM Car__c
            WHERE Id IN: carSetIds  
        ];    

    Map<String, Object> oldFieldsToValue = car.getPopulatedFieldsAsMap();    
    for (String fieldName : oldFieldsToValue.keySet()) {
    System.debug('field name is ' + fieldName + ', value is ' + 
        oldFieldsToValue.get(fieldName));
    }
    System.debug(oldFieldsToValue);
    // //Logic for geting sObjectfield  name  and  add to Set 
    // Set<SObjectField> sObjectfields = new Set<SObjectField>();  
    // SObjectType objectName = Schema.getGlobalDescribe().get('Deal__c');
    // Map<String, Schema.SObjectField> fields = objectName.getDescribe().fields.getMap();
        
    // for(Schema.SObjectField fieldApiName:fields.values()) {
    //         sObjectfields.add(fieldApiName);
    // }
    for(SObjectField fieldName : fieldName2Value.keySet()) {
            car.put(fieldName, fieldName2Value.get(fieldName));
    }        
    Database.SaveResult saveResult = Database.update(car);      
        if (saveResult.isSuccess()) {
            System.debug('Old values is : '+ oldFieldsToValue);
            System.debug('Successfully updated car. Car ID: ' + saveResult.getId());
            } else {                   
            for(Database.Error err : saveResult.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Car fields that affected this error: ' + err.getFields());
              }
            }
        return saveResult;
    }
  
    public List<Database.SaveResult> deactivateCar(Id carId) {
        Integer countDeals;
        List<Deal__c> deals = [
            SELECT Id, Name, Status__c, Car__c, 
                Car__r.IsValidForRent__c
            FROM Deal__c
            WHERE Status__c = 'Open' 
            AND Car__c =: carId
        ];
      
        for(Deal__c deal : deals) { 
            deal.Status__c = 'Lost';
            deal.Car__r.IsValidForRent__c = false;    
            countDeals = deals.size();               
        }                          
       
        Database.SaveResult[] saveResultList = Database.update(deals);
        for(Database.SaveResult saveResult : saveResultList) {
            if (saveResult.isSuccess()) {
            System.debug('Successfully updated deal with car. Car ID: ' + saveResult.getId());      
            } else {                   
                for(Database.Error err : saveResult.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Deal fields that affected this error: ' + err.getFields());
                }
            }
        }
        System.debug('Count of updated deals: ' + countDeals);
        return saveResultList;
    } 
       
    public static void checkDealDatetime(Deal__c deal, Deal__c newDeal) {
        String errorMessage = 'Please choose another datetime for deal, in this period already exist deal.You can\'t create two deals on the same period!';
        if((newDeal.Status__c == 'Won' && deal.Status__c == 'Won') || (newDeal.Status__c == 'Open' && deal.Status__c == 'Won')) {
            if((newDeal.EndDate__c <= deal.StartDate__c && newDeal.EndDate__c >= deal.EndDate__c) ||
                (newDeal.StartDate__c <= deal.StartDate__c && newDeal.EndDate__c >= deal.EndDate__c) ||
                (newDeal.StartDate__c <= deal.StartDate__c && newDeal.StartDate__c >= deal.EndDate__c) ||
                (newDeal.StartDate__c > deal.EndDate__c && newDeal.EndDate__c < deal.EndDate__c )) {
                newDeal.addError(errorMessage);
           	}
        }
    }
    public static void changeDatetimeToNow(Deal__c deal) {
        if(deal.Status__c != 'Open') {
            deal.EndDate__c = Datetime.now();
        }
    }
    //There 2 Deals with same Sales Rep and Car. Update fields  of 1st Deal so it becames a duplicate of 2d Deal. Validate error.
   // this is not how you search for duplicate
    public static void checkDublicateDeal(Deal__c deal, Deal__c newDeal) {
        String errorMessage = 'Please choose another sales manager or another car .You can\'t create two deals with the same sales manger and  the same car!';
        if((newDeal.Car__c == deal.Car__c) && (newDeal.Sales_Manager__c == deal.Sales_Manager__c)) {
            newDeal.addError(errorMessage);
        }
    }
}
