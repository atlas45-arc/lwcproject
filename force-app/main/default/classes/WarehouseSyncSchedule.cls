public class WarehouseSyncSchedule implements Schedulable {
    public void execute(SchedulableContext context) {
        // Write your scheduled logic here
        System.enqueueJob(new WarehouseCalloutService());   }
}
        // Schedule the class to run every day at 8:00 AM
        // String cron = '0 0 0 * * ?';
        // System.schedule('WarehouseSyncScheduleJob', cron, new WarehouseSyncSchedule());


    

