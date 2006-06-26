From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Multiple raids on one machine?
Date: Sun, 25 Jun 2006 20:16:18 -0400
Message-ID: <449F2752.2000901@tmr.com>
References: <449F100D.6030509@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F100D.6030509@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Allen wrote:

> Back to my 12 terabyte fileserver, I have decided to split the storage 
> into four partitions
> each of 3TB. This way I can choose between XFS and EXT3 later on.
>
> So now, my options are between the following:
>
> 1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
> I do this? fdisk won't handle it. Can GNU Parted handle partitions 
> this big?
>
> 2. Partition the raw disks into four partitions and make 
> /dev/md0,md1,md2,md3.
> But am I heading for problems here? Is there going to be a big 
> performance hit
> with four raid5 arrays on the same machine? Am I likely to have 
> dataloss problems
> if my machine crashes? 

No. I regularly run a mix of RAID types over the same drives for 
performance vs. reliability reasons. And in the past I ran not only 
RAID-0 and RAID-5 using various partitions, but the stripe size was 
different as well. Survived a number of unscheduled restarts.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

