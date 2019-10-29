Map<String, Schema.SObjectField> contactFieldSetMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();
List<Account> accountRecordList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account LIMIT 50000];
System.debug(SELECT COUNT() FROM Contact WHERE ' + getAllConditions(accountRecordList));
    
    private String getAllConditions(List<Account> accountRecordList) {
        String conditionString = '';

        List<Contact_Rule_Account_Junction__c> ruleList = [
            SELECT Contact_Assignment_Rule__r.Operator__c, Contact_Assignment_Rule__r.Field_Value__c, 
                Contact_Assignment_Rule__r.Field_API__c
            FROM Contact_Rule_Account_Junction__c 
            WHERE Account__c 
            IN :accountRecordList
        ];

        for (Contact_Rule_Account_Junction__c ruleItem : new Set(ruleList)) {
            conditionString += getCondition(ruleItem) + ' OR';
        }

        return conditionString.substring(0, conditionString.length() - 2);
    }

    private String getCondition(Contact_Rule_Account_Junction__c ruleItem) {
        String conditionString = '';

        // conditionString += ruleItem.Contact_Assignment_Rule__r.Field_API__c
        // + ruleItem.Contact_Assignment_Rule__r.Operator__c
        // + ruleItem.Contact_Assignment_Rule__r.Field_Value__c;

        return conditionString;
    }

    private Boolean isQuotesNeed(String fieldName) {
        Schema.DisplayType type = contactFieldSetMap.get(fieldName).getDescribe().getType();

        switch on type {
            when Boolean, Integer, Long, Currency {
                return false;
            }
            when else {
                return true;
            }
        }
    }