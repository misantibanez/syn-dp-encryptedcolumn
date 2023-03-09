CREATE CERTIFICATE Sales09  
   WITH SUBJECT = 'Customer Credit Card Numbers';  

CREATE SYMMETRIC KEY CreditCards_Key11  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Sales09;  

insert into dbo.creditcard values (1,'visa','1234-1234-1234-1234',2,23,'06/03/23');
insert into dbo.creditcard values (2,'mastercard','2345-2345-2345-2345',2,23,'06/03/23');

ALTER TABLE dbo.CreditCard   
    ADD CardNumber_Encrypted VARBINARY(8000);   
GO  

-- Execute together both statements
OPEN SYMMETRIC KEY CreditCards_Key11  
   DECRYPTION BY CERTIFICATE Sales09;  

UPDATE dbo.CreditCard  
SET CardNumber_Encrypted = EncryptByKey(Key_GUID('CreditCards_Key11'), CardNumber);  
GO  

-- Execute together both statements
OPEN SYMMETRIC KEY CreditCards_Key11  
   DECRYPTION BY CERTIFICATE Sales09;  
GO  

SELECT
[CreditCardID]
,[CardType]
,[CardNumber]
,[ExpMonth]
,[ExpYear]
,[ModifiedDate]
,CardNumber_Encrypted AS 'Encrypted card number', 
,cast(DecryptByKey(CardNumber_Encrypted) as Varchar(20)) as 'Decrypted card number'
FROM dbo.CreditCard


-- Execute together both statements
OPEN SYMMETRIC KEY CreditCards_Key11  
   DECRYPTION BY CERTIFICATE Sales09;  
SELECT 
    *,
    CAST(DecryptByKey(CardNumber_Encrypted) as VARCHAR(20)) AS 'Decrypted card number' 
FROM dbo.CreditCard;  

