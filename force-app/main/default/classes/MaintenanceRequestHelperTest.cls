@IsTest
private class MaintenanceRequestHelperTest {
    @IsTest
    static void testBeforeUpdate() {
        // Test setup
        Account acc = new Account(Name='Test Account');
        insert acc;
        Contact con = new Contact(FirstName='Test', LastName='Contact', AccountId=acc.Id);
        insert con;
        Vehicle__c vehicle = new Vehicle__c(Name='Test Vehicle');
        insert vehicle;
        Product2 product = new Product2(Name='Test Product', ProductCode='TP01', Cost__c=100, 
                                         Current_Inventory__c=10, Lifespan_Months__c=12, 
                                         Maintenance_Cycle__c=365, Family='Test',Replacement_Part__c =true);
        insert product;
        Case closedCase = new Case(Subject='Test Closed Case', Type='Routine Maintenance', 
                                   Status='New', Priority='Normal', Origin='Web', 
                                   Vehicle__c=vehicle.Id, AccountId=acc.Id, ContactId=con.Id);
        insert closedCase;
        Equipment_Maintenance_Item__c junction = new Equipment_Maintenance_Item__c();
        junction.Equipment__c=product.Id;
        junction.Maintenance_Request__c=closedCase.Id;
        insert junction;
        
        // Test execution
        Test.startTest();
        closedCase.Status='Closed';
        Update closedCase;
        Test.stopTest();
        
        // Test verification
        List<Case> newCases = 
        [
            SELECT Id, Status, Type, Vehicle__c, AccountId, ContactId 
            FROM Case WHERE Status='New' 
            AND Type='Routine Maintenance'];
        System.assertEquals(1, newCases.size());
        System.assertEquals(vehicle.id, newCases[0].Vehicle__c);
        // System.assertEquals(acc.Id, newCases[0].AccountId);
        // System.assertEquals(con.Id, newCases[0].ContactId);
        
        List<Equipment_Maintenance_Item__c> newJunctions = [SELECT Id, Maintenance_Request__c 
                                                
                                                            FROM Equipment_Maintenance_Item__c];
        System.assertEquals(2, newJunctions.size());
       
    }
    
    @IsTest
    static void testObtainMaintenanceTime() {
        // Test setup
        List<Product2> listOfProducts = new List<Product2>();
        Product2 product1 = new Product2(Maintenance_Cycle__c=365);
        Product2 product2 = new Product2(Maintenance_Cycle__c=10);

        listOfProducts.add(product1);
        listOfProducts.add(product2);
        //Test verification
        System.assertEquals(10,  MaintenanceRequestHelper.obtainMaintenanceTime(listOfProducts));
        MaintenanceRequestHelper.obtainMaintenanceTime(listOfProducts);
        

 
    }
    }