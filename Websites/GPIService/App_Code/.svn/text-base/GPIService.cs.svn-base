using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.Reflection;
using Topography;
using ServerConstants;


/// <summary>
/// "Open" web service.
/// </summary>
[WebService(Namespace = "http://www.gpspostit.com/gpiws/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class GPIService : System.Web.Services.WebService
{
    private readonly string connectionString = string.Empty;
 
    public GPIService () 
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent();
        this.connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["GpiDbConnectionString"].ToString();
    }


    [WebMethod]
    [XmlInclude(typeof(TagDetails))]
    public GetTagsResponse GetTags(Credentials credentials, BasicFilter filter, string transactionId )
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.UnsecuredServicesValidationToken == null || credentials.UnsecuredServicesValidationToken.Equals(string.Empty) ||
            filter == null ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetTags", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        List<TagDetails> details = new List<TagDetails>();

        // build the command to get pins
        SqlConnection conn = new SqlConnection(connectionString);

        SqlCommand cmd = this.BuildGetTagsCommand(conn, credentials.UserId, credentials.UnsecuredServicesValidationToken,
                                                    filter.Latitude, filter.Longitude, filter.Range);

        try
        {
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                string tagName = reader.GetGuid(reader.GetOrdinal("TagName")).ToString();
                int pinCount = reader.GetInt32(reader.GetOrdinal("PinCount"));

                TagDetails td = new TagDetails();
                td.TagName = HttpUtility.HtmlEncode( tagName );
                td.PinCount = pinCount;
                details.Add(td);
            }

            GetTagsResponse getTagsResponse = new GetTagsResponse();
            getTagsResponse.ResponseType = ServerConstants.ResponseType.GetTags;
            getTagsResponse.ResponseCode = ServerReturnCodes.GotTags;
            getTagsResponse.ResponseObj = details;
            getTagsResponse.TransactionId = transactionId;

            return getTagsResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("GetTags", "http://www.gpspostit.com/gpiws",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("GetTags", "http://www.gpspostit.com/gpiws",
                ex2.Message, ServerReturnCodes.CannotGetPins, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }

    private SqlCommand BuildGetTagsCommand(SqlConnection conn, string userId, string unsecuredServicesValidationToken,
                                                  double latitude, double longitude, double range)
    {
   
        // build the command to call a sproc that
        // gets pins from the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiGetTags";

        //SqlParameter paramLatitude = new SqlParameter();
        //paramLatitude.ParameterName = "@latitude";
        //paramLatitude.SqlDbType = SqlDbType.Float;
        //paramLatitude.Direction = ParameterDirection.Input;
        //paramLatitude.Value = latitude;

        //SqlParameter paramLongitude = new SqlParameter();
        //paramLongitude.ParameterName = "@longitude";
        //paramLongitude.SqlDbType = SqlDbType.Float;
        //paramLongitude.Direction = ParameterDirection.Input;
        //paramLongitude.Value = longitude;

        //SqlParameter paramRange = new SqlParameter();
        //paramRange.ParameterName = "@range";
        //paramRange.SqlDbType = SqlDbType.Float;
        //paramRange.Direction = ParameterDirection.Input;
        //paramRange.Value = range;

        //cmd.Parameters.Add(paramUserId);
        //cmd.Parameters.Add(paramUnsecuredServicesValidationToken);
        //cmd.Parameters.Add(paramLatitude);
        //cmd.Parameters.Add(paramLongitude);
        //cmd.Parameters.Add(paramRange);

        return cmd;
    }

    /// <summary>
    /// Gets pins and their details from the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="filter"></param>
    /// <param name="pinOrderDisposition"></param>
    /// <param name="pager"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(PinDetails))]
    public GetPinsExResponse GetPinsEx(Credentials credentials, BasicFilter filter,
                                        ServerConstants.PinOrderDisposition pinOrderDisposition, BasicPager pager, string transactionId)
    {
        return GetPinsExWithValidationOption(credentials, filter, pinOrderDisposition, pager, transactionId, true);
    }

    /// <summary>
    /// Gets pins and their details from the database.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="filter"></param>
    /// <param name="pinOrderDisposition"></param>
    /// <param name="pager"></param>
    /// <param name="transactionId"></param>
    /// <param name="validateUser"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(PinDetails))]
    public GetPinsExResponse GetPinsExWithValidationOption(Credentials credentials, BasicFilter filter, 
                                        ServerConstants.PinOrderDisposition pinOrderDisposition, BasicPager pager, string transactionId, bool validateUser)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.UnsecuredServicesValidationToken == null || credentials.UnsecuredServicesValidationToken.Equals(string.Empty) ||
            filter == null ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetPinsEx", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // retrieve pins from the database        
        // the list that will hold the returned data
        List<PinDetails> details = new List<PinDetails>();

        // build the command to get pins
        SqlConnection conn = new SqlConnection(connectionString);

        // determine time interval filter params
        DateTime startTime = DateTime.Now;
        DateTime endTime = DateTime.Now;
        ushort toBeginningOfWeek = 0;
        switch (startTime.DayOfWeek)
        {
            case DayOfWeek.Monday:
                toBeginningOfWeek = 0;
                break;

            case DayOfWeek.Tuesday:
                toBeginningOfWeek = 1;
                break;

            case DayOfWeek.Wednesday:
                toBeginningOfWeek = 2;
                break;

            case DayOfWeek.Thursday:
                toBeginningOfWeek = 3;
                break;

            case DayOfWeek.Friday:
                toBeginningOfWeek = 4;
                break;

            case DayOfWeek.Saturday:
                toBeginningOfWeek = 5;
                break;

            case DayOfWeek.Sunday:
                toBeginningOfWeek = 6;
                break;
        }

        switch (filter.IntervalType)
        {
            case IntervalType.None:
                startTime = ServerConstants.DateTimeConstants.LongTimeAgo;
                endTime = DateTime.Now;
                break;

            case IntervalType.Today:
                startTime = new DateTime(startTime.Year, startTime.Month, startTime.Day, 0, 0, 0);
                endTime = DateTime.Now;
                break;

            case IntervalType.PastTwoDays:
                startTime = new DateTime(startTime.Year, startTime.Month, startTime.Day, 0, 0, 0).AddDays(-1);
                endTime = DateTime.Now;
                break;

            case IntervalType.ThisWeek:
                startTime = new DateTime(startTime.Year, startTime.Month, startTime.Day, 0, 0, 0).AddDays(-1 * toBeginningOfWeek);
                endTime = DateTime.Now;
                break;

            case IntervalType.PastTwoWeeks:
                startTime = new DateTime(startTime.Year, startTime.Month, startTime.Day, 0, 0, 0).AddDays(-1 * toBeginningOfWeek).AddDays(-7);
                endTime = DateTime.Now;
                break;

            case IntervalType.CustomInterval:
                startTime = filter.StartTime;
                endTime = filter.EndTime;
                break;
        }

        // determine ordering of pins
        ushort pinOrderDispositionOrdinal = 0;
        switch (pinOrderDisposition)
        {
            case PinOrderDisposition.HighestRated:
                pinOrderDispositionOrdinal = 0;
                break;

            case PinOrderDisposition.MostRecent:
                pinOrderDispositionOrdinal = 1;
                break;

            default:
                pinOrderDispositionOrdinal = 1;
                break;
        }

        // determine paging params
        if (pager == null)
        {
            // default to all pins

            pager = new BasicPager();
            pager.StartPosition = 1;
            pager.PageSize = ServerConstants.PagingConstants.Greedy;
            pager.PagingDirection = PagingDirection.Forward;
        }

        SqlCommand cmd = this.BuildGetPinsExCommand(conn, credentials.UserId, credentials.UnsecuredServicesValidationToken, 
                                                    filter.Latitude, filter.Longitude, filter.Range, 
                                                    filter.Tags.ToLower(),
                                                    startTime, endTime, pager.StartPosition, pager.PageSize, pager.PagingDirection,
                                                    pinOrderDispositionOrdinal, validateUser);
        try
        {
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            
            while (reader.Read())
            {
                string pinId = reader.GetGuid(reader.GetOrdinal("PinId")).ToString();
                ulong pinNumber = (ulong)reader.GetInt64(reader.GetOrdinal("PinNumber"));
                double latitudeFromDb = reader.GetDouble(reader.GetOrdinal("Latitude"));
                double longitudeFromDb = reader.GetDouble(reader.GetOrdinal("Longitude"));
                string title = reader.GetString(reader.GetOrdinal("Title"));
                string message = reader.GetString(reader.GetOrdinal("Message"));
                string attachment = string.Empty;
                //if (!reader.IsDBNull(reader.GetOrdinal("Attachment")))
                //{
                //    attachment = reader.GetString(reader.GetOrdinal("Attachment"));
                //}
                string attachmentName = string.Empty;
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentName")))
                {
                    attachmentName = reader.GetString(reader.GetOrdinal("AttachmentName"));
                }
                string attachmentType = string.Empty;
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentType")))
                {
                    attachmentType = reader.GetString(reader.GetOrdinal("AttachmentType"));
                }
                string attachmentId = string.Empty;
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentId")))
                {
                    attachmentId = reader.GetString(reader.GetOrdinal("AttachmentId"));
                }
                string author = string.Empty;
                if (!reader.IsDBNull(reader.GetOrdinal("Author")))
                {
                    author = reader.GetString(reader.GetOrdinal("Author"));
                }
                string tagList = reader.GetString(reader.GetOrdinal("TagList"));
                float averageRating = (float)reader.GetDecimal(reader.GetOrdinal("AverageRating"));
                ulong totalEvaluations = (ulong)reader.GetInt64(reader.GetOrdinal("TotalEvaluations"));
                DateTime createTimeFromDb = reader.GetDateTime(reader.GetOrdinal("CreateTime"));
                DateTime modifyTimeFromDb = reader.GetDateTime(reader.GetOrdinal("ModifyTime"));
                DateTime createTimeInDbFromDb = reader.GetDateTime(reader.GetOrdinal("CreateTimeInDb"));
                DateTime modifyTimeInDbFromDb = reader.GetDateTime(reader.GetOrdinal("ModifyTimeInDb"));
                ulong totalPinCount = (ulong)reader.GetInt64(reader.GetOrdinal("TotalPinCount"));

                PinDetails pd = new PinDetails();
                pd.PinId = pinId;
                pd.PinNumber = pinNumber;
                pd.Title = HttpUtility.HtmlEncode(title);
                pd.Message = HttpUtility.HtmlEncode(message);
                pd.Latitude = latitudeFromDb;
                pd.Longitude = longitudeFromDb;
                pd.TagList = HttpUtility.HtmlEncode(tagList);
                pd.AttachmentId = attachmentId;
                pd.AttachmentName = HttpUtility.HtmlEncode(attachmentName);
                pd.AttachmentType = attachmentType;
                pd.Author = HttpUtility.HtmlEncode(author);
                pd.TotalEvaluations = totalEvaluations;
                pd.AverageRating = averageRating;
                pd.CreateTime = createTimeFromDb.ToString();
                pd.ModifyTime = modifyTimeFromDb.ToString();
                pd.CreateTimeInDb = createTimeInDbFromDb.ToString();
                pd.ModifyTimeInDb = modifyTimeInDbFromDb.ToString();
                pd.TotalPinCount = totalPinCount;
                details.Add(pd);
            }

            GetPinsExResponse getPinsExResponse = new GetPinsExResponse();
            getPinsExResponse.ResponseType = ServerConstants.ResponseType.GetPinsEx;
            getPinsExResponse.ResponseCode = ServerReturnCodes.GotPins;
            getPinsExResponse.ResponseObj = details;
            getPinsExResponse.TransactionId = transactionId;
      
            return getPinsExResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("GetPinsEx", "http://www.gpspostit.com/gpiws",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("GetPinsEx", "http://www.gpspostit.com/gpiws",
                ex2.Message, ServerReturnCodes.CannotGetPins, transactionId, SoapExceptionGenerator.FaultCode.Server);
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
    /// Builds a SQL command to fetch pins from the database.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="unsecuredServicesValidationToken"></param>
    /// <param name="latitude"></param>
    /// <param name="longitude"></param>
    /// <param name="range"></param>
    /// <param name="tags"></param>
    /// <returns></returns>
    private SqlCommand BuildGetPinsExCommand(SqlConnection conn, string userId, string unsecuredServicesValidationToken, 
                                                double latitude, double longitude, double range,
                                                string tags,
                                                DateTime startTime, DateTime endTime, ulong pagerStartPosition, ushort pageSize, PagingDirection pagingDirection, 
                                                ushort pinOrderDispositionOrdinal, bool validateUser)
    {
        // collapse all multiple spaces in tag list to single space
        // and change spaces to commas
        tags = Regex.Replace(tags, @"\s+", " ");
        tags = Regex.Replace(tags, " ", ",");
        Debug.WriteLine("The massaged tag list = " + tags);

        // if user did not specify any tags, assume that he/she wants all tags
        if (tags.Equals(string.Empty))
        {
            tags = ServerConstants.TagConstants.AnyTag;
        }

        // build the command to call a sproc that
        // gets pins from the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiGetPins";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        if (validateUser)
        {
            paramUserId.Value = new Guid(userId);
        }
        else
        {
            paramUserId.Value = Guid.Empty;
        }

        SqlParameter paramUnsecuredServicesValidationToken = new SqlParameter();
        paramUnsecuredServicesValidationToken.ParameterName = "@unsecuredServicesValidationToken";
        paramUnsecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramUnsecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramUnsecuredServicesValidationToken.Value = unsecuredServicesValidationToken;

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

        SqlParameter paramRange = new SqlParameter();
        paramRange.ParameterName = "@range";
        paramRange.SqlDbType = SqlDbType.Float;
        paramRange.Direction = ParameterDirection.Input;
        paramRange.Value = range;

        SqlParameter paramStartTime = new SqlParameter();
        paramStartTime.ParameterName = "@startTime";
        paramStartTime.SqlDbType = SqlDbType.DateTime;
        paramStartTime.Direction = ParameterDirection.Input;
        paramStartTime.Value = startTime.ToUniversalTime();

        SqlParameter paramEndTime = new SqlParameter();
        paramEndTime.ParameterName = "@endTime";
        paramEndTime.SqlDbType = SqlDbType.DateTime;
        paramEndTime.Direction = ParameterDirection.Input;
        paramEndTime.Value = endTime.ToUniversalTime();

        SqlParameter paramTags = new SqlParameter();
        paramTags.ParameterName = "@tags";
        paramTags.SqlDbType = SqlDbType.NVarChar;
        paramTags.Direction = ParameterDirection.Input;
        paramTags.Value = tags;

        SqlParameter paramPagerStartPosition = new SqlParameter();
        paramPagerStartPosition.ParameterName = "@pagerStartPosition";
        paramPagerStartPosition.SqlDbType = SqlDbType.BigInt;
        paramPagerStartPosition.Direction = ParameterDirection.Input;
        paramPagerStartPosition.Value = pagerStartPosition;

        SqlParameter paramPageSize = new SqlParameter();
        paramPageSize.ParameterName = "@pageSize";
        paramPageSize.SqlDbType = SqlDbType.SmallInt;
        paramPageSize.Direction = ParameterDirection.Input;
        paramPageSize.Value = pageSize;

        ushort pagingDirectionAsInt = 0;
        switch (pagingDirection)
        {
            case PagingDirection.Forward:
                pagingDirectionAsInt = 0;
                break;
            
            case PagingDirection.Reverse:
                pagingDirectionAsInt = 1;
                break;
        }

        SqlParameter paramPagingDirection = new SqlParameter();
        paramPagingDirection.ParameterName = "@pagingDirection";
        paramPagingDirection.SqlDbType = SqlDbType.SmallInt;
        paramPagingDirection.Direction = ParameterDirection.Input;
        paramPagingDirection.Value = pagingDirectionAsInt;

        SqlParameter paramPinOrderDisposition = new SqlParameter();
        paramPinOrderDisposition.ParameterName = "@pinOrder";
        paramPinOrderDisposition.SqlDbType = SqlDbType.SmallInt;
        paramPinOrderDisposition.Direction = ParameterDirection.Input;
        paramPinOrderDisposition.Value = pinOrderDispositionOrdinal;

        SqlParameter paramValidateUser = new SqlParameter();
        paramValidateUser.ParameterName = "@validateUser";
        paramValidateUser.SqlDbType = SqlDbType.TinyInt;
        paramValidateUser.Direction = ParameterDirection.Input;
        paramValidateUser.Value = validateUser? 1 : 0;

        cmd.Parameters.Add(paramUserId);
        cmd.Parameters.Add(paramUnsecuredServicesValidationToken);
        cmd.Parameters.Add(paramLatitude);
        cmd.Parameters.Add(paramLongitude);
        cmd.Parameters.Add(paramRange);
        cmd.Parameters.Add(paramTags);
        cmd.Parameters.Add(paramStartTime);
        cmd.Parameters.Add(paramEndTime);
        cmd.Parameters.Add(paramPagerStartPosition);
        cmd.Parameters.Add(paramPageSize);
        cmd.Parameters.Add(paramPagingDirection);
        cmd.Parameters.Add(paramPinOrderDisposition);
        cmd.Parameters.Add(paramValidateUser);

        return cmd;
    }

    /// <summary>
    /// Gets attachment from the pin.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="pinId"></param>
    /// <param name="attachmentId"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(PinDetails))]
    public GetAttachmentResponse GetAttachment(Credentials credentials, string pinId, string attachmentId, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.UnsecuredServicesValidationToken == null || credentials.UnsecuredServicesValidationToken.Equals(string.Empty) ||
            pinId == null || pinId.Equals(string.Empty) ||
            attachmentId == null || attachmentId.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetAttachment", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // the structure that will hold the return data
        PinDetails pd = null;

        // get pin attachment from database
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            conn.Open();

            // build the command to call a sproc that
            // gets the pin attachments from the database
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GpiGetAttachment";

            SqlParameter paramUserId = new SqlParameter();
            paramUserId.ParameterName = "@userId";
            paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
            paramUserId.Direction = ParameterDirection.Input;
            paramUserId.Value = new Guid(credentials.UserId);

            SqlParameter paramUnsecuredServicesValidationToken = new SqlParameter();
            paramUnsecuredServicesValidationToken.ParameterName = "@unsecuredServicesValidationToken";
            paramUnsecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
            paramUnsecuredServicesValidationToken.Direction = ParameterDirection.Input;
            paramUnsecuredServicesValidationToken.Value = credentials.UnsecuredServicesValidationToken;

            SqlParameter paramPinId = new SqlParameter();
            paramPinId.ParameterName = "@pinId";
            paramPinId.SqlDbType = SqlDbType.UniqueIdentifier;
            paramPinId.Direction = ParameterDirection.Input;
            paramPinId.Value = new Guid(pinId);

            SqlParameter paramAttachmentId = new SqlParameter();
            paramAttachmentId.ParameterName = "@attachmentId";
            paramAttachmentId.SqlDbType = SqlDbType.VarChar;
            paramAttachmentId.Direction = ParameterDirection.Input;
            paramAttachmentId.Value = attachmentId;

            cmd.Parameters.Add(paramUserId);
            cmd.Parameters.Add(paramUnsecuredServicesValidationToken);
            cmd.Parameters.Add(paramPinId);
            cmd.Parameters.Add(paramAttachmentId);
            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            while (reader.Read())
            {
                pd = new PinDetails();
                string attachment = string.Empty;
                string attachmentName = string.Empty;
                string attachmentType = string.Empty;
                string attachmentIdFromDb = string.Empty;
                if (!reader.IsDBNull(reader.GetOrdinal("Attachment")))
                {
                    attachment = reader.GetString(reader.GetOrdinal("Attachment"));
                }
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentName")))
                {
                    attachmentName = reader.GetString(reader.GetOrdinal("AttachmentName"));
                }
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentType")))
                {
                    attachmentType = reader.GetString(reader.GetOrdinal("AttachmentType"));
                }
                if (!reader.IsDBNull(reader.GetOrdinal("AttachmentId")))
                {
                    attachmentIdFromDb = reader.GetString(reader.GetOrdinal("AttachmentId"));
                }
                pd.PinId = pinId.ToString();
                pd.Title = string.Empty;
                pd.Message = string.Empty;
                pd.Latitude = 0;
                pd.Longitude = 0;
                pd.TagList = string.Empty;
                pd.Attachment = attachment;
                pd.AttachmentName = attachmentName;
                pd.AttachmentType = attachmentType;
                pd.AttachmentId = attachmentIdFromDb;
            }

            GetAttachmentResponse getAttachmentResponse = new GetAttachmentResponse();
            getAttachmentResponse.ResponseType = ServerConstants.ResponseType.GetAttachment;
            getAttachmentResponse.ResponseCode = ServerReturnCodes.GotAttachment;
            getAttachmentResponse.ResponseObj = pd;
            getAttachmentResponse.TransactionId = transactionId;

            return getAttachmentResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("GetAttachment", "http://www.gpspostit.com/gpiws",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("GetAttachment", "http://www.gpspostit.com/gpiws",
                ex2.Message, ServerReturnCodes.CannotGetAttachment, transactionId, SoapExceptionGenerator.FaultCode.Server);
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
    /// This method gets all groups for a particular user.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(GroupDetails))]
    public GetGroupsResponse GetGroups(Credentials credentials, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.UnsecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.UnsecuredServicesValidationToken.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetGroups", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // get groups
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            // the list that will hold the returned data
            List<GroupDetails> details = new List<GroupDetails>();

            conn.Open();
            SqlCommand cmd = this.BuildGetGroupsCommand(conn, credentials.UserId, credentials.UnsecuredServicesValidationToken);
            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                string name = reader.GetString(reader.GetOrdinal("Name"));

                GroupDetails gd = new GroupDetails();
                gd.Name = HttpUtility.HtmlEncode(name);
                details.Add(gd);
            }

            GetGroupsResponse getGroupsResponse = new GetGroupsResponse();
            getGroupsResponse.ResponseType = ResponseType.GetGroups;
            getGroupsResponse.ResponseCode = ServerReturnCodes.GotGroups;
            getGroupsResponse.ResponseObj = details;
            getGroupsResponse.TransactionId = transactionId;
            return getGroupsResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("GetGroups", "http://www.gpspostit.com/gpiws",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("GetGroups", "http://www.gpspostit.com/gpiws",
                ex2.Message, ServerReturnCodes.CannotGetGroups, transactionId, SoapExceptionGenerator.FaultCode.Server);
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
    /// Builds the SQL command to get groups.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="unsecuredServicesValidationToken"></param>
    /// <returns></returns>
    private SqlCommand BuildGetGroupsCommand(SqlConnection conn, string userId, string unsecuredServicesValidationToken)
    {
        // build the command to call a sproc that
        // gets groups from the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiGetGroupsForUser";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramUnsecuredServicesValidationToken = new SqlParameter();
        paramUnsecuredServicesValidationToken.ParameterName = "@unsecuredServicesValidationToken";
        paramUnsecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramUnsecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramUnsecuredServicesValidationToken.Value = unsecuredServicesValidationToken;
        cmd.Parameters.Add(paramUnsecuredServicesValidationToken);

        return cmd;
    }

    /// <summary>
    /// This method gets all users in a group.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="groupName"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [XmlInclude(typeof(UserDetails))]
    public GetUsersInGroupResponse GetUsersInGroup(Credentials credentials, string groupName, string transactionId)
    {
        // check arguments
        if (credentials == null ||
            credentials.UserId == null || credentials.UnsecuredServicesValidationToken == null ||
            credentials.UserId.Equals(string.Empty) ||
            credentials.UnsecuredServicesValidationToken.Equals(string.Empty) ||
            groupName == null || groupName.Equals(string.Empty) ||
            transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetUsersInGroup", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // get users in group
        SqlConnection conn = new SqlConnection(this.connectionString);
        try
        {
            // the list that will hold the returned data
            List<UserDetails> details = new List<UserDetails>();

            conn.Open();
            SqlCommand cmd = this.BuildGetUsersInGroupCommand(conn, credentials.UserId, credentials.UnsecuredServicesValidationToken, groupName);
            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                string userName = reader.GetString(reader.GetOrdinal("UserName"));
                Guid userId = reader.GetGuid(reader.GetOrdinal("UserId"));

                UserDetails ud = new UserDetails();
                ud.UserName = HttpUtility.HtmlEncode(userName);
                ud.UserId = userId;
                details.Add(ud);
            }

            GetUsersInGroupResponse getUsersInGroupResponse = new GetUsersInGroupResponse();
            getUsersInGroupResponse.ResponseType = ResponseType.GetUsersInGroup;
            getUsersInGroupResponse.ResponseCode = ServerReturnCodes.GotUsersInGroup;
            getUsersInGroupResponse.ResponseObj = details;
            getUsersInGroupResponse.TransactionId = transactionId;
            return getUsersInGroupResponse;
        }
        catch (SqlException ex)
        {
            string sqlErrorMessage = SoapExceptionGenerator.BuildSqlErrorString(ex);
            throw SoapExceptionGenerator.RaiseException("GetUsersInGroup", "http://www.gpspostit.com/gpiws",
                sqlErrorMessage, ex.Message, transactionId, SoapExceptionGenerator.FaultCode.Server);
        }
        catch (Exception ex2)
        {
            throw SoapExceptionGenerator.RaiseException("GetUsersInGroup", "http://www.gpspostit.com/gpiws",
                ex2.Message, ServerReturnCodes.CannotGetUsersInGroup, transactionId, SoapExceptionGenerator.FaultCode.Server);
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
    /// Builds the SQL command to get users in a group.
    /// </summary>
    /// <param name="conn"></param>
    /// <param name="userId"></param>
    /// <param name="unsecuredServicesValidationToken"></param>
    /// <param name="groupName"></param>
    /// <returns></returns>
    private SqlCommand BuildGetUsersInGroupCommand(SqlConnection conn, string userId, string unsecuredServicesValidationToken, string groupName)
    {
        // build the command to call a sproc that
        // gets groups from the database
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "GpiGetUsersInGroup";

        SqlParameter paramUserId = new SqlParameter();
        paramUserId.ParameterName = "@userId";
        paramUserId.SqlDbType = SqlDbType.UniqueIdentifier;
        paramUserId.Direction = ParameterDirection.Input;
        paramUserId.Value = new Guid(userId);
        cmd.Parameters.Add(paramUserId);

        SqlParameter paramUnsecuredServicesValidationToken = new SqlParameter();
        paramUnsecuredServicesValidationToken.ParameterName = "@unsecuredServicesValidationToken";
        paramUnsecuredServicesValidationToken.SqlDbType = SqlDbType.VarChar;
        paramUnsecuredServicesValidationToken.Direction = ParameterDirection.Input;
        paramUnsecuredServicesValidationToken.Value = unsecuredServicesValidationToken;
        cmd.Parameters.Add(paramUnsecuredServicesValidationToken);

        SqlParameter paramGroupName = new SqlParameter();
        paramGroupName.ParameterName = "@groupName";
        paramGroupName.SqlDbType = SqlDbType.NVarChar;
        paramGroupName.Direction = ParameterDirection.Input;
        paramGroupName.Value = groupName;
        cmd.Parameters.Add(paramGroupName);

        return cmd;
    }

    /// <summary>
    /// This method gets all server return codes.
    /// </summary>
    /// <param name="credentials"></param>
    /// <param name="transactionId"></param>
    /// <returns></returns>
    [WebMethod]
    [return: XmlRoot(Namespace = "http://www.gpspostit.com/gpiws/",
        ElementName = "GetReturnCodesResponseDummy",
        DataType = "GetReturnCodesResponse",
        IsNullable = false)]
    public GetReturnCodesResponse GetReturnCodes(string transactionId)
    {
        // check arguments
        if (transactionId == null || transactionId.Equals(string.Empty))
        {
            throw SoapExceptionGenerator.RaiseException("GetServerReturnCodes", "http://www.gpspostit.com/gpiws",
                ServerReturnMessages.NullArgumentMessage, ServerReturnCodes.NullArgument, string.Empty, SoapExceptionGenerator.FaultCode.Server);
        }

        // get all return codes
        List<string> retCodeList = new List<string>();
        ServerReturnCodes retCodes = new ServerReturnCodes();
        Type retCodesType = retCodes.GetType();
        FieldInfo[] fields = retCodesType.GetFields();
        foreach(FieldInfo fInfo in fields)
        {
            if(fInfo.IsPublic && fInfo.IsStatic && fInfo.IsInitOnly)
            {
                retCodeList.Add(fInfo.Name);
            }
        }

        GetReturnCodesResponse response = new GetReturnCodesResponse();
        response.ResponseCode = string.Empty;
        response.ResponseType = ResponseType.GetReturnCodes;
        response.ResponseObj = retCodeList;
        response.TransactionId = transactionId;
        
        return response;
    }
}
