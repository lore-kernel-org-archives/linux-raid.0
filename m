From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5: all devices marked spare, cannot assemble
Date: Thu, 12 Mar 2015 09:48:48 -0400
Message-ID: <55019940.4030104@turmel.org>
References: <550184D4.8060104@jive.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <550184D4.8060104@jive.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Boven <boven@jive.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Paul,

On 03/12/2015 08:21 AM, Paul Boven wrote:
> Hi folks,
> 
> I have a rather curious issue with one of our storage machines. The
> machine has 36x 4TB disks (SuperMicro 847 chassis) which are divided
> over 4 dual SAS-HBAs and the on-board SAS. These disks are in RAID5
> configurations, 6 raids of 6 disks each. Recently the machine ran out of
> memory (it has 32GB, and no swapspace as it boots from SATA-DOM) and the
> last entries in the syslog are from the OOM-killer. The machine is
> running Ubuntu 14.04.02 LTS, mdadm 3.2.5-5ubuntu4.1.

{BTW, I think raid5 is *insane* for this size array.}

> After doing a hard reset, the machine booted fine but one of the raids
> needed to resync. Worse, another of the raid5s will not assemble at all.
> All the drives are marked SPARE. Relevant output from /proc/mdstat (one
> working and the broken array):
> 
> md14 : active raid5 sdc1[2] sdag1[6] sde1[4] sdi1[3] sdz1[0] sdu1[1]
>       19534425600 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [6/6] [UUUUUU]
> 
> md15 : inactive sdd1[6](S) sdad1[0](S) sdy1[3](S) sdv1[4](S) sdm1[2](S)
> sdq1[1](S)
>       23441313792 blocks super 1.2

Although (S) implies spare, that's only true if the array is active.
md15 is assembled but not assembled.

> Using 'mdadm --examine' on each of the drives from the broken md15, I get:
> 
> sdd1: Spare, Events: 0
> sdad1: Active device 0, Events 194
> sdy1: Active device 3, Events 194
> sdv1: Active device 4, Events 194
> sdm1: Active device 2, Events 194
> sdq1: Active device 1, Events 194

Please don't trim the reports.  This implies that your array simply
didn't --run as it is unexpected degraded.

[trim /]

> md: kicking non-fresh sdd1 from array!
> md: unbind<sdd1>
> md: export_rdev(sdd1)
> md/raid:md15: not clean -- starting background reconstruction
> md/raid:md15: device sdy1 operational as raid disk 3
> md/raid:md15: device sdv1 operational as raid disk 4
> md/raid:md15: device sdad1 operational as raid disk 0
> md/raid:md15: device sdq1 operational as raid disk 1
> md/raid:md15: device sdm1 operational as raid disk 2
> md/raid:md15: allocated 0kB
> md/raid:md15: cannot start dirty degraded array.

Exactly.

> * Why does this raid5 not assemble? Only one drive (sdd) seems to be
> missing (marked spare), although I see no real issues with it and can
> read from it fine. There should still be enough drives to start the array.
> 
> # mdadm --assemble /dev/md15 --run

Wrong syntax.  It's already assembled.  Just try "mdadm --run /dev/md15"

> * How can the data be recovered, and the machine brought into production
> again

If the simple --run doesn't work, stop the array and force assemble the
good drives:

mdadm --stop /dev/md15
mdadm --assemble --force --verbose /dev/md15 /dev/sd{ad,q,m,y,v}1

If that doesn't work, show the complete output of the --assemble.

> * What went wrong, and how can we guard against this?

The crash prevented mdadm from writing the current state of the array to
the individual drives' metadata.  You didn't provide complete --examine
output, so I'm speculating, but the drives must disagree on the last
known state of the array ==> "dirty".  See "start_dirty_degraded" in man
md(4), and the --run and --no-degraded options to assemble.

In other words, unclean shutdowns should have manual intervention,
unless the array in question contains the root filesystem, in which case
the risky "start_dirty_degraded" may be appropriate.  In that case, you
probably would want your initramfs to have a special mdadm.conf,
deferring assembly of bulk arrays to normal userspace.

Phil
