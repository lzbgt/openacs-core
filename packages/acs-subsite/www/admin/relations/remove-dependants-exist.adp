<master src="../master">
<property name="context_bar">@context_bar@</property>
<property name="title">Dependant relations exist</property>

You must remove the following dependant relations before you can
remove the @rel.rel_type_pretty_name@ between @rel.object_id_one_name@
and @rel.object_id_two_name@.

<p>

<ul>
  <multiple name="dependants">
    <li> @dependants.rel_type_pretty_name@ between 
         @dependants.object_id_one_name@ and @dependants.object_id_two_name@
         (<a href="remove?@dependants.export_vars@">remove</a>)
    </li>
  </multiple>
</ul>
