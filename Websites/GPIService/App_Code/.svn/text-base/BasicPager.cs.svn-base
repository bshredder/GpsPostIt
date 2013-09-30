using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using ServerConstants;

/// <summary>
/// Basic pager object that encapsulates instructions for paging pins.
/// </summary>
public class BasicPager
{
    private ulong startPosition;
    public ulong StartPosition
    {
        get
        {
            return startPosition;
        }
        set
        {
            startPosition = value;
        }
    }

    private ushort pageSize;
    public ushort PageSize
    {
        get
        {
            return pageSize;
        }
        set
        {
            pageSize = value;
        }
    }

    private PagingDirection pagingDirection;
    public PagingDirection PagingDirection
    {
        get
        {
            return pagingDirection;
        }
        set
        {
            pagingDirection = value;
        }
    }
 
    public BasicPager()
    {
    }
}
