From: thomas62186218@aol.com
Subject: Re: Software RAID 6 initial sync very slow
Date: Mon, 02 Jun 2008 15:18:57 -0400
Message-ID: <8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com> <4843E8FD.8000601@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4843E8FD.8000601@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Bill and Richard for your responses.

In sync_speed_max, I had already set it to 250000 (250MB/sec). For 
sync_speed_min, I have 249900 set. My rational behind doing this was to 
"force" it to go as fast as it can. Any problem with this?

However, adjusting stripe_cache_size did improve performance. It was 
256 at first, and my sync rate was 28MB/sec. When I increased it to 
4096, my sync rate jumped to 38MB/sec. Then I increased it to 16384, 
and it jumped again to 40MB/sec. Increasing stripe_cache_size above 
that did not seem to have any effect.

My question then is, how do I set the stripe_cache_size at the time of 
md creation? I would rather set it then, as opposed to having to echo 
stripe_cache_size variable with a new setting. In other words, where is 
this default value of 256 coming from? Thanks all!!

-Thomas

-----Original Message-----
From: Bill Davidsen <davidsen@tmr.com>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Mon, 2 Jun 2008 5:35 am
Subject: Re: Software RAID 6 initial sync very slow









thomas62186218@aol.com wrote:

> Hi all,

>

> I am debating between hardware or software RAID for a 
high-performance
> Linux storage server. One area of concern in my initial mdadm tests
> concerns sync speed. My setup is as follows:

>

> Linux Fedora 7 x64

> 12 x 1TB Hitachi 1TB SATAII drives connected via LSI SAS3801E PCIe 
HBA

> Dual 2.5GHz quad-core Xeon

> 8GB RAM

>

> My first test was to create a RAID 6 md device, 128K chunk, with all
> 12 drives. The sync is currently underway at a very slow 30MB/sec,
> with mdadm estimating this as a 9hr process. With an Adaptec 5805 
RAID
> card tested, I performed the RAID 6 initial sync with the same 12
> drives in just under 5 hours. Meanwhile, our total CPU usage during
> mdadm syncing is at 5%, so there's plenty of CPU not being used.

>

> Why is the sync so slow? This concerns me not only because initial
> sync time is important, but because this may be indicative of slow
> sync times in the event of a drive failure.


Two things will limit this, chunk size and max speed set in the
/sys/block/mdNN/md/sync_speed_max setting. What you are seeing does
sound slow.


--
Bill Davidsen <davidsen@tmr.com>

 "Woe unto the statesman who makes war without a reason that will still

 be valid when the war is over..." Otto von Bismark






