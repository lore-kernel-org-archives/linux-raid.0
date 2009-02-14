From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: write-behind performance ... or how behind can write-behind write
Date: Sat, 14 Feb 2009 08:38:45 -0500
Message-ID: <4996C965.9020205@tmr.com>
References: <4995A170.4000000@amln.net> <4995BF95.1010908@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4995BF95.1010908@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Georgi Alexandrov <teh@amln.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Georgi Alexandrov wrote:
>
>> Generally with the healthy array I'm getting the write performance of
>> the SATA disk alone (in terms of requests/sec issued to the disk and
>> bytes/sec written). The SATA disk is obviously a bottleneck even with
>> the write-behind option set(2).
>
> write-behind can help with two things:
>
> 1) overcoming latency (say one disk is on the network -- it may be the 
> same speed as the source disk, but it takes longer round-trip for each 
> I/O to complete)
>
> 2) temporary slowness of a device (say at a peak in I/O) -- the queue 
> can temporarily hide the slowness of the secondary disk, but this 
> won't last very long -- if writes continue at a pace faster than the 
> disk can handle (i.e., the queue gets filled) then the array drops 
> back to non-write-behind behavior
>
At least with write-mostly all of the capacity is going into saving 
data, not serving data. But as you note below if the writes are 
happening at a rate faster than the device can support it will be a 
bottleneck.

>> So the questions is How behind can write-behind write? And can we get a
>> better performance in a similar setup.
>
> By default, it queues up 256 writes. This can be increased, but I've 
> actually seen worse performance in some cases -- not sure why. I 
> haven't had the time to dig into it and figure it out.
>
> -- 
> Paul
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


