select * from tblGroupItem
select * from tblPartyTransaction
select * from tblparty

select name,sum(tt.customerPayment) customerpayment
from tblPartyTransaction tt 
inner join tblParty tp on tt.customer = tp.Id
where name like '%a%'
group by name
having sum(tt.customerPayment) > 2000