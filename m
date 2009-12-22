From: Luca Berra <bluca@comedia.it>
Subject: imsm woes (and a small bug in mdadm)
Date: Tue, 22 Dec 2009 18:51:28 +0100
Message-ID: <20091222175128.GA18191@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline

Note for Neil/Dan:
This email could be long and boring, the attached patch prevents a
segfault on 3.0.3 and 3.1.1, at least have a look at it.

Hello,
I have this system at home I use for dev/testing/leisure/whatever.
it has an asus mb with an embedded intel 82801 sata fakeraid (imsm) with
two WD10EADS 1T disks.
I created a mirrored container with two volumes, first one windows the
second linux.
Yesterday windows crashed, no surprise there, the surprise was that
after the crash the controller marked the first drive as failed, instead
of running the usual verify.
I readded the drive from the windows storage manager console, and since
it told me rebuild would take 50+ hours i decided to leave it going.
(the windows software is idiotic, it tries to rebuild both volumes in
parallel)
In the morning i found the drive failed rebuild, so i replaced it (will
do some tests on it and rma when i have spare time).
In order to avoid waiting 50 hours to see if it finished i decided to
try rebuilding it under linux, the linux box used dmraid instead of
mdadm and was obviously unable to boot (did i ever mention redhat/fedora
mkinitrd sucks).
I booted linux from a rescue cd and rebuilt the raid using mdadm 3.0.2.
It took only 3 hours.
now real trouble started
After reboot the intel bios showed both drives as "Offline Member"
back to the rescue cd. mdadm 3.0.2 activated the container but the two
volumes were activated using only /dev/sda (NOTE: this is the new drive
i put in this same morning, not the old one)
Seeing that mdadm 3.0.3 had some fixes related to imsm i built that
instead and tried activating the array. unfortunately it segfaulted,
tried 3.1.1: same segfault
fire gdb, bt
found in super-intel.c around line 2430 a call to
disk_list_get with the serial of /dev/sdb as first argument, which fails
returning null.
created the attached patch and rebuilt mdadm.
still it activated the container with two drives and the volume with
only one.
i lost my patience and mdadm -r /dev/md/imsm0 /dev/sdb, mdadm -a ....

it is now rebuilding

i still have to see what bios thinks of the raid when i reboot


attached, besides the patch are
mdadm -Dsvv and mdadm -Esvv before and after the hot-remove-add, in case
someone has an idea about what might had happened.


Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="super-intel.diff"

--- super-intel.c.old	2009-12-22 17:53:56.154622836 +0000
+++ super-intel.c	2009-12-22 17:53:54.362629847 +0000
@@ -2428,6 +2428,7 @@
 			struct intel_disk *idisk;
 
 			idisk = disk_list_get(dl->serial, disk_list);
+			if(idisk) {
 			if (is_spare(&idisk->disk) &&
 			    !is_failed(&idisk->disk) && !is_configured(&idisk->disk))
 				dl->index = -1;
@@ -2435,6 +2436,7 @@
 				dl->index = -2;
 				continue;
 			}
+			}
 		}
 
 		dl->next = champion->disks;

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-Dsvv-after.txt"

/dev/md/imsm0:
        Version : imsm
     Raid Level : container
  Total Devices : 2

    Update Time : Tue Dec 22 17:59:45 2009
Working Devices : 2


           UUID : bee71637:467b6ae8:e1cf2626:185271b8
  Member Arrays :

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8        0        -        /dev/sda
/dev/md/Volume0_0:
      Container : /dev/md/127, member 0
     Raid Level : raid1
     Array Size : 488636416 (466.00 GiB 500.36 GB)
  Used Dev Size : 488636548 (466.00 GiB 500.36 GB)
   Raid Devices : 2
  Total Devices : 2

    Update Time : Tue Dec 22 17:58:39 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

      New Level : raid0
  New Chunksize : 1K


           UUID : 5ee03c91:f3537647:88da79af:38833b16
    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       2       8       16        1      spare rebuilding   /dev/sdb
/dev/md/Volume1_0:
      Container : /dev/md/127, member 1
     Raid Level : raid1
     Array Size : 488121344 (465.51 GiB 499.84 GB)
  Used Dev Size : 488121476 (465.51 GiB 499.84 GB)
   Raid Devices : 2
  Total Devices : 2

    Update Time : Tue Dec 22 17:58:39 2009
          State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Reshape Status : 0% complete
      New Level : raid0
  New Chunksize : 1K


           UUID : 81598ffc:8420e261:bf676997:6c7a894f
    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       2       8       16        1      spare rebuilding   /dev/sdb

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-Dsvv-before.txt"

/dev/md/imsm0:
        Version : imsm
     Raid Level : container
  Total Devices : 2

Working Devices : 2


           UUID : bee71637:467b6ae8:e1cf2626:185271b8
  Member Arrays :

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8        0        -        /dev/sda
/dev/md/Volume0_0:
      Container : /dev/md/127, member 0
     Raid Level : raid1
     Array Size : 488636416 (466.00 GiB 500.36 GB)
  Used Dev Size : 488636548 (466.00 GiB 500.36 GB)
   Raid Devices : 2
  Total Devices : 1

    Update Time : Tue Dec 22 17:57:04 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

      New Level : raid0
  New Chunksize : 1K


           UUID : 5ee03c91:f3537647:88da79af:38833b16
    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       0        0        1      removed
/dev/md/Volume1_0:
      Container : /dev/md/127, member 1
     Raid Level : raid1
     Array Size : 488121344 (465.51 GiB 499.84 GB)
  Used Dev Size : 488121476 (465.51 GiB 499.84 GB)
   Raid Devices : 2
  Total Devices : 1

    Update Time : Tue Dec 22 17:57:04 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

      New Level : raid0
  New Chunksize : 1K


           UUID : 81598ffc:8420e261:bf676997:6c7a894f
    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       0        0        1      removed

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-Esvv-after.txt"

/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : 0822300e
     Generation : 000312e2
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : c6d838da correct
    MPB Sectors : 2
          Disks : 2
   RAID Devices : 2

  Disk01 Serial : WD-WCAV51580865
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : 1 (out-of-sync)
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : normal <-- degraded
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : 1 (out-of-sync)
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : 0822300e
     Generation : 000312e2
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : c6d838da correct
    MPB Sectors : 2
          Disks : 2
   RAID Devices : 2

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : 0
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : normal <-- degraded
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : 0
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean

  Disk01 Serial : WD-WCAV51580865
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)
/dev/md127:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : 0822300e
     Generation : 000312e2
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : c6d838da correct
    MPB Sectors : 2
          Disks : 2
   RAID Devices : 2

  Disk01 Serial : WD-WCAV51580865
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : 1 (out-of-sync)
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : normal <-- degraded
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : 1 (out-of-sync)
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-Esvv-before.txt"

/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : b2ac231a
     Generation : 000312b0
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : 0085890a correct
    MPB Sectors : 2
          Disks : 1
   RAID Devices : 2

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : ?
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : ?
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : b2ac231a
     Generation : 000312dc
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : 00858936 correct
    MPB Sectors : 2
          Disks : 1
   RAID Devices : 2

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : 0
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : 0
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean
/dev/md127:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.00
    Orig Family : 1f641b4c
         Family : b2ac231a
     Generation : 000312dc
           UUID : bee71637:467b6ae8:e1cf2626:185271b8
       Checksum : 00858936 correct
    MPB Sectors : 2
          Disks : 1
   RAID Devices : 2

[Volume0]:
           UUID : 5ee03c91:f3537647:88da79af:38833b16
     RAID Level : 1
        Members : 2
      This Slot : ?
     Array Size : 977272832 (466.00 GiB 500.36 GB)
   Per Dev Size : 977273096 (466.00 GiB 500.36 GB)
  Sector Offset : 0
    Num Stripes : 3817472
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

[Volume1]:
           UUID : 81598ffc:8420e261:bf676997:6c7a894f
     RAID Level : 1
        Members : 2
      This Slot : ?
     Array Size : 976242688 (465.51 GiB 499.84 GB)
   Per Dev Size : 976242952 (465.51 GiB 499.84 GB)
  Sector Offset : 977277192
    Num Stripes : 3813448
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : migrating: rebuilding
      Map State : uninitialized <-- degraded
    Dirty State : clean

  Disk00 Serial : WD-WCAV51580780
          State : active
             Id : 00000000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

--T4sUOijqQbZv57TR--
