From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: [patch 0/7 v2] MD linear/0/1/10/5 TRIM support
Date: Wed, 29 Aug 2012 18:58:09 +0000 (GMT)
Message-ID: <alpine.LRH.2.02.1208291828040.22763@diagnostix.dwd.de>
References: <20120810025113.050392766@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120810025113.050392766@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fusionio.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

Hello,

On Fri, 10 Aug 2012, Shaohua Li wrote:

> This is the patchset to support MD discard, which I refresh against latest
> kernel. It's pretty straightforward for raid linear/0/1/10. The raid456 discard
> support is tricky, please see the log in the patches for details.
>
> Previously when I posted the patches out, people complain SATA SSD discard
> request merge error. Now a patch to disable discard request merge is in Jens's
> tree. We don't have this issue any more.
>
First many thanks for sending those updated patches. An also many thanks
to Neil that you still maintain MD for linux! Thank you for all the great
work!

I have tried the raid linear/0/1/10 patches on 3.6.0-rc3 and I sometimes
get this in /var/log/messages:

    Aug 27 21:44:53 yoda kernel: [10576.964134] request botched: dev sda: type=1, flags=916c081
    Aug 27 21:44:53 yoda kernel: [10576.964138]   sector 316197889, nr/cnr 0/256
    Aug 27 21:44:53 yoda kernel: [10576.964140]   bio ffff8803741b8600, biotail ffff8803741b8600, buffer           (null), len 0
    Aug 27 21:44:53 yoda kernel: [10576.971023] request botched: dev sdb: type=1, flags=917c081
    Aug 27 21:44:53 yoda kernel: [10576.971026]   sector 320574465, nr/cnr 0/384
    Aug 27 21:44:53 yoda kernel: [10576.971029]   bio ffff8803741b9e00, biotail ffff8803741b9e00, buffer           (null), len 0
    Aug 27 21:44:53 yoda kernel: [10576.972736] request botched: dev sdb: type=1, flags=916c081
    Aug 27 21:44:53 yoda kernel: [10576.972740]   sector 320575489, nr/cnr 0/288
    Aug 27 21:44:53 yoda kernel: [10576.972742]   bio ffff8803ff80e840, biotail ffff8803ff80e840, buffer           (null), len 0
    Aug 27 21:44:53 yoda kernel: [10576.973851] request botched: dev sda: type=1, flags=917c081
    Aug 27 21:44:53 yoda kernel: [10576.973854]   sector 320575105, nr/cnr 0/640
    Aug 27 21:44:53 yoda kernel: [10576.973857]   bio ffff8803741b9e80, biotail ffff8803741b9e80, buffer           (null), len 0

This happened on a Raid0 when I deleted lots of files (make clean in
kernel directory). The Raid0 is accross two SSD's:

    /dev/sda   Crucial M4-CT512M4SSD2 Firmware Revision:  000F
    /dev/sdb   Crucial M4-CT256M4SSD2 Firmware Revision:  000F

cat /proc/mounts for the partition looks as follows:

    /dev/md1 / ext4 rw,noatime,discard,journal_checksum,journal_async_commit,commit=600,stripe=256,data=ordered 0 0

And here cat /proc/mdstat:

    Personalities : [raid0]
    md1 : active raid0 sdb3[1] sda3[0]
          413851648 blocks super 1.2 512k chunks

    unused devices: <none>

However, when I apply this patch which Shaohua Li send to me on 13th March
(http://lkml.indiana.edu/hypermail/linux/kernel/1203.1/03323.html) these
messages do NOT show up:

--- linux-3.6-rc3/include/linux/blkdev.h.original	2012-08-22 22:29:06.000000000 +0200
+++ linux-3.6-rc3/include/linux/blkdev.h	2012-08-27 21:42:19.979566802 +0200
@@ -601,7 +601,7 @@
   * it already be started by driver.
   */
  #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
  #define rq_mergeable(rq)	\
  	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
  	 (((rq)->cmd_flags & REQ_DISCARD) || \


Regards,
Holger
