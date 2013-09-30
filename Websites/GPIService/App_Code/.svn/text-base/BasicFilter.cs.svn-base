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
/// Basic filter that filters pins based on location, tags, etc.
/// </summary>
public class BasicFilter
{
    private double latitude;
    public double Latitude
    {
        get
        {
            return latitude;
        }
        set
        {
            latitude = value;
        }
    }

    private double longitude;
    public double Longitude
    {
        get
        {
            return longitude;
        }
        set
        {
            longitude = value;
        }
    }

    private double range;
    public double Range
    {
        get
        {
            return range;
        }
        set
        {
            range = value;
        }
    }

    private string tags;
    public string Tags
    {
        get
        {
            return tags;
        }
        set
        {
            tags = value;
        }
    }

    private ServerConstants.IntervalType intervalType;
    public ServerConstants.IntervalType IntervalType
    {
        get
        {
            return intervalType;
        }
        set
        {
            intervalType = value;
        }
    }

    private DateTime startTime;
    public DateTime StartTime
    {
        get
        {
            return startTime;
        }
        set
        {
            startTime = value;
        }
    }

    private DateTime endTime;
    public DateTime EndTime
    {
        get
        {
            return endTime;
        }
        set
        {
            endTime = value;
        }
    }
    
    public BasicFilter()
    {
        // set up sensible defaults
        tags = string.Empty;
        intervalType = ServerConstants.IntervalType.None;
        startTime = ServerConstants.DateTimeConstants.LongTimeAgo;
        endTime = DateTime.Now;
    }
}
