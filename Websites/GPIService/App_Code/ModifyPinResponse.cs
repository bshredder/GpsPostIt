using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Response sent after a modify pin operation.
/// </summary>
public class ModifyPinResponse: ServerResponse
{
    private PinDetails responseObj;
    public PinDetails ResponseObj
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

    public ModifyPinResponse()
    {
    }
}