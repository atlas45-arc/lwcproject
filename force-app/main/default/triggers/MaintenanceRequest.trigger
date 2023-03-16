trigger MaintenanceRequest on Case (before update) {
    new MaintenanceRequestHelper().run();

}