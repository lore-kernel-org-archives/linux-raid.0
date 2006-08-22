From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID-6 check slow..
Date: Tue, 22 Aug 2006 12:07:16 +0400
Message-ID: <44EABB34.60603@wasp.net.au>
References: <44EAB1B7.7010208@wasp.net.au> <17642.47012.109307.542850@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17642.47012.109307.542850@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

> Hmm....  nothing obvious.
> Have you tried increasing 
>   /proc/sys/dev/raid/speed_limit_min:1000
> just in case that makes a difference (it shouldn't but you seem to be
> down close to that speed).

No difference..

> What speed in the raid6 algorithm used - as reported at boot time?
> Again, I doubt that is the problem - if should be about 1000 times
> speed you are seeing.

raid6: int32x1    739 MB/s
raid6: int32x2    991 MB/s
raid6: int32x4    636 MB/s
raid6: int32x8    587 MB/s
raid6: mmxx1     1556 MB/s
raid6: mmxx2     2701 MB/s
raid6: sse1x1    1432 MB/s
raid6: sse1x2    2398 MB/s
raid6: using algorithm sse1x2 (2398 MB/s)
md: raid6 personality registered for level 6
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  2345.000 MB/sec
raid5: using function: pIII_sse (2345.000 MB/sec)
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39


> What if you try increasing /sys/block/md0/md/stripe_cache_size ?

I already have this at 8192 (which appears to be HUGE for 15 drives, but I've got 1.5GB of ram and 
nothing else using it)

> That's all I can think of for now.
> 

Oh well, no stress.. Just thought I'd ask anyway :)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
