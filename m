From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: Raid sync observations
Date: Tue, 20 Dec 2005 14:33:58 -0700
Message-ID: <E1Eop7O-00005k-JG@highlab.com>
References: <E1Eol86-0008Ju-3J@highlab.com> <17320.30528.417691.57401@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17320.30528.417691.57401@cse.unsw.edu.au> 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
>  You can get better speed on creation with
>    mdadm -C -l6 -n4 -x2 /dev/sd[ab] missing missing /dev/sd[cd]
> 
>  i.e. create with 2 missing devices and 2 spares.  Recovery onto the
>  spares will do purely sequential IO on all devices and so will go
>  much faster.
>  Doing this requires regenerating datablocks which is more cpu
>  intensive that generating P and Q, so there might be some CPU
>  overhead, but the disk throughput is still much faster.
> 
>  In 2.6.16, raid6 resync has been improved somewhat.  This will not
>  affect the initial sync, but resync after a crash will only write
>  P/Q blocks which are wrong and there are usually very few of those.
>  This means that it will mostly to sequential reads on all drives, so
>  you get full device speed.

Thanks!!


-- 
Sebastian Kuzminsky
