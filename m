From: Blair Strater <me@r000t.com>
Subject: Intel RAID problems
Date: Wed, 9 Nov 2011 23:26:04 -0600
Message-ID: <CAGUTeF1qgu86YHXUQ3VGtQYM1akzXkrmuybRq-hPn-cM5+TL7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

In Windows, I created a RAID-5 array on my Intel Matrix Storage
Manager compatible chipset. Across 5 500GB drives, I made a volume
named VIDEODATA. It finished initializing on Windows and is currently
in a Migrate state that will take a total of 36 to complete (so if
that's the problem I'll just blow up the array and make a new one
which will only take 12 hours to initialize).

The array works fine in Windows but it will not work in Linux (Ubuntu
11.10 x64) under mdadm or dmraid. dmraid just creates a mapper that
claims to have no partitions (an obvious lie), is reported as 2TB when
the array is actually 1.8TB, and is generally useless.

I tried to start the array in mdadm (after uninstalling dmraid and
rebooting) but it thinks the array contains 5 spares. In 'disk
utility', RAID array /dev/md127 is listed as "Not running, partially
assembled".

I'm very confused as to how to continue at this point.

Here is some output someone told me the list would want:

r000t@editsuite-linux:~$ sudo mdadm -Q /dev/md/imsm0
/dev/md/imsm0: 0.00KiB (null) 0 devices, 5 spares. Use mdadm --detail
for more detail.



r000t@editsuite-linux:~$ sudo mdadm --detail-platform
       Platform : Intel(R) Matrix Storage Manager
        Version : 5.6.2.1002
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
      Max Disks : 6
    Max Volumes : 2
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
          Port0 : /dev/sda (GTA400P6G02A8A)
          Port1 : /dev/sdb (GTA400P6G03HKA)
          Port2 : /dev/sdc (9QG2M7BR)
          Port3 : /dev/sdd (9QG2NHD6)
          Port4 : /dev/sde (9QG2SD30)
          Port5 : /dev/sdf (6VPFRLN5)



r000t@editsuite-linux:~$ sudo mdadm -Asvv
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdf6
mdadm: /dev/sdf6 has wrong uuid.
mdadm: cannot open device /dev/sdf5: Device or resource busy
mdadm: /dev/sdf5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf2
mdadm: /dev/sdf2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf1
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: looking for devices for /dev/md/VIDEODATA
mdadm: no recogniseable superblock on /dev/sdf6
mdadm/dev/sdf6 is not a container, and one is required.
mdadm: cannot open device /dev/sdf5: Device or resource busy
mdadm/dev/sdf5 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/sdf2
mdadm/dev/sdf2 is not a container, and one is required.
mdadm: no recogniseable superblock on /dev/sdf1
mdadm/dev/sdf1 is not a container, and one is required.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm/dev/sdf is not a container, and one is required.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm/dev/sde is not a container, and one is required.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm/dev/sdd is not a container, and one is required.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm/dev/sdc is not a container, and one is required.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm/dev/sdb is not a container, and one is required.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm/dev/sda is not a container, and one is required.
r000t@editsuite-linux:~$


r000t@editsuite-linux:~$ sudo mdadm -E /dev/sda /dev/sdb /dev/sdc
/dev/sdd /dev/sde
[sudo] password for r000t:
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.04
    Orig Family : 00000000
         Family : 07da212a
     Generation : 00000221
           UUID : a26d8bae:238c5fe7:ca705d0b:06559902
       Checksum : 92cd3ca7 correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 1

  Disk00 Serial : GTA400P6G02A8A
          State : active
             Id : 00000000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

[VIDEODATA]:
           UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
     RAID Level : 5
        Members : 5
          Slots : [UUUUU]
      This Slot : 0
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
  Sector Offset : 3840
    Num Stripes : 7630848
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 7238714 (0)
    Dirty State : clean

  Disk01 Serial : GTA400P6G03HKA
          State : active
             Id : 00010000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk02 Serial : 9QG2M7BR
          State : active
             Id : 00020000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk03 Serial : 9QG2NHD6
          State : active
             Id : 00030000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk04 Serial : 9QG2SD30
          State : active
             Id : 00040000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)
/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.04
    Orig Family : 00000000
         Family : 07da212a
     Generation : 00000221
           UUID : a26d8bae:238c5fe7:ca705d0b:06559902
       Checksum : 92cd3ca7 correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 1

  Disk01 Serial : GTA400P6G03HKA
          State : active
             Id : 00010000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

[VIDEODATA]:
           UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
     RAID Level : 5
        Members : 5
          Slots : [UUUUU]
      This Slot : 1
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
  Sector Offset : 3840
    Num Stripes : 7630848
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 7238714 (0)
    Dirty State : clean

  Disk00 Serial : GTA400P6G02A8A
          State : active
             Id : 00000000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk02 Serial : 9QG2M7BR
          State : active
             Id : 00020000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk03 Serial : 9QG2NHD6
          State : active
             Id : 00030000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk04 Serial : 9QG2SD30
          State : active
             Id : 00040000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)
/dev/sdc:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.04
    Orig Family : 00000000
         Family : 07da212a
     Generation : 00000221
           UUID : a26d8bae:238c5fe7:ca705d0b:06559902
       Checksum : 92cd3ca7 correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 1

  Disk02 Serial : 9QG2M7BR
          State : active
             Id : 00020000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

[VIDEODATA]:
           UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
     RAID Level : 5
        Members : 5
          Slots : [UUUUU]
      This Slot : 2
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
  Sector Offset : 3840
    Num Stripes : 7630848
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 7238714 (0)
    Dirty State : clean

  Disk00 Serial : GTA400P6G02A8A
          State : active
             Id : 00000000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk01 Serial : GTA400P6G03HKA
          State : active
             Id : 00010000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk03 Serial : 9QG2NHD6
          State : active
             Id : 00030000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk04 Serial : 9QG2SD30
          State : active
             Id : 00040000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)
/dev/sdd:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.04
    Orig Family : 00000000
         Family : 07da212a
     Generation : 00000221
           UUID : a26d8bae:238c5fe7:ca705d0b:06559902
       Checksum : 92cd3ca7 correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 1

  Disk03 Serial : 9QG2NHD6
          State : active
             Id : 00030000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

[VIDEODATA]:
           UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
     RAID Level : 5
        Members : 5
          Slots : [UUUUU]
      This Slot : 3
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
  Sector Offset : 3840
    Num Stripes : 7630848
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 7238714 (0)
    Dirty State : clean

  Disk00 Serial : GTA400P6G02A8A
          State : active
             Id : 00000000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk01 Serial : GTA400P6G03HKA
          State : active
             Id : 00010000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk02 Serial : 9QG2M7BR
          State : active
             Id : 00020000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk04 Serial : 9QG2SD30
          State : active
             Id : 00040000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)
/dev/sde:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.2.04
    Orig Family : 00000000
         Family : 07da212a
     Generation : 00000221
           UUID : a26d8bae:238c5fe7:ca705d0b:06559902
       Checksum : 92cd3ca7 correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 1

  Disk04 Serial : 9QG2SD30
          State : active
             Id : 00040000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

[VIDEODATA]:
           UUID : 0fde6e5c:22bb0f3f:c8808bf6:0e51ed62
     RAID Level : 5
        Members : 5
          Slots : [UUUUU]
      This Slot : 4
     Array Size : 3906994176 (1863.00 GiB 2000.38 GB)
   Per Dev Size : 976748808 (465.75 GiB 500.10 GB)
  Sector Offset : 3840
    Num Stripes : 7630848
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : general migration
      Map State : normal <-- normal
     Checkpoint : 7238714 (0)
    Dirty State : clean

  Disk00 Serial : GTA400P6G02A8A
          State : active
             Id : 00000000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk01 Serial : GTA400P6G03HKA
          State : active
             Id : 00010000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk02 Serial : 9QG2M7BR
          State : active
             Id : 00020000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

  Disk03 Serial : 9QG2NHD6
          State : active
             Id : 00030000
    Usable Size : 976768654 (465.76 GiB 500.11 GB)

Thanks in advance for any help you guys may be able to provide.
