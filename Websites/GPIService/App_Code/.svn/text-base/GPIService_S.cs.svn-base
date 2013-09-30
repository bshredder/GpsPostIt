using System;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Security.Cryptography;
using System.Diagnostics;
using System.Web.Security;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using ServerConstants;


/// <summary>
/// "Secure" web service.
/// </summary>
[WebService(Namespace = "http://www.gpspostit.com/gpiws_s/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class GPIService_S : System.Web.Services.WebService
{
    private readonly string connectionString = string.Empty;
    private const string validationTokenDelimiter = "_";
    private const string hashAlgorithm = "SHA512";

    public GPIService_S()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent();
        this.connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["GpiDbConnectionString"].ToString();
    }

    /// <summary>
    /// This method returns two validation tokens using login details from the membership database given
    /// an userName and a password. The first token is used with the unsecured (get) webservice. The second
    /// token is used with the secured (put) webservice.
    /// </summary>
    /// <param name="credentials"></param>
    /// <returns></returns>
    [WebMethod]
    public LoginResponse Login(Credentials credentials)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserName == null || credentials.Password == null)
        {
            throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // Validate the user against the membership database
        Membership.ApplicationName = ConfigurationManager.AppSettings["AppName"];
        bool isValidUser = false;
        try
        {
            isValidUser = Membership.ValidateUser(credentials.UserName, credentials.Password);
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        if (!isValidUser)
        {
            Debug.WriteLine("Unable to validate " + credentials.UserName + ". Returning empty validation token.");

            throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.IncorrectCredentialsMessage, ServerReturnCodes.IncorrectCredentials, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        Debug.WriteLine("User " + credentials.UserName + " is valid.");

        // Calculate a pair of validation tokens using the userName, the password
        // and a random salt value
        // The salt value for the get token is the current time and for the put token
        // is current time minus a random number of days between 0 and 365.
        DateTime now = DateTime.Now;
        StringBuilder sb = new StringBuilder();
        sb.Append(credentials.UserName);
        sb.Append(validationTokenDelimiter);
        sb.Append(credentials.Password);
        sb.Append(validationTokenDelimiter);
        sb.Append(now.ToLongDateString());
        sb.Append(validationTokenDelimiter);
        sb.Append(now.ToLongTimeString());
        sb.Append(validationTokenDelimiter);
        sb.Append(now.Millisecond);
        string validationTokenStr1 = sb.ToString();

        Random r = new Random();
        int randomDays = r.Next(1, 365);
        DateTime then = now.AddDays(-randomDays);
        Debug.WriteLine("Random number of days between 1 and 365 = " + randomDays);

        StringBuilder sb2 = new StringBuilder();
        sb2.Append(credentials.UserName);
        sb2.Append(validationTokenDelimiter);
        sb2.Append(credentials.Password);
        sb2.Append(validationTokenDelimiter);
        sb2.Append(then.ToLongDateString());
        sb2.Append(validationTokenDelimiter);
        sb2.Append(then.ToLongTimeString());
        sb2.Append(validationTokenDelimiter);
        sb2.Append(then.Millisecond);
        string validationTokenStr2 = sb2.ToString();

        Debug.WriteLine("Unsecured services validation token string = " + validationTokenStr1);
        Debug.WriteLine("Secured services validation token string = " + validationTokenStr2);

        // Initialize appropriate hashing algorithm class
        HashAlgorithm hash = null;
        switch (hashAlgorithm.ToUpper())
        {
            case "SHA1":
                hash = new SHA1Managed();
                break;

            case "SHA256":
                hash = new SHA256Managed();
                break;

            case "SHA384":
                hash = new SHA384Managed();
                break;

            case "SHA512":
                hash = new SHA512Managed();
                break;

            default:
                hash = new MD5CryptoServiceProvider();
                break;
        }

        // compute hash value of our validation token string
        byte[] plainTextBytes1 = Encoding.UTF8.GetBytes(validationTokenStr1);
        byte[] plainTextBytes2 = Encoding.UTF8.GetBytes(validationTokenStr2);
        byte[] hashBytes1 = hash.ComputeHash(plainTextBytes1);
        byte[] hashBytes2 = hash.ComputeHash(plainTextBytes2);

        // convert result into a base64-encoded string.
        string hashValue1 = Convert.ToBase64String(hashBytes1);
        string hashValue2 = Convert.ToBase64String(hashBytes2);

        // write the tokens into the database
        MembershipUser user = Membership.GetUser(credentials.UserName);
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            // build the command to call a sproc that
            // stores logon information into the database
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GpiLoginUser";

            SqlParameter paramReturnValue = new SqlParameter();
            paramReturnValue.ParameterName = "@returnValue";
            paramReturnValue.SqlDbType = SqlDbType.Int;
            paramReturnValue.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(paramReturnValue);

            SqlParameter paramUserId = new SqlParameter();
            paramUserId.ParameterName = "@userId";
            paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
            paramUserId.Direction = ParameterDirection.Input;
            paramUserId.Value = new Guid(user.ProviderUserKey.ToString());
            cmd.Parameters.Add(paramUserId);

            SqlParameter paramUnsecuredServicesValidationToken = new SqlParameter();
            paramUnsecuredServicesValidationToken.ParameterName = "@unsecuredServicesValidationToken";
            paramUnsecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
            paramUnsecuredServicesValidationToken.Direction = ParameterDirection.Input;
            paramUnsecuredServicesValidationToken.Value = hashValue1;
            cmd.Parameters.Add(paramUnsecuredServicesValidationToken);

            SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
            paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
            paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
            paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
            paramSecuredServicesValidationToken.Value = hashValue2;
            cmd.Parameters.Add(paramSecuredServicesValidationToken);

            cmd.ExecuteNonQuery();

            int rowsAffected = (int)cmd.Parameters["@returnValue"].Value;
            if (rowsAffected == 0)
            {
                throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotWriteCredentialsDbMessage, ServerReturnCodes.CannotWriteCredentialsDb, string.Empty, SoapExceptionGenerator.FaultCode.Server);
            }
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("Login", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotLogin, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        // return the token to the user
        Credentials outCreds = new Credentials();
        outCreds.UserId = user.ProviderUserKey.ToString();
        outCreds.UnsecuredServicesValidationToken = hashValue1;
        outCreds.SecuredServicesValidationToken = hashValue2;
        LoginResponse loginResponse = new LoginResponse();
        loginResponse.ResponseType = ServerConstants.ResponseType.Login;
        loginResponse.ResponseCode = ServerReturnCodes.LoggedIn;
        loginResponse.ResponseObj = outCreds;
        loginResponse.TransactionId = string.Empty;
        return loginResponse;
    }

    /// <summary>
    /// Logs out the user from the webservice.
    /// </summary>
    /// <param name="credentials"></param>
    /// <returns></returns>
    [WebMethod]
    public LogoutResponse Logout(Credentials credentials)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null || credentials.SecuredServicesValidationToken.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("Logout", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // delete the tokens from the database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            // build the command to call a sproc that
            // deletes logon information from the database
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GpiLogoutUser";

            SqlParameter paramReturnValue = new SqlParameter();
            paramReturnValue.ParameterName = "@returnValue";
            paramReturnValue.SqlDbType = SqlDbType.Int;
            paramReturnValue.Direction = ParameterDirection.ReturnValue;
            cmd.Parameters.Add(paramReturnValue);

            SqlParameter paramUserId = new SqlParameter();
            paramUserId.ParameterName = "@userId";
            paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
            paramUserId.Direction = ParameterDirection.Input;
            paramUserId.Value = new Guid(credentials.UserId);
            cmd.Parameters.Add(paramUserId);

            SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
            paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
            paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
            paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
            paramSecuredServicesValidationToken.Value = credentials.SecuredServicesValidationToken;
            cmd.Parameters.Add(paramSecuredServicesValidationToken);

            cmd.ExecuteNonQuery();
            LogoutResponse logoutResponse = new LogoutResponse();
            logoutResponse.ResponseType = ServerConstants.ResponseType.Logout;
            logoutResponse.ResponseCode = ServerReturnCodes.LoggedOut;
            return logoutResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("Logout", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("Logout", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotLogout, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// This method authors a pin in the database and returns the all the details of the pin encapsulated
    /// in an object.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="inPin"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(PinDetails))]
    public AuthorPinExResponse AuthorPinEx(Credentials credentials, PinDetails inPin, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            inPin == null ||
            inPin.Title == null || inPin.Title.Equals(string.Empty) ||
            inPin.Message == null || inPin.Message.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("AuthorPinEx", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        bool hasAttachment = false;
        if (inPin.Attachment == null || inPin.Attachment.Equals(string.Empty))
        {
            // no attachment to be added to the pin
        }
        else
        {
            hasAttachment = true;
        }

        // store pin in database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            // determine client information
            ClientInfo ci = GatherClientInfo();

            DateTime cTime = Convert.ToDateTime(inPin.CreateTime);
            SqlCommand cmd = this.BuildAuthorPinExCommand(hasAttachment, conn, credentials.UserId, credentials.SecuredServicesValidationToken,
                inPin.Title, inPin.Message, inPin.Latitude, inPin.Longitude, inPin.Attachment, inPin.AttachmentName, inPin.AttachmentType, inPin.TagList, Convert.ToDateTime(inPin.CreateTime),
                ci);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.SelectCommand = cmd;
            da.Fill(ds);

            if (ds.Tables.Count == 0)
            {
                throw SoapExceptionGenerator.RaiseException("AuthorPinEx", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotAuthorPinMessage, ServerReturnCodes.CannotAuthorPin, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            Guid pinId = (Guid)ds.Tables[0].Rows[0]["PinId"];
            string attachmentId = string.Empty;
            if (hasAttachment)
            {
                attachmentId = (string)ds.Tables[0].Rows[0]["AttachmentId"];
            }
            string author = (string)ds.Tables[0].Rows[0]["Author"];
            string tagListFromDb = (string)ds.Tables[0].Rows[0]["TagList"];
            DateTime createTimeInDb = (DateTime)ds.Tables[0].Rows[0]["CreateTimeInDb"];

            PinDetails outPin = new PinDetails();
            outPin.Title = inPin.Title;
            outPin.Message = inPin.Message;
            outPin.Latitude = inPin.Latitude;
            outPin.Longitude = inPin.Longitude;
            if (hasAttachment)
            {
                outPin.AttachmentName = inPin.AttachmentName;
                outPin.AttachmentType = inPin.AttachmentType;
                outPin.AttachmentId = attachmentId;
            }
            outPin.Author = author;
            outPin.AverageRating = 0.0F;
            outPin.TotalEvaluations = 0;
            outPin.PinId = pinId.ToString();
            outPin.TagList = tagListFromDb;
            outPin.CreateTime = inPin.CreateTime.ToString();
            outPin.ModifyTime = inPin.CreateTime.ToString();
            outPin.CreateTimeInDb = createTimeInDb.ToString();
            outPin.ModifyTimeInDb = createTimeInDb.ToString();

            AuthorPinExResponse authorPinExResponse = new AuthorPinExResponse();
            authorPinExResponse.ResponseType = ResponseType.AuthorPinEx;
            authorPinExResponse.ResponseCode = ServerReturnCodes.AuthoredPin;
            authorPinExResponse.ResponseObj = outPin;
            authorPinExResponse.TransactionId = transactionId;
            return authorPinExResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("AuthorPinEx", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("AuthorPinEx", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotAuthorPin, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to author a pin.
    /// </summary>
    /// <param name="hasAttachment"></param>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="title"></param>
    /// <param name="message"></param>
    /// <param name="latitude"></param>
    /// <param name="longitude"></param>
    /// <param name="attachment"></param>
    /// <param name="attachmentName"></param>
    /// <param name="attachmentType"></param>
    /// <param name="tags"></param>
    /// <param name="createTime"></param>
    /// <returns></returns>
    private SqlCommand BuildAuthorPinExCommand(bool hasAttachment, SqlConnection conn, string userId, string securedServicesValidationToken, 
                            string title, string message, double latitude, double longitude, 
                            string attachment, string attachmentName, string attachmentType, 
                            string tags, DateTime createTime, ClientInfo ci)
    {
        // filter out the #any# tag
        tags = tags.ToLower();
        tags = tags.Replace(ServerConstants.TagConstants.AnyTag, string.Empty); 

        // collapse all multiple spaces in tag list to single space
        // and change spaces to commas
        tags = Regex.Replace(tags, @"\s+", " ");
        tags = Regex.Replace(tags, " ", ",");
        Debug.WriteLine("The massaged tag list = " + tags);

        // filter out duplicate tags
        string[] tagsAsArray = tags.Split(new char[] { ',' });
        SortedList<string, string> tagsAsSortedList = new SortedList<string, string>();
        foreach (string tagArrayElement in tagsAsArray)
        {
            if (tagsAsSortedList.ContainsKey(tagArrayElement))
            {
                continue;
            }
            else
            {
                tagsAsSortedList.Add(tagArrayElement, tagArrayElement);
            }
        }
        StringBuilder filteredTagsBuf = new StringBuilder();
        foreach (string tagListElement in tagsAsSortedList.Values)
        {
            filteredTagsBuf.Append(tagListElement);
            filteredTagsBuf.Append(",");
        }
        filteredTagsBuf.Remove(filteredTagsBuf.Length - 1, 1);
        string filteredTags = filteredTagsBuf.ToString();

        // build the command to call a sproc that
        // inserts the pin into the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiAuthorPin";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;

        SqlParameter paramTitle = new SqlParameter();
        paramTitle.ParameterName = "@title";
        paramTitle.SqlDbType = SqlDbType.NVarChar;
        paramTitle.Direction = ParameterDirection.Input;
        paramTitle.Value = title;

        SqlParameter paramMessage = new SqlParameter();
        paramMessage.ParameterName = "@message";
        paramMessage.SqlDbType = SqlDbType.NVarChar;
        paramMessage.Direction = ParameterDirection.Input;
        paramMessage.Value = message;

        SqlParameter paramLatitude = new SqlParameter();
        paramLatitude.ParameterName = "@latitude";
        paramLatitude.SqlDbType = SqlDbType.Float;
        paramLatitude.Direction = ParameterDirection.Input;
        paramLatitude.Value = latitude;

        SqlParameter paramLongitude = new SqlParameter();
        paramLongitude.ParameterName = "@longitude";
        paramLongitude.SqlDbType = SqlDbType.Float;
        paramLongitude.Direction = ParameterDirection.Input;
        paramLongitude.Value = longitude;

        cmd.Parameters.Add(paramUserId);
        cmd.Parameters.Add(paramSecuredServicesValidationToken);
        cmd.Parameters.Add(paramTitle);
        cmd.Parameters.Add(paramMessage);
        cmd.Parameters.Add(paramLatitude);
        cmd.Parameters.Add(paramLongitude);

        if (hasAttachment)
        {
            SqlParameter paramHasAttachment = new SqlParameter();
            paramHasAttachment.ParameterName = "@hasAttachment";
            paramHasAttachment.SqlDbType = SqlDbType.Bit;
            paramHasAttachment.Direction = ParameterDirection.Input;
            paramHasAttachment.Value = 1;
            cmd.Parameters.Add(paramHasAttachment);

            SqlParameter paramAttachment = new SqlParameter();
            paramAttachment.ParameterName = "@attachment";
            paramAttachment.SqlDbType = SqlDbType.Text;
            paramAttachment.Direction = ParameterDirection.Input;
            paramAttachment.Value = attachment;
            cmd.Parameters.Add(paramAttachment);

            SqlParameter paramAttachmentName = new SqlParameter();
            paramAttachmentName.ParameterName = "@attachmentName";
            paramAttachmentName.SqlDbType = SqlDbType.VarChar;
            paramAttachmentName.Direction = ParameterDirection.Input;
            paramAttachmentName.Value = attachmentName;
            cmd.Parameters.Add(paramAttachmentName);

            SqlParameter paramAttachmentType = new SqlParameter();
            paramAttachmentType.ParameterName = "@attachmentType";
            paramAttachmentType.SqlDbType = SqlDbType.VarChar;
            paramAttachmentType.Direction = ParameterDirection.Input;
            paramAttachmentType.Value = attachmentType;
            cmd.Parameters.Add(paramAttachmentType);
        }
        else
        {
            SqlParameter paramHasAttachment = new SqlParameter();
            paramHasAttachment.ParameterName = "@hasAttachment";
            paramHasAttachment.SqlDbType = SqlDbType.Bit;
            paramHasAttachment.Direction = ParameterDirection.Input;
            paramHasAttachment.Value = 0;
            cmd.Parameters.Add(paramHasAttachment);

            SqlParameter paramAttachment = new SqlParameter();
            paramAttachment.ParameterName = "@attachment";
            paramAttachment.SqlDbType = SqlDbType.Text;
            paramAttachment.Direction = ParameterDirection.Input;
            paramAttachment.Value = string.Empty;
            cmd.Parameters.Add(paramAttachment);

            SqlParameter paramAttachmentName = new SqlParameter();
            paramAttachmentName.ParameterName = "@attachmentName";
            paramAttachmentName.SqlDbType = SqlDbType.VarChar;
            paramAttachmentName.Direction = ParameterDirection.Input;
            paramAttachmentName.Value = string.Empty;
            cmd.Parameters.Add(paramAttachmentName);

            SqlParameter paramAttachmentType = new SqlParameter();
            paramAttachmentType.ParameterName = "@attachmentType";
            paramAttachmentType.SqlDbType = SqlDbType.VarChar;
            paramAttachmentType.Direction = ParameterDirection.Input;
            paramAttachmentType.Value = string.Empty;
            cmd.Parameters.Add(paramAttachmentType);
        }

        SqlParameter paramTags = new SqlParameter();
        paramTags.ParameterName = "@tags";
        paramTags.SqlDbType = SqlDbType.NVarChar;
        paramTags.Direction = ParameterDirection.Input;
        paramTags.Value = filteredTags;
        cmd.Parameters.Add(paramTags);

        SqlParameter paramCreateTime = new SqlParameter();
        paramCreateTime.ParameterName = "@createTime";
        paramCreateTime.SqlDbType = SqlDbType.DateTime;
        paramCreateTime.Direction = ParameterDirection.Input;
        paramCreateTime.Value = createTime;
        cmd.Parameters.Add(paramCreateTime);

        SqlParameter paramCreateTimeInDb = new SqlParameter();
        paramCreateTimeInDb.ParameterName = "@createTimeInDb";
        paramCreateTimeInDb.SqlDbType = SqlDbType.DateTime;
        paramCreateTimeInDb.Direction = ParameterDirection.Input;
        paramCreateTimeInDb.Value = DateTime.Now.ToUniversalTime();
        cmd.Parameters.Add(paramCreateTimeInDb);

        // client information stuff here
        SqlParameter paramHostAddress = new SqlParameter();
        paramHostAddress.ParameterName = "@hostAddress";
        paramHostAddress.SqlDbType = SqlDbType.NVarChar;
        paramHostAddress.Direction = ParameterDirection.Input;
        paramHostAddress.Value = ci.HostAddress;
        cmd.Parameters.Add(paramHostAddress);

        SqlParameter paramHostName = new SqlParameter();
        paramHostName.ParameterName = "@hostName";
        paramHostName.SqlDbType = SqlDbType.NVarChar;
        paramHostName.Direction = ParameterDirection.Input;
        paramHostName.Value = ci.HostName;
        cmd.Parameters.Add(paramHostName);

        SqlParameter paramRawUrl = new SqlParameter();
        paramRawUrl.ParameterName = "@rawUrl";
        paramRawUrl.SqlDbType = SqlDbType.NVarChar;
        paramRawUrl.Direction = ParameterDirection.Input;
        paramRawUrl.Value = ci.RawUrl;
        cmd.Parameters.Add(paramRawUrl);

        SqlParameter paramHttpMethod = new SqlParameter();
        paramHttpMethod.ParameterName = "@httpMethod";
        paramHttpMethod.SqlDbType = SqlDbType.NVarChar;
        paramHttpMethod.Direction = ParameterDirection.Input;
        paramHttpMethod.Value = ci.HttpMethod;
        cmd.Parameters.Add(paramHttpMethod);

        SqlParameter paramIsSecureConnection = new SqlParameter();
        paramIsSecureConnection.ParameterName = "@isSecureConnection";
        paramIsSecureConnection.SqlDbType = SqlDbType.TinyInt;
        paramIsSecureConnection.Direction = ParameterDirection.Input;
        paramIsSecureConnection.Value = ci.IsSecureConnection;
        cmd.Parameters.Add(paramIsSecureConnection);

        SqlParameter paramTotalBytes = new SqlParameter();
        paramTotalBytes.ParameterName = "@totalBytes";
        paramTotalBytes.SqlDbType = SqlDbType.Int;
        paramTotalBytes.Direction = ParameterDirection.Input;
        paramTotalBytes.Value = ci.TotalBytes;
        cmd.Parameters.Add(paramTotalBytes);

        SqlParameter paramRawUserAgentStr = new SqlParameter();
        paramRawUserAgentStr.ParameterName = "@rawUserAgentStr";
        paramRawUserAgentStr.SqlDbType = SqlDbType.NVarChar;
        paramRawUserAgentStr.Direction = ParameterDirection.Input;
        paramRawUserAgentStr.Value = ci.RawUserAgentStr;
        cmd.Parameters.Add(paramRawUserAgentStr);

        SqlParameter paramUserAgentStr = new SqlParameter();
        paramUserAgentStr.ParameterName = "@userAgentStr";
        paramUserAgentStr.SqlDbType = SqlDbType.NVarChar;
        paramUserAgentStr.Direction = ParameterDirection.Input;
        paramUserAgentStr.Value = ci.UserAgentStr;
        cmd.Parameters.Add(paramUserAgentStr);

        SqlParameter paramPlatform = new SqlParameter();
        paramPlatform.ParameterName = "@platform";
        paramPlatform.SqlDbType = SqlDbType.NVarChar;
        paramPlatform.Direction = ParameterDirection.Input;
        paramPlatform.Value = ci.Platform;
        cmd.Parameters.Add(paramPlatform);

        SqlParameter paramBrowserMajorVersion = new SqlParameter();
        paramBrowserMajorVersion.ParameterName = "@browserMajorVersion";
        paramBrowserMajorVersion.SqlDbType = SqlDbType.Int;
        paramBrowserMajorVersion.Direction = ParameterDirection.Input;
        paramBrowserMajorVersion.Value = ci.BrowserMajorVersion;
        cmd.Parameters.Add(paramBrowserMajorVersion);

        SqlParameter paramBrowserMinorVersion = new SqlParameter();
        paramBrowserMinorVersion.ParameterName = "@browserMinorVersion";
        paramBrowserMinorVersion.SqlDbType = SqlDbType.Float;
        paramBrowserMinorVersion.Direction = ParameterDirection.Input;
        paramBrowserMinorVersion.Value = ci.BrowserMinorVersion;
        cmd.Parameters.Add(paramBrowserMinorVersion);

        SqlParameter paramMobileDeviceManufacturer = new SqlParameter();
        paramMobileDeviceManufacturer.ParameterName = "@mobileDeviceManufacturer";
        paramMobileDeviceManufacturer.SqlDbType = SqlDbType.NVarChar;
        paramMobileDeviceManufacturer.Direction = ParameterDirection.Input;
        paramMobileDeviceManufacturer.Value = ci.MobileDeviceManufacturer;
        cmd.Parameters.Add(paramMobileDeviceManufacturer);

        SqlParameter paramMobileDeviceModel = new SqlParameter();
        paramMobileDeviceModel.ParameterName = "@mobileDeviceModel";
        paramMobileDeviceModel.SqlDbType = SqlDbType.NVarChar;
        paramMobileDeviceModel.Direction = ParameterDirection.Input;
        paramMobileDeviceModel.Value = ci.MobileDeviceModel;
        cmd.Parameters.Add(paramMobileDeviceModel);
        
        return cmd;
    }

    /// <summary>
    /// Deletes a pin from the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="pinId"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public DeletePinsResponse DeletePin(Credentials credentials, string pinId, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            pinId == null || pinId.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("DeletePin", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // delete the pin
        List<string> pinIds = new List<string>();
        pinIds.Add(pinId);
        return DeletePins(credentials, pinIds, transactionId);
    }

    /// <summary>
    /// Deletes pins from the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="pinIds"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public DeletePinsResponse DeletePins(Credentials credentials, List<string> pinIds, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("DeletePins", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // create a comma separated list of pins to delete
        StringBuilder sb = new StringBuilder();
        foreach (string pin in pinIds)
        {
            sb.Append(pin + ",");
        }

        Debug.WriteLine("Pins to be deleted = " + sb.ToString());

        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            // build the command to call a sproc that
            // deletes the pin from the database
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GpiDeletePins";

            SqlParameter paramUserId = new SqlParameter();
            paramUserId.ParameterName = "@userId";
            paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
            paramUserId.Direction = ParameterDirection.Input;
            paramUserId.Value = new Guid(credentials.UserId);

            SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
            paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
            paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
            paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
            paramSecuredServicesValidationToken.Value = credentials.SecuredServicesValidationToken;

            SqlParameter paramPinIds = new SqlParameter();
            paramPinIds.ParameterName = "@pinIds";
            paramPinIds.SqlDbType = SqlDbType.VarChar;
            paramPinIds.Direction = ParameterDirection.Input;
            paramPinIds.Value = sb.ToString();

            SqlParameter paramRowsDeleted = new SqlParameter();
            paramRowsDeleted.ParameterName = "@rowsDeleted";
            paramRowsDeleted.SqlDbType = SqlDbType.Int;
            paramRowsDeleted.Direction = ParameterDirection.Output;

            cmd.Parameters.Add(paramUserId);
            cmd.Parameters.Add(paramSecuredServicesValidationToken);
            cmd.Parameters.Add(paramPinIds);
            cmd.Parameters.Add(paramRowsDeleted);

            cmd.ExecuteNonQuery();

            int rowsDeleted = (int)cmd.Parameters["@rowsDeleted"].Value;
            DeletePinsResponse deletePinsResponse = new DeletePinsResponse();
            deletePinsResponse.ResponseType = ServerConstants.ResponseType.DeletePins;
            deletePinsResponse.TransactionId = transactionId;
            if (rowsDeleted == 0)
            {
                deletePinsResponse.ResponseCode = ServerReturnCodes.NoPinsDeleted;
            }
            else
            {
                deletePinsResponse.ResponseCode = ServerReturnCodes.DeletedPins;
            }

            return deletePinsResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("DeletePins", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("DeletePins", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotDeletePins, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// This method modifies a pin in the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="inPin"></param>
    /// <param name="attachmentOps"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public ModifyPinResponse ModifyPin(Credentials credentials, PinDetails inPin, List<AttachmentOperation> attachmentOps, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null || credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            inPin == null || inPin.PinId == null || inPin.PinId.Equals(string.Empty) ||
            inPin.Title == null || inPin.Title.Equals(string.Empty) ||
            inPin.Message == null || inPin.Message.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("ModifyPin", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // store pin in database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            DateTime mTime = Convert.ToDateTime(inPin.ModifyTime);
            SqlCommand cmd = null;
            AttachmentOperation attachmentOp = null;
            if (attachmentOps == null || attachmentOps.Count == 0)
            {
                attachmentOp = new AttachmentOperation();
                attachmentOp.AttachmentOperationType = ServerConstants.AttachmentOperationType.None;
            }
            else
            {
                attachmentOp = attachmentOps[0];
            }

            int attachmentOperationTypeAsInt = 0;
            string attachmentId = string.Empty;
            string attachment = string.Empty;
            string attachmentName = string.Empty;
            string attachmentType = string.Empty;
            switch (attachmentOp.AttachmentOperationType)
            {
                case AttachmentOperationType.None:
                    attachmentOperationTypeAsInt = 0;
                    attachmentId = string.Empty;
                    attachment = string.Empty;
                    attachmentName = string.Empty;
                    attachmentType = string.Empty;
                    break;

                case AttachmentOperationType.Add:
                    attachmentOperationTypeAsInt = 1;
                    attachmentId = string.Empty;
                    attachment = attachmentOp.Attachment;
                    attachmentName = attachmentOp.AttachmentName;
                    attachmentType = attachmentOp.AttachmentType;
                    break;

                case AttachmentOperationType.Modify:
                    attachmentOperationTypeAsInt = 2;
                    attachmentId = attachmentOp.AttachmentId;
                    attachment = attachmentOp.Attachment;
                    attachmentName = attachmentOp.AttachmentName;
                    attachmentType = attachmentOp.AttachmentType;
                    break;

                case AttachmentOperationType.Delete:
                    attachmentOperationTypeAsInt = 3;
                    attachmentId = attachmentOp.AttachmentId;
                    attachment = string.Empty;
                    attachmentName = string.Empty;
                    attachmentType = string.Empty;
                    break;
            }

            cmd = this.BuildModifyPinCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken,
                                    inPin.PinId, inPin.Title, inPin.Message, inPin.Latitude, inPin.Longitude, inPin.TagList,
                                    attachmentOperationTypeAsInt, attachmentId, attachment, attachmentName, attachmentType,
                                    mTime);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.SelectCommand = cmd;
            da.Fill(ds);

            if (ds.Tables.Count == 0)
            {
                throw SoapExceptionGenerator.RaiseException("ModifyPin", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotModifyPinMessage, ServerReturnCodes.CannotModifyPin, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            string attachmentIdFromDb = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentId"] != System.DBNull.Value)
            {
                attachmentIdFromDb = (string)ds.Tables[0].Rows[0]["AttachmentId"];
            }
            string attachmentNameFromDb = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentName"] != System.DBNull.Value)
            {
                attachmentNameFromDb = (string)ds.Tables[0].Rows[0]["AttachmentName"];
            }
            string attachmentTypeFromDb = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentType"] != System.DBNull.Value)
            {
                attachmentTypeFromDb = (string)ds.Tables[0].Rows[0]["AttachmentType"];
            }
            string author = (string)ds.Tables[0].Rows[0]["Author"];
            float averageRating = (float)Convert.ToDecimal(ds.Tables[0].Rows[0]["AverageRating"]);
            ulong totalEvaluations = (ulong)Convert.ToUInt64(ds.Tables[0].Rows[0]["TotalEvaluations"]);

            DateTime createTime = (DateTime)ds.Tables[0].Rows[0]["CreateTime"];
            DateTime modifyTime = (DateTime)ds.Tables[0].Rows[0]["ModifyTime"];
            DateTime createTimeInDb = (DateTime)ds.Tables[0].Rows[0]["CreateTimeInDb"];
            DateTime modifyTimeInDb = (DateTime)ds.Tables[0].Rows[0]["ModifyTimeInDb"];

            PinDetails pd = new PinDetails();
            pd.PinId = inPin.PinId;
            pd.Title = inPin.Title;
            pd.Message = inPin.Message;
            pd.Latitude = inPin.Latitude;
            pd.Longitude = inPin.Longitude;
            pd.TagList = inPin.TagList;
            pd.AttachmentId = attachmentIdFromDb;
            pd.AttachmentName = attachmentNameFromDb;
            pd.AttachmentType = attachmentTypeFromDb;
            pd.Author = author;
            pd.TotalEvaluations = totalEvaluations;
            pd.AverageRating = averageRating;
            pd.CreateTime = createTime.ToString();
            pd.ModifyTime = modifyTime.ToString();
            pd.CreateTimeInDb = createTimeInDb.ToString();
            pd.ModifyTimeInDb = modifyTimeInDb.ToString();

            ModifyPinResponse modifyPinResponse = new ModifyPinResponse();
            modifyPinResponse.ResponseType = ResponseType.ModifyPin;
            modifyPinResponse.ResponseCode = ServerReturnCodes.ModifiedPin;
            modifyPinResponse.ResponseObj = pd;
            modifyPinResponse.TransactionId = transactionId;
            
            return modifyPinResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("ModifyPin", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("ModifyPin", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotModifyPin, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// This method modifies a pin in the database 
    /// (Hack to get around the limitation of ksoap not being able to handle enumerations and lists).
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="inPin"></param>
    /// <param name="attachmentOps"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public ModifyPinResponse ModifyPin_ksoapHack(Credentials credentials, PinDetails inPin, AttachmentOperation_ksoapHack attachmentOp_ksoapHack, string transactionId)
    {
        // convert the hacked object into the one that the webservice expects
        // by converting string to enumeration and the single object into a list
        if(attachmentOp_ksoapHack == null)
        {
            return ModifyPin(credentials, inPin, null, transactionId);
        }

        List<AttachmentOperation> attachmentOps = new List<AttachmentOperation>();
        AttachmentOperation aop = new AttachmentOperation();
        attachmentOps.Add(aop);
        aop.AttachmentId = attachmentOp_ksoapHack.AttachmentId;
        aop.AttachmentName = attachmentOp_ksoapHack.AttachmentName;
        aop.Attachment = attachmentOp_ksoapHack.Attachment;
        aop.AttachmentType = attachmentOp_ksoapHack.AttachmentType;
            
        if (attachmentOp_ksoapHack.AttachmentOperationType.Equals("Add"))
        {
            aop.AttachmentOperationType = ServerConstants.AttachmentOperationType.Add;
        }
        else
        {
            if (attachmentOp_ksoapHack.AttachmentOperationType.Equals("Modify"))
            {
                aop.AttachmentOperationType = ServerConstants.AttachmentOperationType.Modify;
            }
            else
            {
                if (attachmentOp_ksoapHack.AttachmentOperationType.Equals("Delete"))
                {
                    aop.AttachmentOperationType = ServerConstants.AttachmentOperationType.Delete;
                }
                else
                {
                    if (attachmentOp_ksoapHack.AttachmentOperationType.Equals("None"))
                    {
                        aop.AttachmentOperationType = ServerConstants.AttachmentOperationType.None;
                    }
                    else
                    {
                        throw SoapExceptionGenerator.RaiseException("ModifyPin", "http://www.gpspostit.com/gpiws_s",
                            ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
                    }
                }
            }
        }

        return ModifyPin(credentials, inPin, attachmentOps, transactionId);
    }

    /// <summary>
    /// Builds the SQL command to modify a pin.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="pinId"></param>
    /// <param name="title"></param>
    /// <param name="message"></param>
    /// <param name="latitude"></param>
    /// <param name="longitude"></param>
    /// <param name="tags"></param>
    /// <param name="attachmentOperationTypeAsInt"></param>
    /// <param name="attachmentId"></param>
    /// <param name="attachment"></param>
    /// <param name="attachmentName"></param>
    /// <param name="attachmentType"></param>
    /// <param name="modifyTime"></param>
    /// <returns></returns>
    private SqlCommand BuildModifyPinCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string pinId, string title, string message, double latitude, double longitude, string tags,
                                                int attachmentOperationTypeAsInt, string attachmentId, string attachment, string attachmentName, string attachmentType, DateTime modifyTime)
    {
        // collapse all multiple spaces in tag list to single space
        // and change spaces to commas
        tags = Regex.Replace(tags, @"\s+", " ");
        tags = Regex.Replace(tags, " ", ",");
        Debug.WriteLine("The massaged tag list = " + tags);

        // build the command to call a sproc that
        // modifies the pin in the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiModifyPin";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;

        SqlParameter paramPinId = new SqlParameter();
        paramPinId.ParameterName = "@pinId";
        paramPinId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramPinId.Direction = ParameterDirection.Input;
        paramPinId.Value = new Guid(pinId);

        SqlParameter paramTitle = new SqlParameter();
        paramTitle.ParameterName = "@title";
        paramTitle.SqlDbType = SqlDbType.NVarChar;
        paramTitle.Direction = ParameterDirection.Input;
        paramTitle.Value = title;

        SqlParameter paramMessage = new SqlParameter();
        paramMessage.ParameterName = "@message";
        paramMessage.SqlDbType = SqlDbType.NVarChar;
        paramMessage.Direction = ParameterDirection.Input;
        paramMessage.Value = message;

        SqlParameter paramLatitude = new SqlParameter();
        paramLatitude.ParameterName = "@latitude";
        paramLatitude.SqlDbType = SqlDbType.Float;
        paramLatitude.Direction = ParameterDirection.Input;
        paramLatitude.Value = latitude;

        SqlParameter paramLongitude = new SqlParameter();
        paramLongitude.ParameterName = "@longitude";
        paramLongitude.SqlDbType = SqlDbType.Float;
        paramLongitude.Direction = ParameterDirection.Input;
        paramLongitude.Value = longitude;

        SqlParameter paramTags = new SqlParameter();
        paramTags.ParameterName = "@tags";
        paramTags.SqlDbType = SqlDbType.NVarChar;
        paramTags.Direction = ParameterDirection.Input;
        paramTags.Value = tags;

        SqlParameter paramAttachmentOperationType = new SqlParameter();
        paramAttachmentOperationType.ParameterName = "@attachmentOperationType";
        paramAttachmentOperationType.SqlDbType = SqlDbType.TinyInt;
        paramAttachmentOperationType.Direction = ParameterDirection.Input;
        paramAttachmentOperationType.Value = attachmentOperationTypeAsInt;

        SqlParameter paramAttachmentId = new SqlParameter();
        paramAttachmentId.ParameterName = "@attachmentId";
        paramAttachmentId.SqlDbType = SqlDbType.VarChar;
        paramAttachmentId.Direction = ParameterDirection.Input;
        paramAttachmentId.Value = attachmentId;

        SqlParameter paramAttachment = new SqlParameter();
        paramAttachment.ParameterName = "@attachment";
        paramAttachment.SqlDbType = SqlDbType.Text;
        paramAttachment.Direction = ParameterDirection.Input;
        paramAttachment.Value = attachment;

        SqlParameter paramAttachmentName = new SqlParameter();
        paramAttachmentName.ParameterName = "@attachmentName";
        paramAttachmentName.SqlDbType = SqlDbType.VarChar;
        paramAttachmentName.Direction = ParameterDirection.Input;
        paramAttachmentName.Value = attachmentName;

        SqlParameter paramAttachmentType = new SqlParameter();
        paramAttachmentType.ParameterName = "@attachmentType";
        paramAttachmentType.SqlDbType = SqlDbType.VarChar;
        paramAttachmentType.Direction = ParameterDirection.Input;
        paramAttachmentType.Value = attachmentType;

        SqlParameter paramRowsChanged = new SqlParameter();
        paramRowsChanged.ParameterName = "@rowsChanged";
        paramRowsChanged.SqlDbType = SqlDbType.Int;
        paramRowsChanged.Direction = ParameterDirection.Output;

        SqlParameter paramModifyTime = new SqlParameter();
        paramModifyTime.ParameterName = "@modifyTime";
        paramModifyTime.SqlDbType = SqlDbType.DateTime;
        paramModifyTime.Direction = ParameterDirection.Input;
        paramModifyTime.Value = modifyTime;

        SqlParameter paramModifyTimeInDb = new SqlParameter();
        paramModifyTimeInDb.ParameterName = "@modifyTimeInDb";
        paramModifyTimeInDb.SqlDbType = SqlDbType.DateTime;
        paramModifyTimeInDb.Direction = ParameterDirection.Input;
        paramModifyTimeInDb.Value = DateTime.Now.ToUniversalTime();

        cmd.Parameters.Add(paramUserId);
        cmd.Parameters.Add(paramSecuredServicesValidationToken);
        cmd.Parameters.Add(paramPinId);
        cmd.Parameters.Add(paramTitle);
        cmd.Parameters.Add(paramMessage);
        cmd.Parameters.Add(paramLatitude);
        cmd.Parameters.Add(paramLongitude);
        cmd.Parameters.Add(paramTags);
        cmd.Parameters.Add(paramAttachmentOperationType);
        cmd.Parameters.Add(paramAttachmentId);
        cmd.Parameters.Add(paramAttachment);
        cmd.Parameters.Add(paramAttachmentName);
        cmd.Parameters.Add(paramAttachmentType);
        cmd.Parameters.Add(paramRowsChanged);
        cmd.Parameters.Add(paramModifyTime);
        cmd.Parameters.Add(paramModifyTimeInDb);

        return cmd;
    }

    /// <summary>
    /// Rates a pin.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="ratingToken"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public RatePinResponse RatePin(Credentials credentials, RatingToken ratingToken, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null || credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            ratingToken == null || ratingToken.NumStars < ServerConstants.RatingBracket.OneStar || ratingToken.NumStars > ServerConstants.RatingBracket.FiveStars ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("RatePin", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, "", SoapExceptionGenerator.FaultCode.Server);
        }

        // store pin in database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            SqlCommand cmd = null;
            cmd = this.BuildRatePinCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken,
                                    ratingToken.EvaluatorId, ratingToken.RatedPinId, ratingToken.NumStars);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.SelectCommand = cmd;
            da.Fill(ds);

            if (ds.Tables.Count == 0)
            {
                throw SoapExceptionGenerator.RaiseException("RatePin", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotRatePinMessage, ServerReturnCodes.CannotRatePin, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            string title = (string)ds.Tables[0].Rows[0]["Title"];
            string message = (string)ds.Tables[0].Rows[0]["Message"];
            double latitude = (double)ds.Tables[0].Rows[0]["Latitude"];
            double longitude = (double)ds.Tables[0].Rows[0]["Longitude"];
            string tagList = (string)ds.Tables[0].Rows[0]["TagList"];

            string attachmentId = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentId"] != System.DBNull.Value)
            {
                attachmentId = (string)ds.Tables[0].Rows[0]["AttachmentId"];
            }
            string attachmentName = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentName"] != System.DBNull.Value)
            {
                attachmentName = (string)ds.Tables[0].Rows[0]["AttachmentName"];
            }
            string attachmentType = string.Empty;
            if (ds.Tables[0].Rows[0]["AttachmentType"] != System.DBNull.Value)
            {
                attachmentType = (string)ds.Tables[0].Rows[0]["AttachmentType"];
            }
            string author = (string)ds.Tables[0].Rows[0]["Author"];
            float averageRating = (float)Convert.ToDecimal(ds.Tables[0].Rows[0]["AverageRating"]);
            ulong totalEvaluations = (ulong)Convert.ToUInt64(ds.Tables[0].Rows[0]["TotalEvaluations"]);
            DateTime createTime = (DateTime)ds.Tables[0].Rows[0]["CreateTime"];
            DateTime modifyTime = (DateTime)ds.Tables[0].Rows[0]["ModifyTime"];
            DateTime createTimeInDb = (DateTime)ds.Tables[0].Rows[0]["CreateTimeInDb"];
            DateTime modifyTimeInDb = (DateTime)ds.Tables[0].Rows[0]["ModifyTimeInDb"];

            PinDetails pd = new PinDetails();
            pd.PinId = ratingToken.RatedPinId;
            pd.Title = title;
            pd.Message = message;
            pd.Latitude = latitude;
            pd.Longitude = longitude;
            pd.TagList = tagList;
            pd.AttachmentId = attachmentId;
            pd.AttachmentName = attachmentName;
            pd.AttachmentType = attachmentType;
            pd.Author = author;
            pd.AverageRating = averageRating;
            pd.TotalEvaluations = totalEvaluations;
            pd.CreateTime = createTime.ToString();
            pd.ModifyTime = modifyTime.ToString();
            pd.CreateTimeInDb = createTimeInDb.ToString();
            pd.ModifyTimeInDb = modifyTimeInDb.ToString();

            RatePinResponse ratePinResponse = new RatePinResponse();
            ratePinResponse.ResponseType = ResponseType.RatePin;
            ratePinResponse.ResponseCode = ServerReturnCodes.RatedPin;
            ratePinResponse.ResponseObj = pd;
            ratePinResponse.TransactionId = transactionId;

            return ratePinResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("RatePin", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("RatePin", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotRatePin, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the command that rates a pin in the database.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="evaluator"></param>
    /// <param name="ratedPinId"></param>
    /// <param name="numStars"></param>
    /// <returns></returns> 
    private SqlCommand BuildRatePinCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string evaluator, string ratedPinId, ushort numStars)
    {
        // build the command to call a sproc that
        // rates the pin
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiRatePin";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;

        SqlParameter paramEvaluator = new SqlParameter();
        paramEvaluator.ParameterName = "@evaluator";
        paramEvaluator.SqlDbType = SqlDbType.UniqueIdentifier;
        paramEvaluator.Direction = ParameterDirection.Input;
        paramEvaluator.Value = new Guid(evaluator);

        SqlParameter paramRatedPinId = new SqlParameter();
        paramRatedPinId.ParameterName = "@ratedPinId";
        paramRatedPinId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramRatedPinId.Direction = ParameterDirection.Input;
        paramRatedPinId.Value = new Guid(ratedPinId);

        SqlParameter paramNumStars = new SqlParameter();
        paramNumStars.ParameterName = "@numStars";
        paramNumStars.SqlDbType = SqlDbType.SmallInt;
        paramNumStars.Direction = ParameterDirection.Input;
        paramNumStars.Value = numStars;

        SqlParameter paramRowsChanged = new SqlParameter();
        paramRowsChanged.ParameterName = "@rowsChanged";
        paramRowsChanged.SqlDbType = SqlDbType.Int;
        paramRowsChanged.Direction = ParameterDirection.Output;

        cmd.Parameters.Add(paramUserId);
        cmd.Parameters.Add(paramSecuredServicesValidationToken);
        cmd.Parameters.Add(paramEvaluator);
        cmd.Parameters.Add(paramRatedPinId);
        cmd.Parameters.Add(paramNumStars);
        cmd.Parameters.Add(paramRowsChanged);

        return cmd;
    }


    /// <summary>
    /// Writes error logs into the database.
    /// </summary>
    /// <param name="errorMessage"></param>
    [WebMethod]
    public void WriteErrorLog(string serviceToken, string errorMessage, string createTime)
    {
        // check arguments
        if (serviceToken == null || serviceToken != ServerConstants.ValidationTokens.GeneralServiceToken 
            || errorMessage == null || errorMessage.Equals(string.Empty))
        {
            return;
        }

        // store pin in database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            // determine client information
            ClientInfo ci = GatherClientInfo();

            SqlCommand cmd = this.BuildWriteErrorLogCommand(conn, errorMessage, createTime, ci);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            ex.HelpLink = string.Empty;

            // eat all errors
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to write an error log.
    /// </summary>
    /// <param name="hasAttachment"></param>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="title"></param>
    /// <param name="message"></param>
    /// <param name="latitude"></param>
    /// <param name="longitude"></param>
    /// <param name="attachment"></param>
    /// <param name="attachmentName"></param>
    /// <param name="attachmentType"></param>
    /// <param name="tags"></param>
    /// <param name="createTime"></param>
    /// <returns></returns>
    private SqlCommand BuildWriteErrorLogCommand(SqlConnection conn, string errorMessage, string createTime, ClientInfo ci)
    {
        // build the command to call a sproc records
        // an error log in the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiWriteErrorLog";

        SqlParameter paramErrorMessage = new SqlParameter();
        paramErrorMessage.ParameterName = "@errorMessage";
        paramErrorMessage.SqlDbType = SqlDbType.NVarChar;
        paramErrorMessage.Direction = ParameterDirection.Input;
        paramErrorMessage.Value = errorMessage;
        cmd.Parameters.Add(paramErrorMessage);

        SqlParameter paramHostAddress = new SqlParameter();
        paramHostAddress.ParameterName = "@hostAddress";
        paramHostAddress.SqlDbType = SqlDbType.NVarChar;
        paramHostAddress.Direction = ParameterDirection.Input;
        paramHostAddress.Value = ci.HostAddress;
        cmd.Parameters.Add(paramHostAddress);

        SqlParameter paramHostName = new SqlParameter();
        paramHostName.ParameterName = "@hostName";
        paramHostName.SqlDbType = SqlDbType.NVarChar;
        paramHostName.Direction = ParameterDirection.Input;
        paramHostName.Value = ci.HostName;
        cmd.Parameters.Add(paramHostName);

        SqlParameter paramRawUrl = new SqlParameter();
        paramRawUrl.ParameterName = "@rawUrl";
        paramRawUrl.SqlDbType = SqlDbType.NVarChar;
        paramRawUrl.Direction = ParameterDirection.Input;
        paramRawUrl.Value = ci.RawUrl;
        cmd.Parameters.Add(paramRawUrl);

        SqlParameter paramHttpMethod = new SqlParameter();
        paramHttpMethod.ParameterName = "@httpMethod";
        paramHttpMethod.SqlDbType = SqlDbType.NVarChar;
        paramHttpMethod.Direction = ParameterDirection.Input;
        paramHttpMethod.Value = ci.HttpMethod;
        cmd.Parameters.Add(paramHttpMethod);

        SqlParameter paramIsSecureConnection = new SqlParameter();
        paramIsSecureConnection.ParameterName = "@isSecureConnection";
        paramIsSecureConnection.SqlDbType = SqlDbType.TinyInt;
        paramIsSecureConnection.Direction = ParameterDirection.Input;
        paramIsSecureConnection.Value = ci.IsSecureConnection;
        cmd.Parameters.Add(paramIsSecureConnection);

        SqlParameter paramTotalBytes = new SqlParameter();
        paramTotalBytes.ParameterName = "@totalBytes";
        paramTotalBytes.SqlDbType = SqlDbType.Int;
        paramTotalBytes.Direction = ParameterDirection.Input;
        paramTotalBytes.Value = ci.TotalBytes;
        cmd.Parameters.Add(paramTotalBytes);

        SqlParameter paramRawUserAgentStr = new SqlParameter();
        paramRawUserAgentStr.ParameterName = "@rawUserAgentStr";
        paramRawUserAgentStr.SqlDbType = SqlDbType.NVarChar;
        paramRawUserAgentStr.Direction = ParameterDirection.Input;
        paramRawUserAgentStr.Value = ci.RawUserAgentStr;
        cmd.Parameters.Add(paramRawUserAgentStr);

        SqlParameter paramUserAgentStr = new SqlParameter();
        paramUserAgentStr.ParameterName = "@userAgentStr";
        paramUserAgentStr.SqlDbType = SqlDbType.NVarChar;
        paramUserAgentStr.Direction = ParameterDirection.Input;
        paramUserAgentStr.Value = ci.UserAgentStr;
        cmd.Parameters.Add(paramUserAgentStr);

        SqlParameter paramPlatform = new SqlParameter();
        paramPlatform.ParameterName = "@platform";
        paramPlatform.SqlDbType = SqlDbType.NVarChar;
        paramPlatform.Direction = ParameterDirection.Input;
        paramPlatform.Value = ci.Platform;
        cmd.Parameters.Add(paramPlatform);

        SqlParameter paramBrowserMajorVersion = new SqlParameter();
        paramBrowserMajorVersion.ParameterName = "@browserMajorVersion";
        paramBrowserMajorVersion.SqlDbType = SqlDbType.Int;
        paramBrowserMajorVersion.Direction = ParameterDirection.Input;
        paramBrowserMajorVersion.Value = ci.BrowserMajorVersion;
        cmd.Parameters.Add(paramBrowserMajorVersion);

        SqlParameter paramBrowserMinorVersion = new SqlParameter();
        paramBrowserMinorVersion.ParameterName = "@browserMinorVersion";
        paramBrowserMinorVersion.SqlDbType = SqlDbType.Float;
        paramBrowserMinorVersion.Direction = ParameterDirection.Input;
        paramBrowserMinorVersion.Value = ci.BrowserMinorVersion;
        cmd.Parameters.Add(paramBrowserMinorVersion);

        SqlParameter paramMobileDeviceManufacturer = new SqlParameter();
        paramMobileDeviceManufacturer.ParameterName = "@mobileDeviceManufacturer";
        paramMobileDeviceManufacturer.SqlDbType = SqlDbType.NVarChar;
        paramMobileDeviceManufacturer.Direction = ParameterDirection.Input;
        paramMobileDeviceManufacturer.Value = ci.MobileDeviceManufacturer;
        cmd.Parameters.Add(paramMobileDeviceManufacturer);

        SqlParameter paramMobileDeviceModel = new SqlParameter();
        paramMobileDeviceModel.ParameterName = "@mobileDeviceModel";
        paramMobileDeviceModel.SqlDbType = SqlDbType.NVarChar;
        paramMobileDeviceModel.Direction = ParameterDirection.Input;
        paramMobileDeviceModel.Value = ci.MobileDeviceModel;
        cmd.Parameters.Add(paramMobileDeviceModel);

        SqlParameter paramCreateTime = new SqlParameter();
        paramCreateTime.ParameterName = "@createTime";
        paramCreateTime.SqlDbType = SqlDbType.DateTime;
        paramCreateTime.Direction = ParameterDirection.Input;
        paramCreateTime.Value = createTime;
        cmd.Parameters.Add(paramCreateTime);

        SqlParameter paramCreateTimeInDb = new SqlParameter();
        paramCreateTimeInDb.ParameterName = "@createTimeInDb";
        paramCreateTimeInDb.SqlDbType = SqlDbType.DateTime;
        paramCreateTimeInDb.Direction = ParameterDirection.Input;
        paramCreateTimeInDb.Value = DateTime.Now.ToUniversalTime();
        cmd.Parameters.Add(paramCreateTimeInDb);

        return cmd;
    }

    /// <summary>
    /// Gathers client information.
    /// </summary>
    /// <returns></returns>
    private ClientInfo GatherClientInfo()
    {
        ClientInfo ci = new ClientInfo();

        ci.HostAddress = HttpContext.Current.Request.UserHostAddress;
        ci.HostName = HttpContext.Current.Request.UserHostName;

        ci.RawUrl = HttpContext.Current.Request.RawUrl;
        ci.HttpMethod = HttpContext.Current.Request.HttpMethod;
        ci.IsSecureConnection = HttpContext.Current.Request.IsSecureConnection;
        ci.TotalBytes = HttpContext.Current.Request.TotalBytes;
        ci.RawUserAgentStr = HttpContext.Current.Request.UserAgent;

        ci.UserAgentStr = HttpContext.Current.Request.Browser.Browser;
        ci.Platform = HttpContext.Current.Request.Browser.Platform;
        ci.BrowserMajorVersion = HttpContext.Current.Request.Browser.MajorVersion;
        ci.BrowserMinorVersion = HttpContext.Current.Request.Browser.MinorVersion;
        ci.MobileDeviceManufacturer = HttpContext.Current.Request.Browser.MobileDeviceManufacturer;
        ci.MobileDeviceModel = HttpContext.Current.Request.Browser.MobileDeviceModel;

        return ci;
    }


    /// <summary>
    /// This method adds a group to the database for a particular user.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="name"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public CreateGroupResponse CreateGroup(Credentials credentials, string name, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            name == null || name.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("CreateGroup", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // create group
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();
            SqlCommand cmd = this.BuildCreateGroupCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken, name);
            int numRowsAffected = cmd.ExecuteNonQuery();
            if (numRowsAffected == 0)
            {
                throw SoapExceptionGenerator.RaiseException("CreateGroup", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotCreateGroupMessage, ServerReturnCodes.CannotCreateGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            CreateGroupResponse createGroupResponse = new CreateGroupResponse();
            createGroupResponse.ResponseType = ResponseType.CreateGroup;
            createGroupResponse.ResponseCode = ServerReturnCodes.CreatedGroup;
            createGroupResponse.TransactionId = transactionId;
            return createGroupResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("CreateGroup", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("CreateGroup", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotCreateGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to create a group.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    private SqlCommand BuildCreateGroupCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string name)
    {
        // build the command to call a sproc that
        // creates a group in the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiCreateGroup";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;
        cmd.Parameters.Add(paramSecuredServicesValidationToken);

        SqlParameter paramName = new SqlParameter();
        paramName.ParameterName = "@name";
        paramName.SqlDbType = SqlDbType.NVarChar;
        paramName.Direction = ParameterDirection.Input;
        paramName.Value = name;
        cmd.Parameters.Add(paramName);

        return cmd;
    }

    /// <summary>
    /// This method adds a user to a group.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="userName"></param>
    /// <param name="groupName"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public AddUserToGroupResponse AddUserToGroup(Credentials credentials, string userName, string groupName, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            userName == null || userName.Equals(string.Empty) ||
            groupName == null || groupName.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("AddUserToGroup", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // add user to group
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();
            SqlCommand cmd = this.BuildAddUserToGroupCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken, userName, groupName);
            int numRowsAffected = cmd.ExecuteNonQuery();
            if (numRowsAffected == 0)
            {
                throw SoapExceptionGenerator.RaiseException("AddUserToGroup", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotAddUserToGroupMessage, ServerReturnCodes.CannotAddUserToGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            AddUserToGroupResponse addUserToGroupResponse = new AddUserToGroupResponse();
            addUserToGroupResponse.ResponseType = ResponseType.AddUserToGroup;
            addUserToGroupResponse.ResponseCode = ServerReturnCodes.AddedUserToGroup;
            addUserToGroupResponse.TransactionId = transactionId;
            return addUserToGroupResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("AddUserToGroup", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("AddUserToGroup", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotAddUserToGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to add an user to group.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="userName"></param>
    /// <param name="groupName"></param>
    /// <returns></returns>
    private SqlCommand BuildAddUserToGroupCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string userName, string groupName)
    {
        // build the command to call a sproc that
        // adds a user to a group in the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiAddUserToGroup";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@creator";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;
        cmd.Parameters.Add(paramSecuredServicesValidationToken);

        SqlParameter paramUserName = new SqlParameter();
        paramUserName.ParameterName = "@userName";
        paramUserName.SqlDbType = SqlDbType.NVarChar;
        paramUserName.Direction = ParameterDirection.Input;
        paramUserName.Value = userName;
        cmd.Parameters.Add(paramUserName);

        SqlParameter paramGroupName = new SqlParameter();
        paramGroupName.ParameterName = "@groupName";
        paramGroupName.SqlDbType = SqlDbType.NVarChar;
        paramGroupName.Direction = ParameterDirection.Input;
        paramGroupName.Value = groupName;
        cmd.Parameters.Add(paramGroupName);

        return cmd;
    }

    /// <summary>
    /// This method removes a user from a group.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="userName"></param>
    /// <param name="groupName"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public RemoveUserFromGroupResponse RemoveUserFromGroup(Credentials credentials, string userName, string groupName, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            userName == null || userName.Equals(string.Empty) ||
            groupName == null || groupName.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("RemoveUserFromGroup", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // remove user from group
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();
            SqlCommand cmd = this.BuildRemoveUserFromGroupCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken, userName, groupName);
            int numRowsAffected = cmd.ExecuteNonQuery();
            if (numRowsAffected == 0)
            {
                throw SoapExceptionGenerator.RaiseException("RemoveUserFromGroup", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotRemoveUserFromGroupMessage, ServerReturnCodes.CannotRemoveUserFromGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            RemoveUserFromGroupResponse removeUserFromGroupResponse = new RemoveUserFromGroupResponse();
            removeUserFromGroupResponse.ResponseType = ResponseType.RemoveUserFromGroup;
            removeUserFromGroupResponse.ResponseCode = ServerReturnCodes.RemovedUserFromGroup;
            removeUserFromGroupResponse.TransactionId = transactionId;
            return removeUserFromGroupResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("RemoveUserFromGroup", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("RemoveUserFromGroup", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotRemoveUserFromGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to remove a user from a group.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="userName"></param>
    /// <param name="groupName"></param>
    /// <returns></returns>
    private SqlCommand BuildRemoveUserFromGroupCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string userName, string groupName)
    {
        // build the command to call a sproc that
        // removes a user from a group in the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiRemoveUserFromGroup";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@creator";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;
        cmd.Parameters.Add(paramSecuredServicesValidationToken);

        SqlParameter paramUserName = new SqlParameter();
        paramUserName.ParameterName = "@userName";
        paramUserName.SqlDbType = SqlDbType.NVarChar;
        paramUserName.Direction = ParameterDirection.Input;
        paramUserName.Value = userName;
        cmd.Parameters.Add(paramUserName);

        SqlParameter paramGroupName = new SqlParameter();
        paramGroupName.ParameterName = "@groupName";
        paramGroupName.SqlDbType = SqlDbType.NVarChar;
        paramGroupName.Direction = ParameterDirection.Input;
        paramGroupName.Value = groupName;
        cmd.Parameters.Add(paramGroupName);

        return cmd;
    }

    /// <summary>
    /// This method removes a group from the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="name"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    public RemoveGroupResponse RemoveGroup(Credentials credentials, string name, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.SecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.SecuredServicesValidationToken.Equals(string.Empty) ||
            name == null || name.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("RemoveGroup", "http://www.gpspostit.com/gpiws_s",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // remove group
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();
            SqlCommand cmd = this.BuildRemoveGroupCommand(conn, credentials.UserId, credentials.SecuredServicesValidationToken, name);
            int numRowsAffected = cmd.ExecuteNonQuery();
            if (numRowsAffected == 0)
            {
                throw SoapExceptionGenerator.RaiseException("RemoveGroup", "http://www.gpspostit.com/gpiws_s",
                    ServerReturnMessages.CannotRemoveGroupMessage, ServerReturnCodes.CannotRemoveGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
            }

            RemoveGroupResponse removeGroupResponse = new RemoveGroupResponse();
            removeGroupResponse.ResponseType = ResponseType.RemoveGroup;
            removeGroupResponse.ResponseCode = ServerReturnCodes.RemovedGroup;
            removeGroupResponse.TransactionId = transactionId;
            return removeGroupResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("RemoveGroup", "http://www.gpspostit.com/gpiws_s",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("RemoveGroup", "http://www.gpspostit.com/gpiws_s",
                ex2.Message, ServerReturnCodes.CannotRemoveGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    /// <summary>
    /// Builds the SQL command to remove a group.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="securedServicesValidationToken"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    private SqlCommand BuildRemoveGroupCommand(SqlConnection conn, string userId, string securedServicesValidationToken, string name)
    {
        // build the command to call a sproc that
        // removes a group from the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiRemoveGroup";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramSecuredServicesValidationToken = new SqlParameter();
        paramSecuredServicesValidationToken.ParameterName = "@securedServicesValidationToken";
        paramSecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramSecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramSecuredServicesValidationToken.Value = securedServicesValidationToken;
        cmd.Parameters.Add(paramSecuredServicesValidationToken);

        SqlParameter paramName = new SqlParameter();
        paramName.ParameterName = "@name";
        paramName.SqlDbType = SqlDbType.NVarChar;
        paramName.Direction = ParameterDirection.Input;
        paramName.Value = name;
        cmd.Parameters.Add(paramName);

        return cmd;
    }
}