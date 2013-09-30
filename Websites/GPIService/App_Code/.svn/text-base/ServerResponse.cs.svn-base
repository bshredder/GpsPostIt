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
/// Generic response class to be extended by specific response classes as sent by the web service.
/// </summary>
public abstract class ServerResponse
{
    private ServerConstants.ResponseType responseType;
    public ServerConstants.ResponseType ResponseType
    {
        get
        {
            return responseType;
        }
        set
        {
            responseType = value;
        }
    }

    private string responseCode;
    public string ResponseCode
    {
        get
        {
            return responseCode;
        }
        set
        {
            responseCode = value;
        }
    }

    protected string transactionId;
    public string TransactionId
    {
        get
        {
            return transactionId;
        }
        set
        {
            transactionId = value;
        }
    }

    public ServerResponse()
    {
    }
}
