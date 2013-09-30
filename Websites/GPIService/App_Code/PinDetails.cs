using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Details of a pin.
/// </summary>
public class PinDetails
{
    private ulong totalPinCount;
    public ulong TotalPinCount
    {
        get
        {
            return totalPinCount;
        }
        set
        {
            totalPinCount = value;
        }
    }

    private ulong pinNumber;
    public ulong PinNumber
    {
        get
        {
            return pinNumber;
        }
        set
        {
            pinNumber = value;
        }
    }

    private string pinId;
    public string PinId
    {
        get
        {
            return pinId;
        }
        set
        {
            pinId = value;
        }
    }

    private string author;
    public string Author
    {
        get
        {
            return author;
        }
        set
        {
            author = value;
        }
    }

    private string title;
    public string Title
    {
        get
        {
            return title;
        }
        set
        {
            title = value;
        }
    }

    private string message;
    public string Message
    {
        get
        {
            return message;
        }
        set
        {
            message = value;
        }
    }

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

    private string attachmentId;
    public string AttachmentId
    {
        get
        {
            return attachmentId;
        }
        set
        {
            attachmentId = value;
        }
    }

    private string attachmentName;
    public string AttachmentName
    {
        get
        {
            return attachmentName;
        }
        set
        {
            attachmentName = value;
        }
    }

    private string attachment;
    public string Attachment
    {
        get
        {
            return attachment;
        }
        set
        {
            attachment = value;
        }
    }

    private string attachmentType;
    public string AttachmentType
    {
        get
        {
            return attachmentType;
        }
        set
        {
            attachmentType = value;
        }
    }

    private string createTime;
    public string CreateTime
    {
        get
        {
            return createTime;
        }
        set
        {
            createTime = value;
        }
    }

    private string modifyTime;
    public string ModifyTime
    {
        get
        {
            return modifyTime;
        }
        set
        {
            modifyTime = value;
        }
    }

    private string createTimeInDb;
    public string CreateTimeInDb
    {
        get
        {
            return createTimeInDb;
        }
        set
        {
            createTimeInDb = value;
        }
    }

    private string modifyTimeInDb;
    public string ModifyTimeInDb
    {
        get
        {
            return modifyTimeInDb;
        }
        set
        {
            modifyTimeInDb = value;
        }
    }

    private string tagList;
    public string TagList
    {
        get
        {
            return tagList;
        }
        set
        {
            tagList = value;
        }
    }

    private float averageRating;
    public float AverageRating
    {
        get
        {
            return averageRating;
        }
        set
        {
            averageRating = value;
        }
    }

    private ulong totalEvaluations;
    public ulong TotalEvaluations
    {
        get
        {
            return totalEvaluations;
        }
        set
        {
            totalEvaluations = value;
        }
    }
    
    public PinDetails()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public override string ToString()
    {
        return this.title + ":" + this.message + ":" + this.latitude + ":" + this.longitude + ":" + this.author + ":" + this.attachmentId + ":" + this.AttachmentName + ":" + this.attachmentType;
    }
}
