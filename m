From: Farkas Levente <lfarkas@bnap.hu>
Subject: Re: mdadm never notify, grub cause fault
Date: Wed, 21 May 2003 11:05:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3ECB416E.2030903@bnap.hu>
References: <3EC4AD9A.6090104@bnap.hu>	<news2mail-ba382u$uop$1@cartman.spoiled.org>	<3EC52695.318811F7@SteelEye.com>	<16072.17850.938484.250446@notabene.cse.unsw.edu.au>	<3EC8745B.9010106@bnap.hu> <16074.55430.183148.939335@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16074.55430.183148.939335@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday May 19, lfarkas@bnap.hu wrote:
> 
>>>I'm thinking of causing the "NewArray" alert to 
>>> - be generate for all arrays at start time
>>> - contain an indication of whether the array is degraded
>>> - cause email to be sent if the array is degraded.
>>>
>>>Thus you will get an alert of a failed drive when the mdadm --monitor
>>>is started.
>>
>>the above are generated every every time when --monitor started? that 
>>would be nice!
> 
> 
> Yep, and it's done.
> 
> There is a patch under 
> 
> http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> 
> (see 'patch' and the 'applied')
> 
> that
>   1/ When mdadm --monitor first notices an array, it will check if it
>   is degraded and will issue a "DegradedArray" event if it is.
>   2/ mdadm --monitor has a --oneshot option which causes it to check
>   once and exit. This can be used in a cron script to generate
>   DegradedArray  events on a regular basis for any degraded arrays. 

thanks. what does the applied means? I'm just check both the tgz and 
rpms but it seems to me that are older. I always prefere the release 
like 1.2.1 what's more if an rpm would be supplied:-))
thnaks.


-- 
   Levente                               "Si vis pacem para bellum!"


