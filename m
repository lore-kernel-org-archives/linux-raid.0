From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: So what is the bios doing, if anything ?
Date: Sat, 18 Sep 2004 09:53:03 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0409180940500.12827-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.56.0409181413470.32100@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0409181413470.32100@lion.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > My mobo has "bios" support for the nVidia nForce3 250Gb and SI 3114. In
> > the case of linux, is this doing anything for me ? Do I just ignore it ?
> > At present (80GB mirror), the two SATA drives show up as ide3 and ide4.

if the disks show up as separate disks, then the bios is not doing any raid
for you.  chances are that all it *could* do is concat, raid0 or raid1;
the issue is that these require the kernel to understand the organization
(as recorded in a superblock of some sort) that the bios is using.

theoretically, you might notice some performance advantage to using even
plain old raid1 provided by a controller, since it could avoid passing 
every write over the PCI twice.  I don't know whether low-end controllers
can actually do this, or whether they really do nothing but software raid1.
personally, my worry would be failure modes.

> expect ~50-55MB/sec out of an ordinary IDE drive these days. MAybe it's
> still early days for the driver though.

sata drivers are a pretty fast-moving target.

> I haven't spent much time looking into the SATA stuff yet - but it seems
> theres 2 camps - one which makes the drives look like IDE drives and one
> which makes the look like SCSI.. I did an install on a Dell last week

sort of but not really.  sata hardware can be shoehorned into the older
pata-oriented infrastructure by ignoring some features.  the real problem
is that the traditional ide driver framework is not exactly beautiful
on the inside, and some of those ignored features are pretty important.
I believe that the general consensus is to move towards the scsi stack,
though this doesn't mean the ide stack will disappear any time soon,
if ever.  I wouldn't expect 3Gb sata to ever appear in the ide stack,
or for hotplug to work right, or command queueing or device multiplexing.
this is not so much a criticism of the ide stack, but rather an evaluation
that it's easier to build onto the scsi framework.

regards, mark hahn.


