@isTest
private class SalesManagerControllerTest {
    
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
    private static void openDealsTest(){
        Test.startTest();
        PageReference pageRef = Page.OpenDeals;
        Test.setCurrentPage(pageRef);
        List<Deal__c> deals = [
            SELECT  Name, Status__c             
            FROM Deal__c
            WHERE Status__c = 'Open'
        ];
       // pageRef.getParameters().put(deals);
        SalesManagerController salesManagerController = new SalesManagerController();         
        salesManagerController.getDeals();
        Test.stopTest();
    }
}
