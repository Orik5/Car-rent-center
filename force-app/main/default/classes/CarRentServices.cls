public with sharing class CarRentServices {
    
    public CarRentServices() {

    }
  
    public Date dateTimeToDateConverter(Datetime inputDatetime) {
        String stringDate = String.valueOf(inputDatetime.Date());
        Date outputDate = Date.valueOf(stringDate);
        return outputDate;
    }
    
    public Deal__c setEndDate(Deal__c deal) {
        deal.EndDate__c = Datetime.now();
        return deal;
    }

    public Deal__c filterFinished(Deal__c deal) {
        CarRentServices carRentServices = new CarRentServices();       
            if(deal.Status__c != 'Open') {
                carRentServices.setEndDate(deal);           
            }             
        return deal;
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
    
    public Database.SaveResult updateDeal(Id dealId, Map<SObjectField, Object> fieldName2Value) {
        List<String> sObjectFields = new List<String>();
        for(SObjectField fieldName : fieldName2Value.keySet()) {
            sObjectFields.add(''+fieldName);
        }        
        DescribeSObjectResult describeResult = Car__c.getSObjectType().getDescribe();
        String dealQuery = ' SELECT ' +  String.join(sObjectFields, ',' ) +  ' FROM ' + describeResult.getName() + ' WHERE ' + 'Id IN: carIds'+ ' LIMIT 1';
        List<Deal__c> records = Database.query( dealQuery );
        Deal__c deal = records.get(0);                  
        for(SObjectField fieldName : fieldName2Value.keySet()) {
            deal.put(fieldName, fieldName2Value.get(fieldName));
        }
        Database.SaveResult saveResult = Database.update(deal);       
            if (saveResult.isSuccess()) {
                System.debug(records);
                System.debug('Old values is : '+ records);
                System.debug('Successfully updated deal. Deal ID: ' + saveResult.getId());
                } else {                    
                for(Database.Error err : saveResult.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Deal fields that affected this error: ' + err.getFields());
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
            AND Car__c =:carId
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
         List<Deal__c> deals = new List<Deal__c>([
				SELECT StartDate__c, EndDate__c, Status__c
   				FROM Deal__c
			]);
            
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
   // this is not how you s earch for duplicate
    public static void checkDublicateDeal(Deal__c deal, Deal__c newDeal) {
        String errorMessage = 'Please choose another sales manager or another car .You can\'t create two deals with the same sales manger and  the same car!';
        if((newDeal.Car__c == deal.Car__c) && (newDeal.Sales_Manager__c == deal.Sales_Manager__c)) {
            newDeal.addError(errorMessage);
        }
    }
}
