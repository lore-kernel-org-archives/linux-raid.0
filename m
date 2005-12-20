From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Raid sync observations
Date: Tue, 20 Dec 2005 10:27:41 -0800
Message-ID: <200512201827.jBKIRf6m019390@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I just created a RAID array (4-disk RAID-6).  When "mdadm -C" returned,
>/proc/mdstat showed it syncing the new array at about 17 MB/s.  "vmstat 1"
>showed hardly any blocks in or out, and an almost completely idle cpu.

>Question 1: Why didnt the raid sync I/O show up with vmstat?

I switched to iostat because of similar observations with vmstat. iostat
at least shows you which devices it is looking at and it agrees with
/proc/mdstat's numbers in my experience.

>Question 2: Why was it limited to 17 MB per second?  The maximum was
>left at the default, 200 MB/s.  The min was also at the default, 1 MB/s.
>I get 60 MB/s per disk with "hdparm -tT" (that's using one disk at a time,
>but still).  The checksumming code does > 3 GB/s.

Try using dd to read each device in parallel as it might be a bus or controller
limitation. Also, sync requires writing interspersed with the reads which
unavoidably ruins the total throughput. Larger stripes should minimize this if
you think it'll be a problem during everyday use.

