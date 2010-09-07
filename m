From: Roy Keene <linux-raid@rkeene.org>
Subject: Re: [PATCH] Add optional round-robbin read balancing to RAID1
Date: Mon, 6 Sep 2010 22:03:21 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.1009062201530.11139@claw.oc9.org>
References: <Pine.LNX.4.64.1009061609170.11139@claw.oc9.org>
 <20100907084347.50e705df@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907084347.50e705df@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. Mamedov,

 	This has been corrected.  Thanks.

Also, the link you sent me wasn't too helpful, and neither is the 
"computers" link:
 	http://en.wikipedia.org/wiki/Round_robin_(computers)

Perhaps the term is wrong altogether and should be changed to something 
else.

Thanks,
 	Roy Keene

On Tue, 7 Sep 2010, Roman Mamedov wrote:

> On Mon, 6 Sep 2010 16:14:17 -0500 (CDT)
> Roy Keene <rkeene@rkeene.org> wrote:
>
>>  	Below is a patch that adds support for an alternate read balancing
>> strategy that blindly performs read round-robbin to the MD RAID1 driver.
>> This can be configure per array via sysfs.  The default behaviour is to
>> preserve existing behaviour (biased read balancing)
>>
>> I am looking for comments and possible inclusion upstream.
>>
>> The motivation behind this is that during a sequential read, under some
>> circumstances balancing the I/O through the paths produces better
>> throughput than reading sequentially from one device.
>
> The term is "round-robin", not "robbin", you may want to correct the word
> everywhere, most importantly in the actual patch.
> http://en.wikipedia.org/wiki/Round-robin
>
> -- 
> With respect,
> Roman
>
