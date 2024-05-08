public class CQTaskAradhya2Handler {
    public static void solve2(List<Task>tlist,Map<Id,Task>oldMap){
        set<Id> accountIds = new set<Id>();
        for(Task t: tlist){
            Task oldTask = oldMap.get(t.Id);
            if(t.Status == 'Completed' && oldTask.Status != 'Completed' && t.WhatId != null && t.WhatId.getSObjectType() == Account.SObjectType){
                accountIds.add(t.WhatId);
            }
        }
        List<Account> accList = [select Id,AradhyaActive__c From Account Where Id IN :accountIds];
        for(Account acc:accList){
            acc.AradhyaActive__c = true;
        }
        update accList; 
    }
}