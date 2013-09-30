using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

namespace ServerConstants
{
    public enum AttachmentOperationType
    {
        None,
        Add,
        Modify,
        Delete
    }

    public enum ResponseType
    {
        Login,
        Logout,
        AuthorPinEx,
        ModifyPin,
        DeletePins,
        GetPinsEx,
        GetAttachment,
        RatePin,
        CreateGroup,
        GetGroups,
        AddUserToGroup,
        GetUsersInGroup,
        RemoveUserFromGroup,
        RemoveGroup,
        GetReturnCodes,
        GetTags
    }

    public enum PinOrderDisposition
    {
        HighestRated,
        MostRecent
    }

    public enum IntervalType
    {
        None,
        Today,
        PastTwoDays,
        ThisWeek,
        PastTwoWeeks,
        CustomInterval
    }

    public enum PagingDirection
    {
        Forward,
        Reverse
    }

    class TagConstants
    {
        public static readonly string AnyTag = "#any#";
    }

    class DateTimeConstants
    {
        public static readonly DateTime LongTimeAgo = new DateTime(1900, 1, 1, 0, 0, 0);
    }

    public class RatingBracket
    {
        public static readonly short OneStar = 1;
        public static readonly short FiveStars = 5;
    }

    public class PagingConstants
    {
        public static readonly ushort Greedy = 0;
    }

    public class ValidationTokens
    {
        public static readonly string GeneralServiceToken = "77b50df1-e650-46a1-a679-3bfd8e291670";
    }
}
