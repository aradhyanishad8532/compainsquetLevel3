trigger CQTaskAradhya on Account (after insert, after update ) {
    if(trigger.isAfter){
        if(Trigger.isInsert  || Trigger.isUpdate ){
            ComplianceQuestAradhyaAccountHandler.solve(Trigger.newMap ,Trigger.oldMap);
        }

    }
 
}