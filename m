From: James Peverill <jamespev@net1plus.com>
Subject: Re: Resize on dirty array?
Date: Wed, 09 Aug 2006 07:28:53 -0400
Message-ID: <44D9C6F5.7070501@net1plus.com>
References: <44D7DC93.2070905@net1plus.com>
	<17623.57067.835826.446152@cse.unsw.edu.au>	<44D8E535.9080208@net1plus.com>
 <17625.24594.568139.430440@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17625.24594.568139.430440@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'll try the force assemble but it sounds like I'm screwed.  It sounds 
like what happened was that two of my drives developed bad sectors in 
different places that weren't found until I accessed certain areas (in 
the case of the first failure) and did the drive rebuild (for the second 
failure).  In the future, is there a way to help prevent this?  Given 
that the bad sectors were likely on different parts of their respective 
drives, I should still have a complete copy of all the data right?  Is 
it possible to recover from a partial two-disk failure using all the disks?

It looks like I might as well cut my losses and buy new disks (I suspect 
the last two drives are near death given whats happened to their 
brethren).  If I go SATA am I better off getting 2 dual port cards or 1 
four port?

Thanks again.

James


Neil Brown wrote:
> On Tuesday August 8, jamespev@net1plus.com wrote:
>   
>> The resize went fine, but after re-adding the drive back into the array 
>> I got another fail event (on another drive) about 23% through the 
>> rebuild :(
>>
>> Did I have to "remove" the bad drive before re-adding it with mdadm?  I 
>> think my array might be toast...
>>
>>     
>
> You wouldn't be able to re-add the drive without removing it first.
> But why did you re-add the failed drive?  Why not add the new one? Or
> maybe you did...
>
> 2 drives failed - yes - that sounds a bit like toast.
> You can possible do a --force assemble without the new drive and try
> to backup the data somewhere - if you have somewhere large enough.
>
> NeilBrown
>
>
>   
>> Any tips on where I should go now?
>>
>> Thanks for the help.
>>
>> James
>>     
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
