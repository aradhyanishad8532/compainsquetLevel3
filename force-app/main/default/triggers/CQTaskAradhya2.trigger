trigger CQTaskAradhya2 on Task (After Update) {
    if(trigger.isAfter && trigger.isUpdate){
        CQTaskAradhya2Handler.solve2(Trigger.new,Trigger.oldMap);
    }
}