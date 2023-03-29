public with sharing class WarehouseCalloutService implements Queueable {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    

    
    public static void execute (QueueableContext context){
        runWarehouseEquipmentSync();
    }

    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<Product2> equipmentForInsert = new List<Product2>();
        request.setMethod('GET');
        request.setEndpoint(WAREHOUSE_URL);

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(response.getBody());
            for (Object equi : jsonResponse){
                Map<String,Object> mapJson = (Map<String,Object>)equi;
                Product2 mapEqui = new Product2();
                mapEqui.Name = (String) mapJson.get('name');
               // mapEqui.Replacement_Part__c = (Boolean) mapJson.get('replacement');
                mapEqui.Replacement_Part__c = true;
                mapEqui.Maintenance_Cycle__c = (Integer) mapJson.get('maintenanceperiod');
                mapEqui.Lifespan_Months__c = (Integer) mapJson.get('lifespan');
                mapEqui.Cost__c = (Integer) mapJson.get('cost');
                mapEqui.Warehouse_SKU__c = (String) mapJson.get('sku');
                mapEqui.Current_Inventory__c = (Double) mapJson.get('quantity');
                mapEqui.ProductCode = (String) mapJson.get('_id');
                equipmentForInsert.add(mapEqui);
            }
            
                upsert equipmentForInsert;
                System.debug(equipmentForInsert);
            
        }
    }
    
}