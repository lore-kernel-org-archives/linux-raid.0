From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about raid robustness when disk fails
Date: Fri, 22 Jan 2010 17:32:46 +0100
Message-ID: <87hbqeyua9.fsf@frosties.localdomain>
References: <1262972385.8962.159.camel@kije>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262972385.8962.159.camel@kije> (Tim Bock's message of "Fri, 08
	Jan 2010 10:39:45 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bock <jtbock@daylight.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Bock <jtbock@daylight.com> writes:

> Hello,
>
> 	I built a raid-1 + lvm setup on a Dell 2950 in December 2008.  The OS
> disk (ubuntu server 8.04) is not part of the raid.  Raid is 4 disks + 1
> hot spare (all raid disks are sata, 1TB Seagates).
>
> 	Worked like a charm for ten months, and then had some kind of disk
> problem in October which drove the load average to 13.  Initially tried
> a reboot, but system would not come all of the way back up.  Had to boot
> single-user and comment out the RAID entry.  System came up, I manually
> failed/removed the offending disk, added the RAID entry back to fstab,
> rebooted, and things proceeded as I would expect.  Replaced offending
> drive.

If a drive goes crazy without actualy dying then linux can spend a
long time trying to get something from the drive. The driver chip can
go crazy or the driver itself can have a bug and lockup. All those
things are below the raid level and if they halt your system then raid
can not do anything about it.

Only when a drive goes bad and the lower layers report an error to the
raid level can raid cope with the situation, remove the drive and keep
running. Unfortunately there seems to be a loose correlation between
cost of the controler (chip) and the likelyhood of a failing disk
locking up the system. I.e. the cheap onboard SATA chips on desktop
systems do that more often than expensive server controler. But that
is just a loose relationship.

MfG
        Goswin

PS: I've seen hardware raid boxes lock up too so this isn't a drawback
of software raid.
