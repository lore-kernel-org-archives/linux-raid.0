From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Disks keep disapearing
Date: Sat, 10 May 2003 21:09:11 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0305102055150.24253-100000@multivac.sdsc.edu>
References: <3EBD2D2C.1050900@visiarc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EBD2D2C.1050900@visiarc.com>
To: =?ISO-8859-1?Q?Johan_Sch=F6n?= <johan.schon@visiarc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Johan,

> > WD has had problems similar to this with many of their drives.  It just
> > decides to 'go away'.  There is a fix available on their web site for the
> > 180GB and 200GB drives (and a better description of the problem), but the
> > problem is NOT limited to those drives.
>
> How do these problem appear in log files?
>
> I have a machine with two Promise Ultra100 TX2 cards, and five
> WD2000JB 200 GB drives in RAID-5. In a month, i've had a few disk "failures"
> that typically looks like this in the logs:

<SNIP LOG>

> The disk itself doesn't appear to know about any failures
> (using smartctl), and it works again when hotadded to the raidset. I've
> also had a multiple drive "failure" twice, both times with two drives
> using the same IDE channel.
>
> I'm not sure if these problems are caused by buggy Promise ATA drivers
> in my kernel (RH9, 2.4.20) or the WDC problem with 180/200 GB drives.
> From WDC's description of the problem, I got the impression that it
> only happened when the drives were connected to hardware RAID cards
> like 3Ware IDE raid controllers.

This appears to be the WD problem.  It is caused by some timing-related
irregularities in their microcode.  It occurs in a 'RAID environment'.
The article is not specific about only hardware RAID cards.

There is a fix package for 3Ware cards and a fix package for non-3Ware
cards.  Use the package for non-3Ware cards.

If you need to have more than 4 drives in an array, with 2 Ultra100 cards,
you might want to consider adding a Promise Ultra133 card.  You are
normally limited to 2 of each, for a total of 4 cards (8 channels total).
This would solve your double-failure problem.  FYI, I'm running the
reverse of this (2 Ultra133 + 1 Ultra100) in one of my file servers with
excellent results.

Good luck.
				Peter Ashford

