<master src="../master">
<property name="context_bar">@context_bar@</property>
<property name="title">Remove @rel_pretty_name@</property>

Are you sure you want to remove @rel_pretty_name@ from the list of allowable relations for groups of type @group_type_pretty_name@?

<p>

<center>
<include src="../confirm-delete-form" action="rel-type-remove-2" export_vars="@export_vars@" no_button="No, I want to cancel my request" yes_button="Yes, I really want to remove this relationship type">
</center>

