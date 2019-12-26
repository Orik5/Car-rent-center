@isTest
private class CarRentServiceTest {

    @testSetup
    static void setup() {
        Sales_Manager__c sales = new Sales_Manager__c(Name = 'TestSales1');
        insert sales;

        Car__c car = new Car__c(); 
        car.Name = 'TestCar1';
        car.IsValidForRent__c = true;
        insert car;    

        Deal__c deal1 = new Deal__c();
        deal1.Name = 'TestDeal2';
        deal1.Status__c = 'Open';
        deal1.Car__c = car.Id;
        deal1.Sales_Manager__c = sales.Id;    
        Deal__c deal2 = new Deal__c();
        deal2.Name = 'TestDea2';
        deal2.Status__c = 'Open';
        deal2.Car__c = car.Id;
        deal2.Sales_Manager__c = sales.Id;
        List<Deal__c> deals = new List<Deal__c>();
        deals.add(deal1); 
        deals.add(deal2); 
        insert deals;
    }

     @isTest
    static void preventDublicateDateRangeTest(){
        Deal__c deal1;
        Deal__c deal2;
        Deal__c deal = [
            SELECT  Name, StartDate__c, EndDate__c, Status__c
            FROM Deal__c
            LIMIT 1
        ];       
        deal1 = deal;
        deal2 = deal;              
        System.Test.startTest();
        CarRentServices.checkDealDatetime(deal1, deal2);      
        System.Test.stopTest();
        System.assertEquals(deal1, deal2);
        System.assertNotEquals(deal1, deal2, 'Dublicates are found!');      
    } 

    @isTest
    static void preventDublicateDealsTest() {
        List<Deal__c> deals = [
            SELECT  Name, Car__c, Sales_Manager__c
            FROM Deal__c
        ];
        Deal__c deal1 = deals.get(0);
        Deal__c deal2 = deals.get(1);
        System.Test.startTest();
        CarRentServices.checkDublicateDeal(deal1, deal2);        
        System.Test.stopTest();
        System.assertNotEquals(deal1, deal2, 'Dublicates are found!');
        System.assertEquals(deal1, deal2, 'Dublicates are found!');       
    }
}
