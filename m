From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: with the latest mdadm
Date: Tue, 7 Feb 2006 08:33:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0602070829120.22031-100000@firewall2.tmr.com>
References: <17384.26402.724978.284042@cse.unsw.edu.au>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17384.26402.724978.284042@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Farkas Levente <lfarkas@bppiac.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 7 Feb 2006, Neil Brown wrote:

> On Tuesday February 7, lfarkas@bppiac.hu wrote:
> > hi,
> > with the latest mdadm-2.3.1 we've got the following message:
> > -------------------------------------
> > md: md4: sync done.
> > RAID1 conf printout:
> >  --- wd:2 rd:2
> >  disk 0, wo:0, o:1, dev:sda2
> >  disk 1, wo:0, o:1, dev:sdb2
> > md: mdadm(pid 8003) used obsolete MD ioctl, upgrade your software to use
> > new ictls.
> > -------------------------------------
> > this is just a warning or some kind of problem with mdadm?
> 
> This is with a 2.4 kernel, isn't it.
> 
> The md driver is incorrectly interpreting an ioctl that it doesn't
> recognise as an obsolete ioctl.  In fact it is a new ioctl that 2.4
> doesn't know about (I suspect it is GET_BITMAP_FILE).
> 
> The message should probably be removed from 2.4, but as 2.4 is in
> deep-maintenance mode, I suspect that is unlikely....

More to the point, why is mdadm trying to use an illegal ioctl instead of 
checking the kernel version and disabling features which won't work? Users 
are trusting their data to this software, and "try it and see if it works" 
ioctls don't give me a warm fuzzy feeling about correct operation.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

