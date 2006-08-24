From: Mickael Marchand <mikmak@freenux.org>
Subject: strange raid6 assembly problem
Date: Thu, 24 Aug 2006 14:31:26 +0200
Message-ID: <20060824123126.GP4670@kyu.freenux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am having a little fun with a raid6 array these days.
kernel : 2.6.17.10-if.1 #1 SMP Wed Aug 23 11:25:03 CEST 2006 i686
GNU/Linux
Debian sarge and backported mdadm 2.4.1

here is the initial shape of the array :
/dev/md2 /dev/sda2,/dev/sdb2(F),/dev/sdc3,/dev/sdd3,/dev/sdf3

so sdf3 is a new device, it was resyncing and then sdb2 failed reading
some sector, md so marked it as fail and stopped the resync 
it then started resyncing the sdf3 again
interestingly I would have hoped that it did not start from 0 again, 
but it did so, not fun ;), I guess the code to recover a resync when a 
non-fatal read error occurs is not written yet (or maybe not possible at
all) ?

so the array was still degraded with sdb2 missing but sdf3 was marked as
sync-ed and active when I cleanly powered-off the machine.

I changed another hard drive (for other arrays,md2 was not concerned
here) and booted it back.

during the boot, kernel autodetects arrays and starts them (yeah that's
bad but I don't really like initrds ;)

it told me :
md: considering sdf3 ...
md:  adding sdf3 ...
md: sdf2 has different UUID to sdf3
md: sdf1 has different UUID to sdf3
md: sdd6 has different UUID to sdf3
md: sdd5 has different UUID to sdf3
md:  adding sdd3 ...
md: sdd2 has different UUID to sdf3
md: sdd1 has different UUID to sdf3
md: sdc6 has different UUID to sdf3
md: sdc5 has different UUID to sdf3
md:  adding sdc3 ...
md: sdc2 has different UUID to sdf3
md: sdc1 has different UUID to sdf3
md: sdb3 has different UUID to sdf3
md:  adding sdb2 ...
md: sdb1 has different UUID to sdf3
md: sda3 has different UUID to sdf3
md:  adding sda2 ...
md: sda1 has different UUID to sdf3
md: created md2
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc3>
md: bind<sdd3>
md: export_rdev(sdf3)
md: running: <sdd3><sdc3><sdb2><sda2>
md: kicking non-fresh sdb2 from array!
md: unbind<sdb2>
md: export_rdev(sdb2)
raid6: device sdd3 operational as raid disk 2
raid6: device sdc3 operational as raid disk 4
raid6: device sda2 operational as raid disk 0
raid6: allocated 5245kB for md2
raid6: raid level 6 set md2 active with 3 out of 5 devices, algorithm 2
RAID6 conf printout:
 --- rd:5 wd:3 fd:2
disk 0, o:1, dev:sda2
disk 2, o:1, dev:sdd3
disk 4, o:1, dev:sdc3

so, well, it dropped sdb2 which looks fine to me, but I don't understand
what happened to sdf3 which should have been added and started like
other disks ?
it was completely removed from the array (not shown at all in
/proc/mdstat) and the array appeared with 2 missing drives.

Maybe I missed some point or forgot something after the resync of md2
with sdf3 but it looked fine to me before the reboot (worked all night
long actually)
sdf3 correctly has type 'fd' in fdisk

right now I made it sync-ed with a spare drive (sde3), worked apparently
fine :
md2 : active raid6 sde3[1] sdd3[2] sdc3[4] sda2[0]
      395511936 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U]
and still missing one drive.

so basically I don't really know what to do with my sdf3 at the moment
and fear to reboot again :o)
maybe a --re-add /dev/sdf3 could work here ? but will it survive a
reboot ?

any tips welcome,

Cheers,
Mik
PS: CC-me please as I am not subscribed

current state:
/dev/md2:
        Version : 00.90.03
  Creation Time : Sat Dec 31 02:00:58 2005
     Raid Level : raid6
     Array Size : 395511936 (377.19 GiB 405.00 GB)
    Device Size : 131837312 (125.73 GiB 135.00 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Aug 24 14:21:55 2006
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 7325e599:6860a9aa:0214c796:b42657ae
         Events : 0.34328093

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       67        1      active sync   /dev/sde3
       2       8       51        2      active sync   /dev/sdd3
       3       0        0        3      removed
       4       8       35        4      active sync   /dev/sdc3
