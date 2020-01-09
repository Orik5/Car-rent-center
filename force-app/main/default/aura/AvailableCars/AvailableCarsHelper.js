({
    showToast: function(component, event, helper) {
        var showToast = $A.get("e.force:showToast");
        showToast.setParams({
        'title' : 'Custom Toast!',
        'message' : 'The event has fired sucessfully.'
        });
        showToast.fire();
    },


    getCars : function(component,event,helper) {
        component.set('v.columns', [
            {label: 'Car Name', fieldName: 'Name', type: 'text'},
            {label: 'Model', fieldName: 'Model__c', type: 'text'},          
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Is valid for rent', fieldName: 'IsValidForRent__c', type: 'boolean'}           
            ]);
        var action = component.get("c.getAvailableCars");
            
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cars", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message : 'Available cars are found',
                    type: 'success'                    
                });
                toastEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                errors[0].message);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    'title': "Error",
                                    'message':  "there was problem with cars finding. Please write to administrator",
                                    'type': "ERROR" ,getError
                                     // messageTemplate: 'errors[0].message'                                      
                                  });
                                toastEvent.fire();                                 
                    }
                } 
            }
        });
        $A.enqueueAction(action);

    }
})
