<master>
<property name=title>@full_name@'s workspace at @system_name@</property>

<h2>@full_name@'s workspace at @system_name@</h2>

@context_bar@

<hr>

<ul>

<p>

<li><a href="/register/logout">Log Out</a>

<p>

<li><a href="/user/password-update">Change my Password</a>


</ul>

<h3>What we tell other users about you</h3>

In general we identify content that you've posted by your full name.
In an attempt to protect you from unsolicited bulk email (spam), we
keep your email address hidden except from other registered users.
Total privacy is technically feasible but an important element of an
online community is that people can learn from each other.  So we try
to make it possible for users with common interests to contact each
other.

<p>

If you want to check what other users of this service are shown, visit
<a href="/shared/community-member?@export_user_id@">@ad_url@/shared/community-member?@export_user_id@</a>.

<h4>Basic Information</h4>

<ul>
<li>Name:  @full_name@
<li>email address:  @email@
<li>personal URL:  <a target=new_window href="@url@">@url@</a>
<li>screen name:  @screen_name@
<li>bio: @bio@
<p>
(<a href="/user/basic-info-update">update</a>)
</ul>


<if @portrait_state@ eq upload>

<h4>Your Portrait</h4>
Show everyone else at @system_name@ how great looking you are:  <a href="/user/portrait/upload">upload a portrait</a>

</if>
<if @portrait_state@ eq show>

<h4>Your Portrait</h4>
On @portrait_publish_date@, you uploaded <a href="/user/portrait/">@portrait_title@</a>.

</if>



<h3>If you're getting too much email from us</h3>

Then you should either 

<ul>
<li><a href="alerts">edit your alerts</a>

<p>

or

<p>

<li><a href="unsubscribe">Unsubscribe</a> (for a period of vacation or permanently)

</ul>
