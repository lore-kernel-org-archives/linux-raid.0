From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: Re: RAID5 causing lockups
Date: Wed, 25 Jun 2003 20:54:34 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306252054340612.008AB828@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, two of my drives did have an older bios, but the upgrade changed nothing.

I noticed that even unmounted, as long as I didn't raidstop the device, the system still crashes.

I tried setting down my bios as much as possible, and I am looking to do the same with the kernel, 2.4.21.  I'll try the magic sysrq key, but I can't find my nulmodem cable to save my life, so I'll have to barrow one from work.

My server marches on, but without /dev/md2... I'll try just letting it sit, /dev/md2 intact, over night, but for now, I need it up, even if it is only for fits and spurts.

Thanks everyone, keep the ideas rolling in.

<sigh>

>Hey folks,
>
>I just upgraded my system from a ~200GB mirror to a ~1TB RAID5, but all has
>not transitioned well.
>
>I really don't know how to debug this issue, though I have tried.  I gave
>up this morning before work, but I was going to try the magickey next
>(something I don't really know how to use, but anything for a clue)
>followed by upgrading to 2.4.21.
>
>The lock up is typical to a system with a failing drive; the system is
>responsive to input, but nothing happens.  Keyboard works fine, but
>programs become idle (not really crashing.)  I tried keeping "top" up,
>hoping I would see something obvious, like raid5syncd doing something
>strange, but if it does, top doesn't update after the problem.
>
>The lockups happen even if the system is doing nothing (other than
>raid5syncd, which is awfully busy since my RAID won't stay up)
>
>If I unmount the RAID5 and RAIDSTOP it, my system will work fine, but I'm
>out 1TB of disk.  Right now, I have it running the bare essentials (all
>services on, but my /home directory has only public_html and mail stuff for
>each user.)
>
>Anything I can do to get more information out of this problem?  I don't
>really know where to look.
>
>
>System Infro
>=======================================================================
>
>My kernel is 2.4.20, my raid tools is raidtools-0.90, no patches on
>anything, home built distro (linux from scratch.)  Had been running on a
>mirror for nearly a year.
>
>Each drive on my system is connected to promise UltraATA 100 controllers.
>I have 6 drives and 3 controllers.  Each drive is a 200GB WD drive, set to
>"Single/Master" on their channel.
>
>No device has a slave.
>
>Drives are hda hdc hde hdg hdi hdk
>
>------- Each drive is configured exactly like the device below -------
>
>Disk /dev/hda: 255 heads, 63 sectors, 24321 cylinders
>Units = cylinders of 16065 * 512 bytes
>
>   Device Boot    Start       End    Blocks   Id  System
>/dev/hda1             1       319   2562336   fd  Linux raid autodetect
>/dev/hda2           320       352    265072+  82  Linux swap
>/dev/hda3           353     24321 192530992+  fd  Linux raid autodetect
>
>------------------------- Here is my raidtab -------------------------
>
>raiddev /dev/md0
>   raid-level            1
>   chunk-size           32
>   nr-raid-disks         2
>   nr-spare-disks        0
>   persistent-superblock 1
>   device        /dev/hda1
>   raid-disk             0
>   device        /dev/hdc1
>   raid-disk             1
>
>raiddev /dev/md1
>   raid-level            1
>   chunk-size           32
>   nr-raid-disks         2
>   nr-spare-disks        0
>   persistent-superblock 1
>   device        /dev/hde1
>   raid-disk             0
>   device        /dev/hdg1
>   raid-disk             1
>
>raiddev /dev/md2
>   raid-level            5
>   chunk-size           32
>   nr-raid-disks         6
>   nr-spare-disks        0
>   persistent-superblock 1
>   device        /dev/hda3
>   raid-disk             0
>   device        /dev/hdc3
>   raid-disk             1
>   device        /dev/hde3
>   raid-disk             2
>   device        /dev/hdg3
>   raid-disk             3
>   device        /dev/hdi3
>   raid-disk             4
>   device        /dev/hdk3
>   raid-disk             5
>
>raiddev /dev/md3
>   raid-level            1
>   chunk-size           32
>   nr-raid-disks         2
>   nr-spare-disks        0
>   persistent-superblock 1
>   device        /dev/hdi1
>   raid-disk             0
>   device        /dev/hdk1
>   raid-disk             1
>
>-------------------------- Here is my fstab --------------------------
>
># Begin /etc/fstab
>
># filesystem   mount-point     fs-type    options           dump fsck-order
>
>/dev/md0       /               reiserfs   defaults             1 1
>/dev/md1       /mnt/backup     reiserfs   noauto,defaults      1 3
>/dev/md2       /home           reiserfs   defaults             1 2
>/dev/hda2      swap            swap       pri=42               0 0
>/dev/hdc2      swap            swap       pri=42               0 0
>/dev/hde2      swap            swap       pri=42               0 0
>/dev/hdg2      swap            swap       pri=42               0 0
>/dev/hdi2      swap            swap       pri=42               0 0
>/dev/hdk2      swap            swap       pri=42               0 0
>proc           /proc           proc       defaults             0 0
>
># End /etc/fstab
>
>=======================================================================
>
>Let me know if I missed anything (probably lots.)
>
>Thanks for your time.
>
>
>/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\
>
>coreyfro@coreyfro.com
>http://www.coreyfro.com/
>http://stats.distributed.net/rc5-64/psummary.php3?id=196879
>ICQ : 3168059
>
>-----BEGIN GEEK CODE BLOCK-----
>GCS d--(+) s: a-- C++++$ UBL++>++++ P+ L+ E W+++$ N+ o? K? w++++$>+++++$
>O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+)
>Dl++(++++) D++ G+ e>+++ h++(---) r++>+$ y++*>$ H++++ n---(----) p? !au w+
>v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
>------END GEEK CODE BLOCK------
>
>Home of Geek Code - http://www.geekcode.com/
>The Geek Code Decoder Page - http://www.ebb.org/ungeek//
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\

coreyfro@coreyfro.com
http://www.coreyfro.com/
http://stats.distributed.net/rc5-64/psearch.php3?st=coreyfro
ICQ : 3168059

-----BEGIN GEEK CODE BLOCK-----
GCS !d--(+) s: a- C++++$ UL++>++++ P+ L++>++++ E- W+++$ N++ o? K? w++++$>+++++$ O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+) Dl++(++++) D++ G++(-) e>+++ h++(---) r++>+$ y++**>$ H++++ n---(----) p? !au w+ v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
------END GEEK CODE BLOCK------

Home of Geek Code - http://www.geekcode.com/
The Geek Code Decoder Page - http://www.ebb.org/ungeek//

