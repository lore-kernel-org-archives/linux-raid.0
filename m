From: "Cody Yellan" <cody@mochamail.com>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Fri, 28 Dec 2007 11:21:39 -0800
Message-ID: <380-2200712528192139967@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> Cody Yellan wrote:
>>>> I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
>>>> reshaping began at ~2500K/sec.  Changing
>>>> /proc/sys/dev/raid/speed_limit_m{in,ax} or
>>>> /sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down
>all
>>>> unnecessary services and the array is offline (not mounted).  I
>have
>>>> read that the throttling code is "fragile" (esp. with regard to
>>>> raid5) but does this make sense?  I will wait (in)patiently for
>it to
>>>> finish, but I do wonder why the configuration parameters have no
>>>> effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
>>>> running RHEL5.  Is this the maximum speed?
>>
>>Are you running a non-standard /sys/block/md5/md/stripe_cache_size?
>>
>>I found when running a kernel of about that vintage on FC6 (which I 
>>guess became RHEL5), that with a stripe_cache_size of 16384, resyncs
>
>>dropped down to about the speed you are seeing.
>>
>>This changed back to more normal speeds with a later kernel, but I
>do 
>>not recall which.
>>
>>Regards,
>>
>>Richard

You are right, Richard.  RHEL5 had a stripe_cache_size of 256 when
the reshape began.  I increased it to 1024 and the reshape speed
doubled to 4500K/s.  I did not see any increase in memory usage.  I
tried 2048 and then 4096 but saw no difference in speed.

The reshape finished and the array is back online.  mdadm works very
well, but I would like to better understand how it works.  For
instance, the mdadm man page says a backup-file is necessary to grow
a RAID5, but this does not appear necessary now.  Anyway, it's a
wonderful tool.

