using System;
using System.Collections.Generic;
using System.Web;

/// <summary>
/// Summary description for GetTagsResponse
/// </summary>
public class GetTagsResponse : ServerResponse
{
	public GetTagsResponse()
	{
		//
		// TODO: Add constructor logic here
		//
	}
   
    private List<TagDetails> responseObj;
    
    public List<TagDetails> ResponseObj
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
}