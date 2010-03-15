From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Growing after replacing with larger discs
Date: Mon, 15 Mar 2010 16:17:52 +0100
Message-ID: <4B9E4FA0.9060609@stud.tu-ilmenau.de>
References: <4B9A7C63.6090202@anonymous.org.uk> <20100312180910.GA12002@maude.comedia.it> 	<4B9BACC4.8030608@anonymous.org.uk> <70ed7c3e1003130721u29cf938ep9313a10078ee5e52@mail.gmail.com> 	<4B9BD5C0.2050902@anonymous.org.uk> <70ed7c3e1003131022o78b065b3oadeb1a309cdc995f@mail.gmail.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003131022o78b065b3oadeb1a309cdc995f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Am 13.03.2010 19:22, schrieb Majed B.:
> What I meant was: If you use dd to clone an old disk to a new one of a
> larger size, metadata isn't where it should be and the new disk won't
> be recognized as part of an array.

I mean to have read that he uses 0.9 metadata.  mdadm finds the device
size (i.e. partition size) and locates the metadata according to that.
So if he has partitioned the drives containing the raid, the dd-way
should work on one hand (if he clones the complete drive, not only the
partitions).  On the other hand he'd have a backup at hand if something
goes terribly wrong.  Or might I be mistaken now?

> So if you do that to all disks, then attempt to create a new array on
> the new disks, it will cause a resync. And even if it didn't resync,
> data mapping may be incorrect.

I second that - recreating is only good on same size devices - but
again: if the partition is same size, it should work.
> 
> For argument's sake, let's assume that cloning the disks would work.
> It means cloning 3 disks.

Yes, using sgp_dd this works very well and quickly.  And you don't have
problems arising from broken read-sectors being skipped. (yes, I know
there is conv=noerror,sync; but I had my problems with that...)

> The other option that you presented, which I hope you avoid, is
> degrading the array and presenting the new disks. This would also
> require 3 resyncs.

Yes, that is a bad idea.

> The option where you copy the data off the old array then back to the
> new one consist of 2 copy operations only. May not be as fast as a dd
> operation, but still should consume less time than 3 resyncs.

right on one hand.  the other hand is: on my laboratory computer (which
is used for raid-recoveries and such) 4 parallel sgp_dd operations work
at about 90MB/s (if the drives are quick enough, starting with 115MB/s,
and sinking speed as the r/w-heads move outside).  But one copy only
reaches 50MB/s.  Multiple parallel copies do not give any speedup.
> 
> Also, while copying the original data, if the filesystem has problems,
> you'll see them right away and probably identify which files are
> affected. I hope everything goes smooth for you, but in case such
> problems occur, do NOT run fsck!

second that - if fsck is needed, create a dd-backup to run it on.

> Clone the filesystem first for best assurance of data safety.
> 
> Good luck!
> 
[...]

Also my best wishes for the operation...

Stefan
