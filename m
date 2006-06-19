From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID
 under Linux
Date: Mon, 19 Jun 2006 14:58:06 -0400
Message-ID: <4496F3BE.9040707@steeleye.com>
References: <17554.895.666628.776527@cse.unsw.edu.au> <4492D26B.4070705@steeleye.com> <4492F066.7060709@tmr.com> <4496BE1A.8010502@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010500070209090406010301"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4496BE1A.8010502@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010500070209090406010301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

> Neil Brown wrote:
> I am pleased to announce the availability of
>    mdadm version 2.5.1

What the heck, here's another one. :) This one is slightly more serious. 
We're getting a device of "0:0" in "Fail" events from the mdadm monitor 
sometimes now (due to the change in map_dev, which allows it to 
sometimes return "0:0" instead of just NULL for an unknown device).

The patch fixes my issue. I don't know if there are more.

Thanks,
Paul

--------------010500070209090406010301
Content-Type: text/plain;
 name="mdadm-2.5.1-dev0:0-monitor-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.5.1-dev0:0-monitor-fix.diff"

--- mdadm-2.5.1/Monitor.c	Thu Jun  1 21:33:41 2006
+++ mdadm-2.5.1-new/Monitor.c	Mon Jun 19 14:51:31 2006
@@ -328,7 +328,7 @@ int Monitor(mddev_dev_t devlist,
 					}
 					disc.major = disc.minor = 0;
 				}
-				if (dv == NULL && st->devid[i])
+				if ((dv == NULL || strcmp(dv, "0:0") == 0) && st->devid[i])
 					dv = map_dev(major(st->devid[i]),
 						     minor(st->devid[i]), 1);
 				change = newstate ^ st->devstate[i];

--------------010500070209090406010301--
