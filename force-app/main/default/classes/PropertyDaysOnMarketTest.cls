@isTest
private class PropertyDaysOnMarketTest {
    @isTest
    static void testDaysOnMarketForPropertyListed30DaysAgo() {
        // GIVEN a property listed 30 days ago
        Property__c property = new Property__c(
            Name = 'Listed 30 Days Ago',
            Date_Listed__c = Date.today().addDays(-30)
        );
        insert property;

        // WHEN querying the formula field
        Test.startTest();
        Property__c result = [
            SELECT Days_On_Market__c
            FROM Property__c
            WHERE Id = :property.Id
        ];
        Test.stopTest();

        // THEN it reports 30 days on market
        Assert.areEqual(30, result.Days_On_Market__c);
    }

    @isTest
    static void testDaysOnMarketBlankWhenDateListedBlank() {
        // GIVEN a property with no Date_Listed__c
        Property__c property = new Property__c(
            Name = 'Not Listed Yet',
            Date_Listed__c = null
        );
        insert property;

        // WHEN querying the formula field
        Test.startTest();
        Property__c result = [
            SELECT Days_On_Market__c
            FROM Property__c
            WHERE Id = :property.Id
        ];
        Test.stopTest();

        // THEN it is blank, not zero
        Assert.isNull(result.Days_On_Market__c);
    }

    @isTest
    static void testDaysOnMarketFieldPermissionsOnDreamhousePermissionSet() {
        // GIVEN the Dreamhouse permission set
        PermissionSet ps = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'dreamhouse'
        ];

        // WHEN querying its field permissions for Days_On_Market__c
        Test.startTest();
        FieldPermissions fieldPermissions = [
            SELECT PermissionsRead, PermissionsEdit
            FROM FieldPermissions
            WHERE
                ParentId = :ps.Id
                AND SobjectType = 'Property__c'
                AND Field = 'Property__c.Days_On_Market__c'
        ];
        Test.stopTest();

        // THEN it is readable but not editable
        Assert.isTrue(fieldPermissions.PermissionsRead);
        Assert.isFalse(fieldPermissions.PermissionsEdit);
    }
}
