<master>
<property name="title">@system_name@</property>
<property name="focus">@focus@</property>
<h2>Congratulations!</h2>
<hr>


<table cellspacing="4" cellpadding="4" border="0">
  <tr>
    <td valign="top">

      You have successfully installed <b>ArsDigita Community System</b>
      version @acs_version@.

      <p>

      Thank you for using our software. Please write us at the <a
      href="http://www.arsdigita.com/bboard/q-and-a?topic_id=21">web/db bboard</a> to let
      us know of your experience with installing and using ACS. 
      
      <p>
      
      <if @user_id@ gt 0>
        You are currently logged in as @name@ (<a href="/register/">change
        login</a>).
      </if>
      <else>
        Start by <b>logging in</b> in the box on the right, using the email
        address and password that you have just specified for the
        administrator.
      </else>
      
      
      
      
      <h3>How to Customize Your Site</h3>
      
      If you want to <b>customize the look</b> of your website, the easiest
      way to start is to edit the template that gets wrapped around every
      page. The master template is the file
      <code>@acs_root_dir@/www/default-master.adp</code>. 
      An ADP file is almost like HTML, except with a few extra bells
      and whistles (<a href="/doc/acs-templating/designer-guide.html"
      title="Templating Designer's Guide">learn more</a>).
      
      <p>
      
      You almost certainly
      also want to <b>customize this page</b>, your front page. To do that,
      edit the files <code>@acs_root_dir@/www/index.adp</code> and
      <code>@acs_root_dir@/www/index.tcl</code>.
      
      <h3>How to Add Functionality to Your Site</h3>
      
      To <b>download application packages</b> that you can install on your system, visit
      the <a href="http://www.arsdigita.com/acs-repository/" 
      title="ACS Repository on arsdigita.com">ACS Repository</a>. 
      To make them available to users of your site, use the <a
      href="/admin/site-map/" title="The Site Map on your
      server">Sitemap</a>.
      
      <p>
      
      To <b>manage the packages on your system</b>, visit the <a href="/acs-admin/apm/"
      title="ACS Package Manager on your server">Package Manager</a>
      on your own server. 
      
      <p>
      
      
      Should you develop an ACS package that you want to share with the rest
      of the community, upload it to the <a
      href="http://www.arsdigita.com/acs-repository/"
      title="ACS Repository on arsdigita.com">ACS Repository</a> and we will
      evaluate it and publish it.
      
      <p>
      
      For more administrative options, visit <a href="/acs-admin/"
      title="Package and User administration">ACS-Administration pages</a> for packages and users, 
      or <a href="/admin/" 
      title="Sitemap and Groups administration">Main site admin pages</a>
      for groups and sitemap.
      
      <h3>How to Learn More</h3>
      
      Your ACS installation comes with <a href="/doc/" 
      title="Documentation Home on your server"><b>documentation</b></a>. When you start
      programming, you will also find the <a href="/api-doc/" 
      title="API Documentation">API documentation</a> useful.
      
      <p>
      
      Should you ever <b>get stuck</b>, or if you just want to <b>hang out</b> with other
      ACS users, visit the <a href="http://www.arsdigita.com/bboard/"
      title="ArsDigita Discussion Forums">discussion forums</a> on arsdigita.com, in
      particular the <a
      href="http://www.arsdigita.com/bboard/q-and-a?topic_id=21"
      title="Web/DB discussion forum on arsdigita.com">web/db forum</a>.
      The home of the <b>ACS community</b> is
      at <a href="http://developer.arsdigita.com/" 
      title="ACS Developer Community">http://developer.arsdigita.com</a>.
      
      
      <p>
      
      If you <b>find bugs</b> or have <b>feature requests</b>, post them in
      our <a href="http://www.arsdigita.com/sdm/" 
      title="Software Development Manager on arsdigita.com">Software
      Development Manager</a> (SDM). If you have bugfixes or patches
      yourself, post them in the SDM, too. 
      
      <p> 
      
      Here are the <b>packages currently available</b> on your
      system:
      
      <ul>
        <multiple name=nodes>
          <li><a href=@nodes.url@>@nodes.name@</a></li>
        </multiple>
      </ul>
      
      <if @name@ not nil>
        If you like, you can go directly to <a href="@home_url@">@name@'s
        @home_url_name@</a>.
      </if> 

    </td>
    <td valign="top">

      <if @user_id@ gt 0>
        <!-- Already logged in -->
      </if>
      <else>
        <table bgcolor="#cccccc" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td>
              <table cellspacing="1" cellpadding="4" border="0">
                <tr bgcolor="#ccccff">
                  <th>
                    Log in
                  </th>
                </tr>
                <FORM method="post" action="register/user-login" name="login">
                  <tr bgcolor="#eeeeee">
                    <td>
                      @form_vars@
                      <table>
                      <tr><td>Email:</td><td><INPUT type=text name=email value=@email@></tr>
                      <tr><td>Password:</td><td><input type=password name=password></td></tr>
                      
                      <if @allow_persistent_login_p@ eq 1>
                      <tr><td colspan=2><input type=checkbox name=persistent_cookie_p value=1 @remember_password@> 
                      Remember this login
                      (<a href="register/explain-persistent-cookies">help</a>)</td></tr>
                      </if>
                      
                      <tr><td colspan=2 align=center><INPUT TYPE=submit value="Log in"></td></tr>
                      </table>
                    </td>
                  </tr>
                </FORM>
              </table>
            </td>
          </tr>
        </table>
      </else>

      <p>
    
      <table bgcolor="#cccccc" cellpadding="0" cellspacing="0" border="0" align="right">
        <tr>
          <td>
            <table cellspacing="1" cellpadding="4" border="0">
              <tr bgcolor="#ccccff">
                <th>
                  Quick Links
                </th>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/doc/">Documentation</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/api-doc/">API Documentation</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/admin/site-map/">Site map</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/acs-admin/apm/">Package Manager</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/acs-admin/users/">Users</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/admin/groups/">Groups</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/admin/">Main site admin</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="/acs-admin/">Site-wide admin</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="http://www.arsdigita.com/acs-repository/">Downloads</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="http://developer.arsdigita.com/">Developer Community</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a
   href="http://www.arsdigita.com/bboard/q-and-a?topic_id=21">Web/DB bboard</a>
                </td>
              </tr>
              <tr bgcolor="#eeeeee">
                <td>
                  <a href="http://www.arsdigita.com/bboard/">Other bboards</a>
                </td>
              </tr>
             <tr bgcolor="#eeeeee">
                <td>
                  <a href="http://www.arsdigita.com/sdm/">Report a bug</a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
