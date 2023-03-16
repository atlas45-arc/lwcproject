public with sharing class MaintenanceRequestHelper extends TriggerHandler {
    public override void beforeUpdate() {
        Map<Id, Case> casesForUpdate = (Map<Id,Case>)trigger.newMap;
        List<Case> casesForCreation = new List<Case>();
        List<Equipment_Maintenance_Item__c> junctions= new List<Equipment_Maintenance_Item__c>();
        List<Product2> equipments= new List<Product2>();
        Set<Id> equipmentsSet = new Set<Id>();
        List<Equipment_Maintenance_Item__c> junctionsForInsert = new List<Equipment_Maintenance_Item__c>();
        List<Product2> equipmentForInsert = new List<Product2>();


        junctions= [SELECT Name,Equipment__c,Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN: casesForUpdate.keySet()];
        for(Equipment_Maintenance_Item__c emi : junctions){
            equipmentsSet.add(emi.Equipment__c);
        }
        System.debug('junctions: '+junctions);
        equipments = [
                    SELECT Name,Maintenance_Cycle__c,ProductCode,Cost__c,Current_Inventory__c,Lifespan_Months__c,Family
                    FROM Product2 
                    WHERE Id IN: equipmentsSet
                    ];
        for(Case caseff: casesForUpdate.values()){
            System.debug('caseffid: '+caseff.id);
            if(caseff.status=='Closed'&&((caseff.type == 'Repair'||caseff.type == 'Routine Maintenance'))){
                Case c = new Case();
                Decimal maintenance_Time=365;
                for(Product2 product :equipments){
                    if(maintenance_Time>product.Maintenance_Cycle__c){
                        Maintenance_Time=product.Maintenance_Cycle__c;
                    }                    }
                c.Date_Due__c=System.today();
                c.Date_Due__c=c.Date_Due__c.addDays(Integer.valueOf(Maintenance_Time));
                c.Status = 'New';
                c.Priority = 'Low';
                c.Origin = 'Web';
                c.Type = 'Routine Maintenance';
                c.Vehicle__c = caseff.Vehicle__c;
                c.Account =  caseff.Account;
                c.Contact =   caseff.Contact;
                casesForCreation.add(c);

                for(Product2 product: equipments){
                    Product2 productNew = new Product2();
                    productNew.Name= product.Name;
                    productNew.ProductCode= product.ProductCode;
                    productNew.Cost__c= product.Cost__c;
                    productNew.Current_Inventory__c= product.Current_Inventory__c;
                    productNew.Lifespan_Months__c= product.Lifespan_Months__c;
                    productNew.Maintenance_Cycle__c= product.Maintenance_Cycle__c;
                    productNew.Family= product.Family;  
                    productNew.Maintenance_Cycle__c=Maintenance_Time;
                    equipmentForInsert.add(productNew);


                    
                    Equipment_Maintenance_Item__c junction = new Equipment_Maintenance_Item__c();
                    junction.Equipment__c=productNew.id;
                    junction.Maintenance_Request__c=caseff.id;
                    junctionsForInsert.add(junction);
                    System.debug('junction: ' +junction);

            }
        }
        

        }



            insert equipmentForInsert;
            insert casesForCreation;
            System.debug('junctionsForInsert: '+junctionsForInsert);
            insert junctionsForInsert;
    }  
}

    