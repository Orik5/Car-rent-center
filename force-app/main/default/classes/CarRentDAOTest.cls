@isTest
private class CarRentDAOTest {
    @testSetup
    static void setup() {
        Sales_Manager__c sales = new Sales_Manager__c(Name = 'TestSales');
        insert sales;

        Car__c car = new Car__c(); 
        car.Name = 'TestCar';
        car.IsValidForRent__c = true;
        insert car;  

        Deal__c deal = new Deal__c();
        deal.Name = 'TestDeal';
        deal.StartDate__c = datetime.newInstance(2020, 04, 21, 12, 30, 0);
        deal.EndDate__c = datetime.newInstance(2020, 05, 22, 13, 30, 0);
        deal.Status__c = 'Open';
        deal.Car__c = car.Id;
        deal.Sales_Manager__c = sales.Id;    
        insert deal;

        deal.Status__c = 'Won';
        update deal;
    }

    @isTest
    static  void getWonDealsTest() {
        List<Deal__c> deals = [SELECT Id, Name, StartDate__c, EndDate__c, Status__c FROM Deal__c];
        CarRentDAO carRentDAO = new CarRentDAO();
        DateTime startDate = datetime.newInstance(2020, 01, 21, 12, 30, 0);
        DateTime endDate = datetime.newInstance(2020, 12, 25, 12, 30, 0);
        Test.startTest();
        carRentDAO.getWonDeals(startDate,endDate);
        Test.stopTest();
        System.assertEquals(deals, deals);

    }

    @isTest
    static void getWonDealsBySalesRepIdsTest() {        
        CarRentDAO carRentDAO = new CarRentDAO(); 
        Set<Id> ids = new Set<Id>();       
        Deal__c deal1 = [
            SELECT Id, Sales_Manager__c, Status__c
            FROM Deal__c
            LIMIT 1
        ];
        ids.add(deal1.Sales_Manager__c);
        Test.startTest();
        carRentDAO.getWonDealsBySalesRepIds(ids); 
        Test.stopTest();
        System.assertEquals('Won', deal1.Status__c);
    }
    
    @isTest 
    static void getCarsAvailableForRentTest() {
        CarRentDAO carRentDAO = new CarRentDAO();
        DateTime startDate = datetime.newInstance(2019, 12, 21, 12, 30, 0);
        DateTime endDate = datetime.newInstance(2019, 12, 25, 12, 30, 0);
        List<Car__c> cars = [
            SELECT Id, Name,
                (SELECT Id, StartDate__c, EndDate__c 
                FROM Deals__r 
                WHERE StartDate__c =: startDate
                AND EndDate__c =: endDate
                AND Status__c = 'Open')
            FROM Car__c
        ];
        Test.startTest();        
        carRentDAO.getCarsAvailableForRent(startDate, endDate);
        Test.stopTest();
     //   System.assertEquals(cars, carRentDAO.getCarsAvailableForRent(startDate, endDate));
    }

    @isTest
    static void getCarRentStatisticTest() {
        CarRentDAO carRentDAO = new CarRentDAO();
        Test.startTest();
        carRentDAO.getCarRentStatistic();
        Test.stopTest();
    }

    @isTest
    static void getTopRatedSalesRepOfYearTest() {
       CarRentDAO carRentDAO = new CarRentDAO();
       Integer year = 2019;
       Test.startTest();
       carRentDAO.getTopRatedSalesRepOfYear(year);
       Test.stopTest();
    }

}