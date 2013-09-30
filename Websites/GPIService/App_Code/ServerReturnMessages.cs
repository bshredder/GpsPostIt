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
/// Server messages corresponding to return codes.
/// </summary>
public class ServerReturnMessages
{
    public static readonly string NullArgumentMessage = "Null argument to method.";
    public static readonly string IncorrectCredentialsMessage = "Incorrect username/password combination.";
    public static readonly string CannotWriteCredentialsDbMessage = "Cannot write credentials to database.";
    public static readonly string CannotRemoveCredentialsDbMessage = "Cannot remove credentials from database.";
    public static readonly string CannotAuthorPinMessage = "Cannot author pin.";
    public static readonly string CannotModifyPinMessage = "Cannot modify pin.";
    public static readonly string CannotRatePinMessage = "Cannot rate pin.";
    public static readonly string CannotCreateGroupMessage = "Cannot create group.";
    public static readonly string CannotAddUserToGroupMessage = "Cannot add user to group.";
    public static readonly string CannotRemoveUserFromGroupMessage = "Cannot remove user from group.";
    public static readonly string CannotRemoveGroupMessage = "Cannot remove user from group.";
    public static readonly string InvalidServiceToken = "Invalid service token.";
}
