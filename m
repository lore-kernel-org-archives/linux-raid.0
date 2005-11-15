From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH md 000 of 2] Introduction
Date: Tue, 15 Nov 2005 09:55:30 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0511150859360.15915@filesrv1.baby-dragons.com>
References: <20051115125442.9317.patches@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051115125442.9317.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,

On Tue, 15 Nov 2005, NeilBrown wrote:
> Following are two patches for md in 2.6.14-mm2 that are suitable to go
> into the 2.6.15-rc series.
>
> The first adds a date to the deprecation of START_ARRAY ioctl.
>
> The second fixes a recently introduced problem that causes md threads
> to permanently add to the load average (other than that, every works
> fine).
>
> [PATCH md 001 of 2] Mark START_ARRAY deprecated with a date.
> [PATCH md 002 of 2] Make md threads interruptible again.

> diff ./Documentation/feature-removal-schedule.txt~current~ /Documentation/feature-removal-schedule.txt
> --- ./Documentation/feature-removal-schedule.txt~current~       2005-11-15 10:25:30.000000000 +1100
> +++ ./Documentation/feature-removal-schedule.txt        2005-11-15 10:25:30.000000000 +1100
> @@ -131,3 +131,12 @@ What:      EXPORT_SYMBOL(lookup_hash)
>  When:  January 2006
>  Why:   Too low-level interface.  Use lookup_one_len or lookup_create instead.
>  Who:   Christoph Hellwig <hch@lst.de>
> +
> +---------------------------
> +
> +What:  START_ARRAY ioctl for md
> +When:  July 2006
> +Files: drivers/md/md.c
> +Why:   Not reliable by design - can fail when most needed.
> +       Alternatives exist
> +Who:   NeilBrown <neilb@suse.de>

 	Would some please update Documentation/md.txt with the alternates
 	that exist to replace START_ARRAY ?  Or for that matter any kernel
 	related document that covers the md driver &/or its tools .
 		Tia ,  JimL

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
