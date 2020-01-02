({
    helperMethod : function(component) {
        component.set('v.columns', [
            {label: 'Car Name', fieldName: 'Name', type: 'text'},
            {label: 'Model', fieldName: 'Model__c', type: 'text'},          
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Is valid for rent', fieldName: 'IsValidForRent__c', type: 'boolean'}           
            ]);
        var action = component.get("c.getAvailableCars");
        action.setParams({
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cars", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

    }
})
