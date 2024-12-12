public class UserHandler {
    /********
Once a user is updated an email should go to his Manager’s email Id,
with the total number of Account Owned by him,
You have assigned a number of accounts and Account Contains a Number of Contacts
Like
Subject: Your Accounts and Number of Related Contacts
Body: Dear User,
You have assigned a number of accounts and Account Contains the Number of Contacts.
Total Accounts = 3
*************/
    public static void ContactsCount(Map<id,user> newMapUser ,Map<id,User> oldMapUser){
        Map<String,id> mapofUserId = new Map<String,id>();
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage >();
        set<id> contactIds =new set<Id>();
       List<String> toaddress = new List<String>();
        Integer countofContacts = 0;
        for(user us : newMapUser.values()){
            mapofUserId.put('managerId',us.ManagerId);
            mapofUserId.put('userId',us.Id);
        }
        Map<id,Account> MapOfAccount = new Map<id,Account>([SELECT id,(SELECT id FROM contacts) ,Owner.Manager.Email
                                                            FROM Account
                                                            WHERE OwnerId =: mapofUserId.get('userId')]);
        
        for(Account acc : MapOfAccount.values()){
            system.debug('acc.Owner.Manager.Email '+acc.Owner.Manager.Email);
            toaddress.add(acc.Owner.Manager.Email);
            system.debug('toaddress ==> '+toaddress);
            for(contact con : acc.contacts){
                contactIds.add(con.Id);
                
            }
        }
        countofContacts = contactIds.size();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Your Accounts and Number of Related Contacts');
        mail.setToAddresses(toAddress);
        String body = 'Dear User, <br/>';
        body += 'You have assigned number of account and Account Contains Number of Contacts.<br/>';
        body += 'Total Accounts = '+countofContacts;
        mail.setHtmlBody(body);
        listEmail.add(mail);
        if(listEmail.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(listEmail);
            if (results[0].success)
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
            }
        }
    }
    }