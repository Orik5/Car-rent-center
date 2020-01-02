({
    helperMethod : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Car Name', fieldName: 'Name', type: 'text'},
                {label: 'IsValidForRent', fieldName: 'IsValidForRent__c', type: 'boolean'}
                
            ]);
        var action = component.get("c.getAvailableCars");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cars", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    }
})