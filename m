From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sat, 20 Nov 2004 18:09:53 -0500
Message-ID: <200411202309.iAKN9xN18810@www.watkins-home.com>
References: <Pine.LNX.4.44.0411201657570.19120-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411201657570.19120-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You got any links related to this?
"the deathstar incident was actually bad firmware"

Can a user download and update the firmware?

If so, I know someone that may have some bad disks that are not so bad.

If he can repair his disks, I will report the status back on this list.

Previously I thought IBM made very good disks, until my friend had more than
a 75% failure rate.  And within the warranty period.

I personally have an IBM SCSI disk that is running 100% of the time, and the
cooling is real bad.  The drive is much too hot to touch.  Been like that
for 5+ years.  Never had any issues.  The system also has a Seagate that is
too hot to touch, but only been running 3+ years.  Both are 18 Gig.  The
disks are in a system my wife uses!  Don't tell her. :)  I got to fix that
someday.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Saturday, November 20, 2004 5:18 PM
To: linux-raid@vger.kernel.org
Subject: RE: Good news / bad news - The joys of RAID

> SATA / IDE drives have an MTBF similar to that of SCSI / Fibre. But this
> is based upon their expected use... i.e. SCSI used to be [power on hours
> = 24hr] [use = 8 hours].. whilst SATA used to be [power on = 8 hours]
> and [use = 20 mins].

the vendors I talk to always quote SCSI/FC at 100% power 100% duty,
and PATA/SATA at 100% power 20% duty.

> Regardless of what some people clam (usually those that only sell sata
> based raids), the drives are not constructed the same in any way.

obviously, there *have* been pairs of SCSI/ATA disks which had 
identical mech/analog sections.  but the mech/analog fall into 
just two kinds:

	- optimized for IOPS: 10-15K rpm for minimal rotational 
	latency, narrow recording area for low seek distance,
	quite low bit and track density to avoid long waits for 
	the head to stabilize after a seek.

	- optimized for density/bandwidth: high bit/track density,
	wide recording area, modest seeks/rotation speed.

the first is SCSI/FC and the second ATA, mainly for historic reasons.

> SATA's fail more within a raid environment (probably around 10:1)
> because of the heavy use and also because they are not as intelligent...

what connection are you drawing between raid and "heavy use"?
how does being in a raid increase the IO load per disk?

> therefore when they do not respond we have no way of interrogating them
> or resetting them, whilst with scsi we do both. 

you've never seen a SCSI reset that looks just like an ATA reset?
sorry, but SCSI has no magic.

> This means that a raid
> controller / driver has no option to but simply fail the drive.

no.

> Maxtor lead the way in capacity and also reliability... I personal had
> to recall countless earlier IBMs and replace them with maxtor.  But the

afaikt, the deathstar incident was actually bad firmware 
(didn't correctly flush data when hard powered off, resulting in 
blocks on disk with bogus ECC, which had to be considered bad from
then on, even if the media was perfect.)

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

