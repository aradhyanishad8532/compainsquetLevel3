public class ComplianceQuestAradhyaAccountHandler {
    public static void solve(Map<id,Account> newMap , Map<id ,Account> oldMap){
        List<Task> TaskList=new List<Task>();
        for (Id key:newMap.keyset()){
            if((trigger.isInsert &&!newMap.get(key).AradhyaActive__c)){
                Task RelatedTask = new task();
                RelatedTask.Subject='Review Account - '+newMap.get(key).AccountNumber;
                RelatedTask.ActivityDate=Date.today().addDays(7);
                RelatedTask.Status='Not Started';
                RelatedTask.Priority='High';
                 RelatedTask.WhatId=Key;
                RelatedTask.OwnerId =UserInfo.getUserId();
                TaskList.add(RelatedTask);
                
            }
            
        }
        if(TaskList !=null){
            insert TaskList;
            
        }
        
      
    }

}