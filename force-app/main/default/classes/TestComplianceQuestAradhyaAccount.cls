@isTest
public class TestComplianceQuestAradhyaAccount {
    @testSetup
    public static void setupTestData(){
       
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin' LIMIT 1];
        
        User testUser = new User(
            Username = 'SandTest@abccomp.com',
            LastName = 'SandTest-User',
            Alias = 'Tuse',
            Email = 'TestSand@abcomp.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        PermissionSetAssignment psAssignment = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = permissionSet.Id
        );
        insert psAssignment;
    }

    @isTest
    public static void testAccountPositive(){
        User testUser = [SELECT Id FROM User WHERE Username = 'SandTest@abccomp.com'];
        System.runAs(testUser){
            Account acc = new Account(
                Name = 'Aradhya Test',
                AccountNumber = '101',
                AradhyaActive__c = false
            );
            insert acc;
            
            List<Task> tasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id];
            System.assertEquals(1, tasks.size());
            System.assertNotEquals('Completed', tasks[0].Status);
        }
    }

    @isTest
    public static void testTaskPositive(){
        User testUser = [SELECT Id FROM User WHERE Username = 'SandTest@abccomp.com'];
        System.runAs(testUser){
            Account acc = new Account(
                Name = 'Aradhya Test',
                AccountNumber = '101',
                AradhyaActive__c = false
            );
            insert acc;
            
            Task relatedTask = new Task(
                Subject = 'Review Account',
                ActivityDate = Date.today(),
                Status = 'Not Started',
                Priority = 'High',
                WhatId = acc.Id
            );
            insert relatedTask;
            
            relatedTask.Status = 'Completed';
                update relatedTask;
            Account updatedAccount = [SELECT Name,AradhyaActive__c FROM Account WHERE Id = :acc.Id];
            system.debug(updatedAccount);
            System.assertEquals(true, updatedAccount.AradhyaActive__c);
        }
    }

    @isTest
    public static void testAccountNegative(){
        User testUser = [SELECT Id FROM User WHERE Username = 'SandTest@abccomp.com'];
        System.runAs(testUser){
            Account acc = new Account(
                Name = 'Aradhya Test',
                AccountNumber = '101',
                AradhyaActive__c = true
            );
            insert acc;
            
            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
            System.assertEquals(0, tasks.size());
        }
    }

    @isTest
    public static void testTaskNegative(){
        User testUser = [SELECT Id FROM User WHERE Username = 'SandTest@abccomp.com'];
        System.runAs(testUser){
            Account acc = new Account(
                Name = 'Aradhya Test',
                AccountNumber = '101',
                AradhyaActive__c = false
            );
            insert acc;
            
            Task relatedTask = new Task(
                Subject = 'Review Account',
                ActivityDate = Date.today().addDays(7),
                Status = 'Not Started',
                Priority = 'High',
                WhatId = acc.Id
            );
            insert relatedTask;
              relatedTask.Status = 'In Progress';
                update relatedTask;
            
            Account updatedAccount = [SELECT AradhyaActive__c FROM Account WHERE Id = :acc.Id];
            System.assertEquals(false, updatedAccount.AradhyaActive__c);
        }
    }
}