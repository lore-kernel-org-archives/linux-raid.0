From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: disappointed with 3ware 9550sx
Date: Sun, 10 Dec 2006 18:24:02 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0612101823510.10950@p34.internal.lan>
References: <Pine.LNX.4.64.0611122028510.596@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611122028510.596@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you contacted 3ware support?  They are very helpful.

Justin.

On Sun, 10 Dec 2006, dean gaudet wrote:

> i want to say up front that i have several 3ware 7504 and 7508 cards
> which i am completely satisfied with.  i use them as JBOD, and they make
> stellar PATA controllers (not RAID controllers).  they're not perfect
> (they're slow), but they've been rock solid for years.
> 
> not so the 9550sx.
> 
> i've been a software raid devotee for years now.  i've never wanted to 
> trust my data to hw raid, because i can't look under the covers and see 
> what it's doing, and i'm at the mercy of the vendor when it comes to 
> recovery situations.  so why did i even consider hw raid?  NVRAM.  i 
> wanted the write performance of NVRAM.
> 
> i debated between areca and 3ware, but given the areca driver wasn't in
> the kernel (it is now), the lack of smartmontools support for areca, and
> my experiences with the 7504/7508 i figured i'd stick with what i know.
> 
> sure i am impressed with the hw raid i/o rates on the 9550sx, especially
> with the NVRAM.  but i am unimpressed with several failures which have
> occured which evidence suggests are 3ware's fault (or at worst would
> not have resulted in problems with sw raid).
> 
> my configuration has 7 disks:
> 
> - 3x400GB WDC WD4000YR-01PLB0 firmware 01.06A01
> - 4x250GB WDC WD2500YD-01NVB1 firmware 10.02E01
> 
> those disks and firmwares are on the 3ware drive compatibility list:
> http://www.3ware.com/products/pdf/Drive_compatibility_list_9550SX_9590SE_2006_09.pdf
> 
> note that the compatibility list has a column "NCQ", which i read as an 
> indication the drive supports NCQ or not.  as supporting evidence for this 
> i refer to footnote number 4, which is specifically used on some drives 
> which MUST NOT have NCQ enabled.
> 
> i had NCQ enabled on all 7 drives.  perhaps this is the source of some of 
> my troubles, i'll grant 3ware that.
> 
> initially i had the firmware from the 9.3.0.4 release on the 9550sx
> (3.04.00.005) it was the most recent at the time i installed the system.
> (and the appropriate driver in the kernel -- i think i was using 2.6.16.x
> at the time.)
> 
> my first disappointment came when i tried to create a 3-way raid1 on the 
> 3x400 disks.  it doesn't support it at all.  i had become so accustomed to 
> using a 3-way raid1 with software raid it didn't even occur to me to find 
> out up front if the 3ware could support this.  apparently this is so 
> revolutionary an idea 3ware support was completely baffled when i opened a 
> ticket regarding it.  "why would you want that?  it will fail over to a 
> spare disk automatically."
> 
> still lured by the NVRAM i gave in and went with a 2-way mirror plus a 
> spare.  (i prefer the 3-way mirror so i'm never without a redundant copy 
> and don't have to rush to the colo with a replacement when a disk fails.)
> 
> the 4x250GB were turned into a raid-10.
> 
> install went fine, testing went fine, system was put into production.
> 
> 
> second disappointment:  within a couple weeks the 9550sx decided it
> didn't like one of the 400GB disks and knocked it out of the array.
> here's what the driver had to say about it:
> 
> Sep  6 23:47:30 kernel: 3w-9xxx: scsi0: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=0.
> Sep  6 23:47:31 kernel: 3w-9xxx: scsi0: AEN: ERROR (0x04:0x0002): Degraded unit:unit=0, port=0.
> Sep  6 23:48:46 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x000B): Rebuild started:unit=0.
> Sep  7 00:02:12 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x003B): Rebuild paused:unit=0.
> Sep  7 00:02:27 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x000B): Rebuild started:unit=0.
> Sep  7 09:32:19 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x0005): Rebuild completed:unit=0.
> 
> the 9550sx could still communicate with the disk -- the SMART log
> had no indications of error.  i converted the drive to JBOD and read and
> overwrote the entire surface without a problem.  i ended up just just
> converting the drive to the spare disk... but remained worried about
> why it could have been knocked out of the array.
> 
> maybe this is a WD bug, maybe it's a 3ware bug, who knows.
> 
> 
> third disappointment:  for a large data copy i inserted a disk into the
> remaining spare slot on the 3ware.  now i'm familiar with 750[48] where
> i run everything as JBOD and never let 3ware raid touch it.  when i
> inserted this 8th disk i found i had to ask tw_cli to create a JBOD.
> the disappointment comes here:  it zeroed the MBR!  fortunately the disk
> had a single full-sized partition and i could recreate the partition
> table, but there's no sane reason to zero the MBR just because i asked
> for the disk to be treated as JBOD (and don't tell me it'll reduce
> customer support cases because people might reuse a bad partition table
> from a previously raid disk -- i think it'll create even more problems
> than that explanation might solve).
> 
> 
> fourth disappointment:  heavy write traffic on one unit can affect
> other units even though they have separate spindles.  my educated
> guess is the 3ware does not share its cache fairly and the write
> traffic starves everything else.  i described this in a post here
> <http://lkml.org/lkml/2006/7/26/202>.
> 
> 
> fifth disappointment:  my earlier worries about a disk magically
> disappearing come true:
> 
> Nov 12 07:25:12 kernel: 3w-9xxx: scsi1: AEN: WARNING (0x04:0x0019): Drive removed:port=3.
> Nov 12 07:25:13 kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x0002): Degraded unit:unit=1, port=3.
> Nov 12 07:25:13 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x001A): Drive inserted:port=3.
> Nov 12 07:25:13 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x005E): Cache synchronization completed:unit=1.
> Nov 12 07:25:14 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x001F): Unit operational:unit=1.
> Nov 12 07:30:27 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x000B): Rebuild started:unit=1.
> Nov 12 13:08:33 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x0005): Rebuild completed:unit=1.
> Nov 12 13:09:50 kernel: sd 1:0:1:0: WARNING: (0x06:0x002C): Command (0x2a) timed out, resetting card.
> Nov 12 13:09:50 kernel: 3w-9xxx: scsi1: AEN: WARNING (0x04:0x004F): Cache synchronization skipped:unit=3.
> Nov 12 13:09:50 kernel: sd 1:0:1:0: Device not ready: <6>: Current: sense key: Not Ready
> Nov 12 13:09:50 kernel:     Additional sense: Logical unit not ready, cause not reportable
> Nov 12 13:09:50 kernel: end_request: I/O error, dev sdb, sector 254766831
> ... many more sdb error messages follow
> 
> i assure you the drive was not physically removed and reinserted at 07:25,
> nor were any tw_cli commands issued to do so.  but even worse is the
> apparently rebuilt array went offline at this point.
> 
> using tw_cli to tell the controller to rescan it found 1 of the 4 disks,
> but it had completely lost contact to the other 3.
> 
> i visited the box and physically ejected and reinserted the disks.
> here's the scariest thing of all:  the 3ware no longer recognized them
> as components of any raid it had ever seen before.
> 
> at a time like this with mdadm it would be trivial to recreate the array
> (assuming i know the original layout -- which i tend to keep track of
> for just this reason) and using "--assume-clean" i could be assured that
> a rebuild after recreate wouldn't toast my data.  i scoured the tw_cli
> man page and found no such capability.  i found nothing which gave me
> the confidence that using 3ware tools alone i could recreate this array.
> 
> so i removed the 4 disks, carefully labelling which port they were in
> and placed them in another box for forensic recovery.  i recovered the
> data after a few tries by forming a software raid0 with the right pair
> of disks (and a little help from xfs_repair).
> 
> unfortunately i couldn't replace the 9550sx at the time -- but i figured
> with sw raid10 (and write-intent bitmap) i'd have less hassle.  so i
> rebuilt the raid10 and put the disks back on the 9550sx (working around
> the JBOD MBR zeroing).
> 
> 
> sixth disappointment:  later the very same day:
> 
> Nov 12 21:31:40 kernel: 3w-9xxx: scsi1: AEN: ERROR (0x04:0x0002): Degraded unit:unit=0, port=0.
> Nov 12 21:33:36 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x001A): Drive inserted:port=0.
> Nov 12 21:36:40 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x000B): Rebuild started:unit=0.
> Nov 13 00:01:25 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x003B): Rebuild paused:unit=0.
> Nov 13 00:01:40 kernel: 3w-9xxx: scsi1: AEN: INFO (0x04:0x000B): Rebuild started:unit=0.
> 
> basically in this one day the 9550sx managed to lose 5 of 7 disks.
> 
> i'm really suspicious now -- the day before i had started graphing drive
> temperatures, which required a SMART operations every 5 minutes.  in the
> very distant past i'd experienced problems with promise ultra100tx2
> controllers where SMART would randomly cause them to lose a disk,
> requiring a reboot.  i suspect the cron job to be the source of
> my troubles this day -- so i disabled the cron job.
> 
> i also upgraded the firmware to the newer 9.3.0.7 release at this point.
> the release notes make passing mention of SMART but the problem
> description seems different.
> 
> 
> seventh disappointment:  during some maintenance the system was rebooted
> several times and at some point the 9550sx lost one of the disks from
> the raid1.  again it couldn't even talk to the port -- the disk had
> to be physically ejected/re-inserted before it could see it again (and
> naturally the 9550sx didn't think it was a raid component any more).
> 
> (i.e. the problem still happens with the latest released firmware
> 9.3.0.7.)
> 
> 
> eighth disappointment:  this is really just a nit, but the silly
> controller keeps coming up at a different address.  it's the only
> 3ware in the box but as of the latest reboot i have to address it with
> "tw_cli /c4"...  which of course screws my simple monthly cron job
> "tc_cli /c0/bbu test", now i need to "tw_cli info" and pick out the
> controller.
> 
> 
> conclusions:
> 
> yes, perhaps NCQ, SMART, or even the WD disks are to blame for some of
> this.  however i think the following summary are 3ware-specific problems:
> 
> - unable to recognize former raid components
> - lack of 3-way raid1
> - lack of bitmaps
> - zeroing MBR of JBOD
> - poor sharing of write cache across multiple units (partionable cache
>   would be ideal)
> - no equivalent of "mdadm --examine" to assist with forensics
> - no equivalent of --assume-clean
> 
> basically i've lost confidence in this controller/drive combo.  i don't
> think there'll be data corruption, but i'm convinced it's going to lose
> connectivity to disks requiring a physical visit to correct the problem.
> it has demonstrated time and again that even when presented with disks
> which were formerly portions of an array it doesn't recognize them.
> 
> the 3ware software lacks flexibility which i've become accustomed to
> from mdadm.  i have no confidence that with 3ware tools alone i'll be
> able to handle recovery situations.  thankfully sw raid enabled me to
> recover data from the dead hw raid10.
> 
> at first opportunity i'm going to at least drop the remaining hw raid1
> and set up a 3-way sw raid1.  i may replace the controller, or i might
> just live with the occasional physical visit -- it's a "devil i know"
> vs. "devil i don't know" call on that one... and perhaps there'll be a
> firmware rev which will help.
> 
> -dean
> 
> 
> p.s. for the record:  the 3ware Disk Control Block is at the tail of
> the disk similar to md 0.91/1.0 superblocks.  the DCB seems to be on
> the order of 100MB -- perhaps they engineered some extra space into the
> DCB to avoid hassles of slight disk size mismatches.  i haven't picked
> apart the DCB at all.  at any rate -- because of the DCB location you
> can recover 3ware arrays using sw raid on the entire disk without much
> trouble at all (i used --build when i did it, didn't want a superblock).
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
