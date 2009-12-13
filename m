From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: RE: Spurious HD convictions
Date: Sat, 12 Dec 2009 21:44:53 -0600
Message-ID: <200912122144.53709.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm.  I don't see how it could be either the PS or the PMs, since the drives 
were moved to a new enclosure when the problem started happening, yet the 
problem persists.  The new chassis has all new PMs and of course a new PS, 
and the problem is happening across multiple PMs.  In addition, if NCQ is the 
problem, why has it just started happening?  This system has been up and 
running for the better part of a year.  Regardless, I have disabled NCQ by 
executing `echo 1 > /sys/block/sd[a-g]/device/queue_depth`, and I am 
attempting a repair action again.  We'll see how it goes.

> Hi Leslie,
> 
> According to some of the links here:
> http://www.google.com/search?hl=en&q=failed+to+read+SCR+1+(Emask%3D0x40)
> 
> It seem to be either the Power Supply Unit (PSU) or the Port Multiplier
> (PM).
> 
> A quick workaround seem to be disabling NCQ on all affected devices.
> 
> On Sun, Dec 13, 2009 at 5:02 AM, lrhorer@satx.rr.com
> <lrhorer@satx.rr.com> wrote:
> >
> >        What's happening here?  Suddenly, my backup server is suffering
> apparently
> > spurious hard drive convictions.  The server is running RAID5 on 7 disks
> > under md.  It has been running well for months, but suddenly it has
> started
> > kicking drives from the array when under moderately heavy read or write
> > loads.  The thing is, it isn't convicting any particular drive
> repeatedly,
> > and the drives are not showing any errors under SMART.  This is a PM
> system,
> > and I have tried changing the drive adapters, changing the PMs, changing
> > cables, moving the drives around, and moving them out of the CPU
> enclosure to
> > a new external chassis.  The convictions are not occurring on any one
> > channel, over any one particular PM, or over any particular cable.
>  Since
> > this started happening, I have been unable to get all the way through a
> > resync before the array dumps at least one of the drives.  Here is a
> sample
> > from the kernel log during one of the convictions:
