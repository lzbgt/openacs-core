<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="name">      
      <querytext>
      select acs_object__name(:object_id) 
      </querytext>
</fullquery>

 
<fullquery name="inherited_permissions">      
      <querytext>
      
  select grantee_id, grantee_name, privilege
  from (select grantee_id, acs_object__name(grantee_id) as grantee_name,
               privilege, 1 as counter
        from acs_permissions_all
        where object_id = :object_id
        union all
        select grantee_id, acs_object__name(grantee_id) as grantee_name,
               privilege, -1 as counter
        from acs_permissions
        where object_id = :object_id) dummy
  group by grantee_id, grantee_name, privilege
  having sum(counter) > 0

      </querytext>
</fullquery>

 
<fullquery name="acl">      
      <querytext>
      
  select grantee_id, acs_object__name(grantee_id) as grantee_name,
         privilege
  from acs_permissions
  where object_id = :object_id

      </querytext>
</fullquery>

 
<fullquery name="context">      
      <querytext>
      
  select acs_object__name(context_id)
  from acs_objects
  where object_id = :object_id

      </querytext>
</fullquery>

 
<fullquery name="children">      
      <querytext>
      
	select object_id as c_object_id,acs_object__name(object_id) as c_name
	from acs_objects o
	where context_id = :object_id
              and exists (select 1
                          from all_object_party_privilege_map
                          where object_id = o.object_id
                          and party_id = :user_id
                          and privilege = 'admin')    
    
      </querytext>
</fullquery>

 
</queryset>
