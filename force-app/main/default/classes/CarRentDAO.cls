public with sharing class CarRentDAO {
    public CarRentDAO() {

    }
    
    public List<Deal__c> getWonDeals(DateTime startDate, DateTime endDate) {
        List<Deal__c> deals = [
            SELECT Name, StartDate__c, EndDate__c 
            FROM Deal__c 
            WHERE StartDate__c = :startDate
            AND EndDate__c = :endDate
            AND Status__c = 'Won'
            LIMIT 100
        ];
        return deals;
    }
    
    public Map<Id, Integer> getWonDealsBySalesRepIds(Set<ID> ids) {
        Map<Id, Integer> salesRepDealStatusesCount = new Map<Id, Integer>();
        AggregateResult[] aggSalesRepDealStatusesCount = [
            SELECT Sales_Manager__c, COUNT(Id) recordCount
            FROM Deal__c 
            WHERE Sales_Manager__c 
            IN: ids
            AND  Status__c = 'Won'
            GROUP BY Sales_Manager__c
            LIMIT 100
        ];
        for(AggregateResult agg : aggSalesRepDealStatusesCount) {
            salesRepDealStatusesCount.put((Id)agg.get('Sales_Manager__c'), (Integer) (agg.get('recordCount'))); 
        } 
        return salesRepDealStatusesCount;
      }      
  
    public List<Car__c> getCarsAvailableForRent(Datetime rentStart, Datetime rentEnd) {
        List<Car__c> cars = new List<Car__c>();
        List<Deal__c> deals = [
            SELECT Id, Name, Car__c, StartDate__c,
                Car__r.Id, Car__r.Name, EndDate__c, Status__c
            FROM Deal__c 
            WHERE Status__c = 'Open' 
            AND StartDate__c >= :rentStart 
            AND StartDate__c <= :rentEnd
            AND(EndDate__c >= :rentStart
                OR EndDate__c <= :rentEnd)
        ];
       
        for(Deal__c deal :deals){
            Car__c  car = new Car__c();
            car.Id = deal.Car__r.Id;
            car.Name = deal.Car__r.Name;
            cars.add(car);
        }
        return cars;      
    }
    
    public Map<Id, Integer> getCarRentStatistic() {
        Map<Id, Integer> carWonStatusesCount = new Map<Id, Integer>();
        AggregateResult[] carWonStatusesCountAggr = [
            SELECT Car__c, COUNT(Id) recordCount 
            FROM Deal__c
            WHERE Status__c = 'Won'
            GROUP BY Car__c
            LIMIT 100
        ];
        for(AggregateResult agg : carWonStatusesCountAggr) {
            carWonStatusesCount.put((Id)agg.get('Car__c'), (Integer) (agg.get('recordCount')));
        }        
        return carWonStatusesCount;        
    }
    
    public Sales_Manager__c getTopRatedSalesRepOfYear(Integer year) {
        AggregateResult[] carWonStatusesCountAggr = [
            SELECT Sales_Manager__c, count(Id) recordCount
            FROM Deal__c 
            WHERE CALENDAR_YEAR(EndDate__c) = :year
            AND Status__c = 'Won' 
            GROUP BY Sales_Manager__c, CALENDAR_YEAR(EndDate__c)
            ORDER BY count(Id)
            DESC LIMIT 1
        ];
        return carWonStatusesCountAggr.size()>0 ? 
            new Sales_Manager__c(Id = (Id) carWonStatusesCountAggr.get(0).get('Sales_Manager__c')):
            null;       
    }
}
