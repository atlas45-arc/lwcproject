public class MyScheduledClass implements Schedulable {
    public void execute(SchedulableContext context) {
        // Write your scheduled logic here
        List<Account> accountsToUpdate = [SELECT Id, Name, AnnualRevenue FROM Account WHERE AnnualRevenue > 1000000];
        for (Account acc : accountsToUpdate) {
            acc.AnnualRevenue *= 0.9; // Reduce annual revenue by 10%
        }
        update accountsToUpdate;
        System.debug('Updated ' + accountsToUpdate.size() + ' accounts');
    }
}

// Schedule the class to run every day at 10:00 PM
// String cron = '0 0 22 * * ?';
// System.schedule('My Daily Scheduled Job', cron, new MyScheduledClass());