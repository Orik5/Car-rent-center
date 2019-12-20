public with sharing class DateRange {
    final Datetime startDate, endDate;
    public DateRange(Datetime startDate, Datetime endDate) {
        this.startDate = startDate;
        this.endDate = endDate;      

    }
    public Integer hashCode() { return 1;
    }
    public Boolean equals(Object instance) {
        DateRange that = (DateRange)instance;
        return startDate <= that.endDate && endDate >= that.startDate;
    }
    public static DateRange factory(Deal__c deal)  {
        return new DateRange(deal.StartDate__c, deal.EndDate__c);
   }
}
