  <form method="GET" action="/search/search">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">  
      <tr>      
        <td valign="top" NOWRAP>
          <a href="/"><img src="/templates/slices/openacs.gif" width="154" height="68" border="0" alt="Home"></a>
        </td>    
        <td width="100%" valign="top">
          <div class="navigation">
            <table bgcolor="#006699" border="0" cellpadding="0" cellspacing="0" width="100%">  
              <tr align="center">    
                <td><img src="/templates/slices/spacer.gif" width="10" height="33" border="0" alt=""></td>    
                <include src="navigation">  
              </tr>
            </table>
          </div>

          <table border="0" cellpadding="0" cellspacing="0" width="100%">  
            <tr>    
              <td colspan="4">
                <img src="/templates/slices/spacer.gif" width="0" height="2" border="0" alt="">
              </td>  
            </tr>  
            <tr bgcolor="#eeeeee" align="center">    
              <td width="1%">
                <img src="/templates/slices/spacer.gif" width="1" height="33" border="0" alt="">
              </td>    
              <td width="33%" NOWRAP>
                <span class="statistics"><include src="statistics"></span>
              </td>    
              <td width="1%">
                <img src="/templates/slices/spacer.gif" width="5" height="1" border="0" alt="">
              </td>    

              <include src="user-status">    

              <td width="1%">
                <img src="/templates/slices/spacer.gif" width="5" height="1" border="0" alt="">
              </td>      
              <td width="10%" NOWRAP>        
                <span class="search">          
                  <input type="text" name="q" maxlength="256">              
                </span> 
              </td>    
              <td width="1%">
                <img src="/templates/slices/spacer.gif" width="5" height="1" border="0" alt="">
              </td>   
              <td width="5%" NOWRAP>
                <input type="image" src="/templates/images/search.gif"> 
                <!-- <input type="image" src="/templates/images/search.gif" width="47" height="19" border="0"> -->
              </td>  
            </tr>
          </table>    
        </td>      
        <td valign="top" width="8">
          <img src="/templates/slices/head_upright.gif" width="8" height="33" border="0" alt="">
          <img src="/templates/slices/spacer.gif" width="8" height="2" border="0" alt="">
          <img src="/templates/slices/head_lowright.gif" width="8" height="33" border="0" alt="">
        </td>  
      </tr>
    </table>
  </form>
