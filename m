From: rob <rob@fantinibakery.com>
Subject: Re: recovery of hosed raid5 array
Date: Sat, 11 Oct 2003 21:14:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F88AAFE.7060101@fantinibakery.com>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <no.Yo.24973.N.nN.0310111457280@business.com>
To: linux-raid@ied.com
Cc: Jason Lunz <lunz@falooley.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What IS  "smartctl" ?

linux-raid@ied.com wrote:

> Hi,
>
>On Sat, 11 Oct 2003, Jason Lunz wrote:
>
>  
>
>>Date: Sat, 11 Oct 2003 15:52:40 +0000 (UTC)
>>From: Jason Lunz <lunz@falooley.org>
>>To: linux-raid@vger.kernel.org
>>Subject: recovery of hosed raid5 array
>>
>>    
>>
>[...]
>  
>
>>Once the rebuild started, I noticed an email from smartd, saying that
>>the _other_ drive on the Promise controller (/dev/hde) had had errors.
>>So I foolishly checked it out with smartctl,
>>    
>>
>
>  Can you please share with us newbies why using "smartctl" 
>in such situation is foolish, so we don't make the same 
>mistake ?
>
>  Thanks.
>
>    John
>
>
>[...]
>  
>
>>at which point everything
>>went to hell. /dev/hde now clicks repeatedly and refuses to work for
>>more than a minute or so, while /dev/hdg is partially destroyed from
>>being re-added. The rebuild was 3-4% complete when hde died.
>>    
>>
>
>
>  
>

