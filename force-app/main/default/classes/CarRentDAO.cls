public with sharing class CarRentDAO {
    public CarRentDAO() {

    }
    
    public List<Deal__c>getWonDeals(DateTime startDate, DateTime endDate){
        List<Deal__c> deals = [
            SELECT Name, StartDate__c, EndDate__c 
            FROM Deal__c 
            WHERE StartDate__c = : startDate
            AND EndDate__c = : endDate
            AND Status__c = 'Won'
            LIMIT 100
        ];
        return deals;
    }
    
    public Map<Id, Integer> getWonDealsBySalesRepIds(Set<ID>ids){
        Map<Id, Integer> salesRepDealStatusesCount= new Map<Id, Integer>();
        AggregateResult[] aggSalesRepDealStatusesCount = [
            SELECT Sales_Manager__c, COUNT(Id) recordCount
            FROM Deal__c 
            WHERE Status__c 
            IN:ids
            AND  Status__c = 'Won'
            GROUP BY Sales_Manager__c
            LIMIT 100
        ];
        for(AggregateResult agg : aggSalesRepDealStatusesCount){
            salesRepDealStatusesCount.put((Id)agg.get('Sales_Manager__c'), (Integer) (agg.get('recordCount'))); 
            } 
        return salesRepDealStatusesCount;
      }      
    
    public List<Car__c> getCarsAvailableForRent(Date rentStart, Date rentEnd){
        // todo Inner query  
        List<Car__c> cars = [
            SELECT Id, Name,
                (SELECT Id, StartDate__c, EndDate__c 
                FROM Deals__r 
                WHERE StartDate__c = : rentStart
                AND EndDate__c = : rentEnd
                AND Status__c='Open')
            FROM Car__c
        ];
     // List<Deal__c> deals =[SELECT Id , StartDate__c, EndDate__c, Car__r.Id,Car_r.Name FROM Deal__c 
       //                       WHERE StartDate__c = : rentStart AND EndDate__c = : rentEnd AND Status__c='Open'];
      //  Set<Id> carsIds = new Set<Id>();
      //    for(Deal__c deal :deals){
      //        //redo
      //        carsIds.add(deal.Car__c);
      //    }
      //  List<Car__c> cars = [SELECT Id,Name from Car__c where Id in: carsIds];
       return cars;
      
    }
    
    public Map<Id, Integer> getCarRentStatistic(){
        Map<Id, Integer> carWonStatusesCount= new Map<Id, Integer>();
        AggregateResult[] carWonStatusesCountAggr = [
            SELECT Car__c, COUNT(Id) recordCount 
            FROM Deal__c
            WHERE Status__c = 'Won'
            GROUP BY Car__c
            LIMIT 100
        ];
        for(AggregateResult agg : carWonStatusesCountAggr){
            carWonStatusesCount.put((Id)agg.get('Car__c'), (Integer) (agg.get('recordCount')));
           } 
        System.debug(carWonStatusesCount);
        return carWonStatusesCount;        
    }
    
    public Sales_Manager__c getTopRatedSalesRepOfYear(Integer year){
        String convertToStr = String.valueOf(year);
        Datetime inputYear= (DateTime)JSON.deserialize('"' + convertToStr + '"', DateTime.class);
        inputYear.year();
        Sales_Manager__c salesMan =  new  Sales_Manager__c();
        List<Id> salesIds= new List<Id>();
        AggregateResult[] carWonStatusesCountAggr = [
            SELECT Sales_Manager__c, count(Id) recordCount
            FROM Deal__c 
            WHERE CALENDAR_YEAR(EndDate__c) =: year
            AND Status__c = 'Won' 
            GROUP BY Sales_Manager__c, CALENDAR_YEAR(EndDate__c)
            ORDER BY count(Id)
            DESC LIMIT 1
        ];
        for(AggregateResult agg : carWonStatusesCountAggr){
              salesIds.add((Id)agg.get('Sales_Manager__c'));
           } 
         if(salesIds.size() > 0){
           salesMan.Id = salesIds.get(0);
           System.debug(salesMan);
            
        }
        return salesMan;
    }
}
