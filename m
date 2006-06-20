From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID
 under Linux
Date: Tue, 20 Jun 2006 10:04:07 +1000
Message-ID: <17559.15223.15351.875432@cse.unsw.edu.au>
References: <17554.895.666628.776527@cse.unsw.edu.au>
	<4492D26B.4070705@steeleye.com>
	<4492F066.7060709@tmr.com>
	<4496BE1A.8010502@steeleye.com>
	<4496F3BE.9040707@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 19, paul.clements@steeleye.com wrote:
> > Neil Brown wrote:
> > I am pleased to announce the availability of
> >    mdadm version 2.5.1
> 
> What the heck, here's another one. :) This one is slightly more serious. 
> We're getting a device of "0:0" in "Fail" events from the mdadm monitor 
> sometimes now (due to the change in map_dev, which allows it to 
> sometimes return "0:0" instead of just NULL for an unknown device).
> 

Thanks for this and the other two.  They are now in .git

> The patch fixes my issue. I don't know if there are more.
> 

I chose to do this differently - map_dev will now return NULL for 0,0
and all users can cope with a NULL.

NeilBrown



> Thanks,
> Paul
> --- mdadm-2.5.1/Monitor.c	Thu Jun  1 21:33:41 2006
> +++ mdadm-2.5.1-new/Monitor.c	Mon Jun 19 14:51:31 2006
> @@ -328,7 +328,7 @@ int Monitor(mddev_dev_t devlist,
>  					}
>  					disc.major = disc.minor = 0;
>  				}
> -				if (dv == NULL && st->devid[i])
> +				if ((dv == NULL || strcmp(dv, "0:0") == 0) && st->devid[i])
>  					dv = map_dev(major(st->devid[i]),
>  						     minor(st->devid[i]), 1);
>  				change = newstate ^ st->devstate[i];
