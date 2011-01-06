From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Considering a complete rework of RAID on my home compute server
Date: Wed, 5 Jan 2011 18:03:47 -0600
Message-ID: <87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> 1) The Linux/MySQL stuff is a 3 drive RAID1. (sda/sdb/sdc)

	Well, RAID1 certainly offers the most robust solution, especially
with more than 1 mirror.

> 2) The Windows VMs run on a 2 drive RAID0 (sdd/sde)

	Given the relatively small drive size (500G), I think I would
probably replace that with a single drive, if you want to keep the overall
architecture.

> 3) There is a second RAID1 (sda/sdb/sdc) used for backups of the
> RAID0. The RAID0 is backed up to RAID1 nightly. If the RAID0 fails
> then I lose 1 day's work.

	Well, first of all, unless you meant to say sda1/sdb1/sdc1, etc,
then this can't be different from the #1 RAID array above.  Assuming you are
actually using partitions, then I don't really see the value of two separate
arrays.  Why not just one RAID1 array?

	Also, I personally would reverse the backup strategy.  I would put
the Windows VM on the (single) main RAID array and back up the data to a
single 1T hard drive.

>    OK - the problems I have with this arrangement are:
> 
> 1) I used the older v0.9 metadata.

	This may be necessary if you are booting from the array.  The
limitations of the 0.90 superblock may never impact you.  That's a small
system with only a few drives.

> 2) The RAIDs are assembled by the kernel automatically. I do not use
> an initrd. (Because I don't know how/newer have)

	How is that a problem?  An initrd, or lack thereof, won't prevent
you from disabling the automatic assembly of one or more arrays, unless once
again you boot from the array in question.  Most modern distros default to
using an initrd.  What distro are you using?

> 3) I think with 5 disks I could get better performance  than I
> currently get , with similar or better safety using maybe RAID5 or
> RAID6.

	No, RAID1 is as safe as it gets.  RAID0 allows for better
performance, but if you make the RAID0 into your backup solution, the
performance won't matter much.

	Is performance a really big issue?  Are you having problems with bad
performance?

>    Overall, as I see it, I can suffer no disk loss on the RAID0, and
> can handle a 2 disk loss on the RAID1. (Is that correct?) I'm thinking
> that with a 5-drive RAID6 I might well get better performance than
> either of the current RAIDs and (from reading) more protection during
> a rebuild if one of my drives goes bad.

	A single RAID5 or RAID6 solution is certainly simpler, and there is
significant value there.  Read performance should be enhanced, but write
performance will be impacted.  You've also lost your backup solution in this
scenario, though, so you will need to come up with something.

>    All said, I'm leaning toward RAID6 support everything (MySQL and
> VMs), probably about 100GB to start with, and then would hopefully
> scale the size up using the rest of the drives after data is copied
> over to the new RAID6. I'd build RAID6, copy everything from the
> current system, ensure the new RAID boots, etc, then eventually blow
> away the old partitions and resize the RAID 6 larger.
> 
>    Does this make sense? What am I missing or should be thinking about.

	I would worry that you are blowing away your backup.

>    I have no problem buying maybe 1 new drive now as a spare. The
> chassis is filled at this time and there's no way to run what I think
> is considered a hot spare.

	You might consider an external enclosure.  Enclosures for up to 5
dives are quite economical.

