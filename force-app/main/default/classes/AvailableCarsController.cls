public with sharing class AvailableCarsController {
           
    @AuraEnabled
    public static List<Car__c> getAvailableCars() {
        List<Car__c> cars = [
            SELECT Id, Name, IsValidForRent__c, Model__c,
                Type__c, Photo__c
            FROM Car__c
            WHERE IsValidForRent__c = true
        ];
        return cars;
    }
}
