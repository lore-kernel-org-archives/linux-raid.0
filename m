From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Changing chunk size
Date: Fri, 16 Feb 2007 14:28:32 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702161428200.24249@p34.internal.lan>
References: <45D4955C.60008@tmr.com> <17876.60347.983953.748979@notabene.brown>
 <45D5E05E.4000706@tmr.com> <45D5FCC7.7000503@maine.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D5FCC7.7000503@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 16 Feb 2007, Steve Cousins wrote:

>
>
> Bill Davidsen wrote:
>> 
>> I'm sure "slow" is a relative term, compared to backing up TBs of data and 
>> trying to restore them. Not to mention the lack of inexpensive TB size 
>> backup media. That's totally unavailable at the moment, I'll live with what 
>> I have, thanks.
>
> You don't backup your RAID arrays?  Yikes! For certain data this would be 
> fine (data that you can recreate easily) but it sounds like this isn't the 
> case for you otherwise you'd just wipe the array and recreate the data. There 
> are other modes of failure than just the drives themselves (file system 
> corruption for instance) so it is wise to do backups, even on "redundant" 
> systems.
>
> Good luck,
>
> Steve

I agree here, RAID is no substitute for backups.

