From: <me@heyjay.com>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 1 Apr 2004 22:46:19 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00a401c4186f$ffd21110$6405a8c0@a30>
References: <008f01c41737$8b57be40$6405a8c0@a30> <006401c417a1$36a45790$6405a8c0@a30> <406BAF7F.2030307@pobox.com> <013101c417e8$fa7fd670$6405a8c0@a30> <406C6E0F.2000607@physics.ucsd.edu>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Terrence Martin <tmartin@physics.ucsd.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I'll read the how-tos and see if I can't get the software raid up
and running

thanks
Jay
----- Original Message ----- 
From: "Terrence Martin" <tmartin@physics.ucsd.edu>
To: <me@heyjay.com>; <linux-raid@vger.kernel.org>
Sent: Thursday, April 01, 2004 1:31 PM
Subject: Re: Which raid card to buy for Sarge


> me@heyjay.com wrote:
>
> >----- Original Message ----- 
> >From: "Jeff Garzik" <jgarzik@pobox.com>
> >To: <me@heyjay.com>
> >Cc: <linux-raid@vger.kernel.org>
> >Sent: Wednesday, March 31, 2004 11:58 PM
> >Subject: Re: Which raid card to buy for Sarge
> >
> >
> >
> >
> >>98% cpu doing just raid 1?  That sounds highly strange, even on an older
> >>CPU.
> >>
> >>Typically RAID1 doesn't stress the cpu as much as PCI bus bandwidth and
> >>the drives...
> >>
> >>
> >>
> >
> >Sorry, I was unclear.  Currently (without raid) my process maxes out my
cpu.
> >If I move to raid won't I have performance problems?  Maybe all the work
> >happens at the PCI bus
> >
> >Jay
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
>
> AFAIK there is no additional calculations on RAID1 so little or no CPU,
> as long as you make sure your drivers are not in an IDE master/slave
> relationship you will get equivalent performance to a single drive
> system, but with redundancy.
>
> This assumes that the RAID array is not recovering at the time of course
> or doing an integrity check (after an unclean shutdown).
>
> In general though I would not expect Linux software RAID1  to have any
> additional CPU cost over a single drive.
>
> As an aside alone the 99% CPU utilization is perhaps not a good measure
> of your system load or capacity. You should also look at how much IO
> your process produces and also the total load on the system (how much
> processes are waiting to execute).  Most processes if they do any
> significant IO are bound by that, not the CPU. If your process does
> little or no IO I would not expect any RAID config to have any impact at
> all, even RAID5.
>
> see vmstat(8) and uptime(1)
>
> Terrence
>
>

