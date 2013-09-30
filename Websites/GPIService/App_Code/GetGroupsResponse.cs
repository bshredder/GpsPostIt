using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Response sent after a get groups operation.
/// </summary>
public class GetGroupsResponse: ServerResponse
{
    private List<GroupDetails> responseObj;
    public List<GroupDetails> ResponseObj
    {
        get
        {
            return responseObj;
        }
        set
        {
            responseObj = value;
        }
    }

    public GetGroupsResponse()
    {
    }
}
