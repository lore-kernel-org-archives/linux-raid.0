From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Joys of spare disks!
Date: Mon, 7 Mar 2005 18:09:07 +0100
Message-ID: <jeeuf2-vkf.ln1@news.it.uc3m.es>
References: <200503071636.j27GaMnD009839@newsguy.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

LinuxRaid@suykerbuyk.org wrote:
> I've been going through the MD driver source, and to tell the truth, can't
> figure out where the read error is detected and how to "hook" that event and
> force a re-write of the failing sector.  I would very much appreciate it if

I did that for RAID1, or at least most of it (look for "robust read
patch" in this group's archive).

I also looked at RAID5, and my reaction was about the same as yours. I
made some progress, then decided that valour was not my colour that day.

> someone out there could send me some some hints/tips/pointers on how to
> impliment this.  I'm not a Linux / kernel hacker (yet), but this should not be
> hard to fix....

Peter

