From: David Reniau <david.reniau@gmail.com>
Subject: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Mon, 24 May 2010 14:40:25 +0200
Message-ID: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Linux-Raid list,





------------------------

My problem in a nutshell:

------------------------



I am unable to mount a RAID-0 (EXT3?) filesystem which I previously
assembled with mdadm under Ubuntu 9.10 32bitx. This RAID-0 array was
originally created by my NAS Thecus N4100.



I am getting the following console message:



mount: wrong fs type, bad option, bad superblock on /dev/md0,

missing codepage or helper program, or other error

In some cases useful info is found in syslog - try

dmesg | tail or so



See test [T007] below for detailed messages.



In other words, I cannot recover my stored data.



Can you help? It's crucial to me.



Thanks in advance,



David







------------------------

My story in (very) short:

------------------------



I own a NAS Thecus N4100 -- works perfectly -- with 4 x 400GB disks
running as a RAID-0 array. No physical disk error, RAID is perfectly
sain.



In Feb 2010, I (had to) extract(ed) the 4 disks off the NAS rack in
order to remount the RAID under a regular Linux box. I placed the 4
disks in USB cases, labelled the cases (1,2,3,4) according to the
disks genuine order in the NAS rack (see Figure 1 below), and tried to
rebuild the RAID-0 array by means of mdadm under Ubuntu 9.10, using
the disks connection situation depited in Figure 2.



After several trial and error manipulations (not only, but in
particular, to regenerate the RAID superblocks), I was able to
re-create the RAID-0 array but... I am unable to mount the RAID file
system in the end.



Panik: I attempted to insert the disks back to the NAS to check
whether the RAID was still "alive" in the NAS. The NAS rebooted for
about 10 minutes (what did it do? I do not know), then reported that
my RAID configuration was gone. I wrote nothing to the NAS, I properly
shut the NAS down, and put the disks back to their USB cases in order
to resolve this RAID issue (if resolvable?) with mdadm.



I performed several tests (reported below) which formally describe the
situation I am facing.



I do need your help to understand what is wrong and whether (and how)
to solve this issue.




NOTE: I am currently working with 4 disk images of my physical disks
as depicted by Figure 3 below, so I can safely perform destructive
tests and manipulations you suggest me, with no risk for the original
disks. I (only...) need 15 hours to recreate a disk image set.
=2E.






-----------------

My main questions:

-----------------



1) Test [T006]

   ***********



(1.1) Is there something / what is wrong my with my RAID superblocks?



mdadm accepts to assemble the disks, reports a sain RAID, BUT mdadm -D
details about each disk unexceptingly reference a fixed /dev/sdc2
partition in the array, which is no way involved in the array
(although there is an existing /dev/sdc2 partition on my /dev/sdc
disk).

(1.2) Can this be a source of the problems?



(1.3) Can this so-called RAID superblock inconsistency due to some
deeper EXT2/3 filesystem issue or corruption mentioned in question 2
below?

(1.4) How can I practically perform a deep RAID superblock check on
each disk other than mdadm -D /dev/diskN that would make such an
inconsistency explanable?






2) Test [T007]:  EXT2/3 file system issues

   ***************************************



(2.1) Do I FIRST need to resolve the EXT2/3 filesystem issues reported
when mounting the RAID filesystem (therefore considering the EXT2/3
induces the RAID isssue)?



(2.2) Or reversely: are the EXT2/3 issues the consequence of a RAID iss=
ue?



(2.3) At which level do I need to work in order to solve this issue out=
?


(2.4) Any work methodology advice is welcome...


3) Do I need to recover my RAID partition in order to mount it, or is
there any RAID-related manipulation, configuration I missed with
mdadm, which prevents me from mounting it?





4) Test [T003]

   ***********



The tests performed with Palimpsest report a 201 MB "unknown" partition=
:



(4.1) Where does this disk zone come from?


(4.2) Was it accidentally created by the NAS when the disks were
re-inserted back to its rack? (sent a ticket to Thecus support about
this point - no answer yet).


(4.3) Is this 201MB unkown zone a RAID-0 disk feature common to all
RAID-0 arrays? If yes, what is this zone supposed to contain?

(4.4) If yes to question (4.2): does this mean my RAID-0 data are
definively lost because the N4100 implicitly deleted a part of the
RAID partition?






5) Tests [T010] to [T012]

   **********************



Test executed with Testdisk report a Linux partition that seems to be
living beside the RAID component partition, and could be a "lost"
partition buried in the 201MB unknown zone.



(5.1) Is this partition a feature in RAID-0 arrays?



(5.2) Is this an inconsistency caused by missusing mdadm? Or by the
NAS when the disks were inserted back to their rack?



(5.2) How can I resolve that?





6) Any piece of advice, test to perform, manipulations, etc are welcome=
=2E









----------------------------------

THECUS N4100 initial configuration:

----------------------------------



- Firmware            : 1.3.06 (SSH plugin installed)

- RAID Level          : RAID-0

- Disks               : 4 x Seagate Baracuda ST3400832AS 400 GB

- Total RAID capacity : 1.6 TB

- Used space          : around 75%





- Seagate ST3400832AS features (from manufacturer):



  * Total capacity    : 400 GB

  * Usable capacity   : 372.6 GB

  * Cylinders         : 16383

  * Heads             : 16

  * Sectors           : 63





- Figure 1: Disks genuine ordering in the NAS rack:

  ********

                  +------------+

  * Top disk    : |   Disk 1   |

                  +------------+

  * Next disk   : |   Disk 2   |

                  +------------+

  * Third disk  : |   Disk 3   |

                  +------------+

  * Bottom disk : |   Disk 4   |

                  +------------+






- Figure 2: Disks connections in the Linux box:

  ********



    Thecus          USB           Linux        Disk

    N4100         devices        devices     partitions



  +--------+

  |        |                              --> 201MB   (Unknown)

  | DISK 1 | --> USB Disk 1 --> /dev/sdf |

  |        |                              --> 372.4GB (RAID compon.1)

  +--------+



  +--------+

  |        |                              --> 201MB   (Unknown)

  | DISK 2 | --> USB Disk 2 --> /dev/sdg |

  |        |                              --> 372.4GB (RAID compon.2)

  +--------+



  +--------+

  |        |                              --> 201MB   (Unknown)

  | DISK 3 | --> USB Disk 3 --> /dev/sdh |

  |        |                              --> 372.4GB (RAID compon.3)

  +--------+



  +--------+

  |        |                              --> 201MB   (Unknown)

  | DISK 4 | --> USB Disk 4 --> /dev/sdi |

  |        |                              --> 372.4GB (RAID compon.4)

  +--------+







- Figure 3: Corresponding disk images situation:

  ********


    Thecus         Disk          Loop           Mapped disk

    N4100         images        devices         partitions



  +--------+                              --> 201MB   (Unknown)

  |        |                             |    /dev/mapper/loop0p1

  | DISK 1 | --> disk0.hd --> /dev/loop0 |

  |        |                              --> 372.4GB (RAID compo.1)

  +--------+                                 /dev/mapper/loop0p2





  +--------+                              --> 201MB   (Unknown)

  |        |                             |    /dev/mapper/loop1p1

  | DISK 2 | --> disk1.hd --> /dev/loop1 |

  |        |                              --> 372.4GB (RAID compo.2)

  +--------+                                 /dev/mapper/loop1p2





  +--------+                              --> 201MB   (Unknown)

  |        |                             |    /dev/mapper/loop2p1

  | DISK 3 | --> disk2.hd --> /dev/loop2 |

  |        |                              --> 372.4GB (RAID compo.3)

  +--------+                                 /dev/mapper/loop2p2





  +--------+                              --> 201MB   (Unknown)

  |        |                             |    /dev/mapper/loop3p1

  | DISK 4 | --> disk3.hd --> /dev/loop3 |

  |        |                              --> 372.4GB (RAID compo.4)

  +--------+                                 /dev/mapper/loop3p2













-------------------------------------------------------

Performed tests & manipulation descriptions and results:

-------------------------------------------------------





PART 1: TESTS USING mdadm

*************************



------

[T001] Connecting USB disk 1, disk 2, disk 3, disk 4 and gathering info=
rmation.

------



The purpose of this test suite is to verify the response of the system
when connecting each physical RAID disk as a USB device.





* ACTION *



I am connecting disk 1 as USB device /dev/sdf to my Ubuntu system:





* messages.log *



May 15 14:42:19 obelix kernel: [176690.908772] usb 1-7.3.3: new high
speed USB device using ehci_hcd and address 11

May 15 14:42:19 obelix kernel: [176691.002540] usb 1-7.3.3:
configuration #1 chosen from 1 choice

May 15 14:42:19 obelix kernel: [176691.011777] scsi10 : SCSI emulation
for USB Mass Storage devices

May 15 14:42:24 obelix kernel: [176696.059395] scsi 10:0:0:0:
Direct-Access     ST340083 2AS                   PQ: 0 ANSI: 2 CCS

May 15 14:42:24 obelix kernel: [176696.060124] sd 10:0:0:0: Attached
scsi generic sg8 type 0

May 15 14:42:24 obelix kernel: [176696.071314] sd 10:0:0:0: [sdf]
781422768 512-byte logical blocks: (400 GB/372 GiB)

May 15 14:42:24 obelix kernel: [176696.075622] sd 10:0:0:0: [sdf]
Write Protect is off

May 15 14:42:24 obelix kernel: [176696.078622]  sdf: sdf1 sdf2

May 15 14:42:24 obelix kernel: [176696.116632] sd 10:0:0:0: [sdf]
Attached SCSI disk





* ACTION *



I am connecting disk 2 as USB device /dev/sdg to my Ubuntu system:



* messages.log *



May 15 14:52:11 obelix kernel: [177282.841023] usb 1-7.3.1: new high
speed USB device using ehci_hcd and address 12

May 15 14:52:11 obelix kernel: [177282.936281] usb 1-7.3.1:
configuration #1 chosen from 1 choice

May 15 14:52:11 obelix kernel: [177282.955419] scsi11 : SCSI emulation
for USB Mass Storage devices

May 15 14:52:16 obelix kernel: [177287.961386] scsi 11:0:0:0:
Direct-Access     ST340083 2AS                   PQ: 0 ANSI: 2

May 15 14:52:16 obelix kernel: [177287.962147] sd 11:0:0:0: Attached
scsi generic sg9 type 0

May 15 14:52:16 obelix kernel: [177287.969607] sd 11:0:0:0: [sdg]
781422768 512-byte logical blocks: (400 GB/372 GiB)

May 15 14:52:16 obelix kernel: [177287.975128] sd 11:0:0:0: [sdg]
Write Protect is off

May 15 14:52:16 obelix kernel: [177287.980862]  sdg: sdg1 sdg2

May 15 14:52:16 obelix kernel: [177288.011894] sd 11:0:0:0: [sdg]
Attached SCSI disk





* ACTION *



I am connecting disk 3 as USB device /dev/sdh to my Ubuntu system:



* messages.log *



May 15 14:59:33 obelix kernel: [177724.441158] usb 1-7.2: new high
speed USB device using ehci_hcd and address 14

May 15 14:59:33 obelix kernel: [177724.536461] usb 1-7.2:
configuration #1 chosen from 1 choice

May 15 14:59:33 obelix kernel: [177724.543552] scsi13 : SCSI emulation
for USB Mass Storage devices

May 15 14:59:38 obelix kernel: [177729.545857] scsi 13:0:0:0:
Direct-Access     ST340083 2AS                   PQ: 0 ANSI: 2

May 15 14:59:38 obelix kernel: [177729.546667] sd 13:0:0:0: Attached
scsi generic sg10 type 0

May 15 14:59:38 obelix kernel: [177729.552659] sd 13:0:0:0: [sdh]
781422768 512-byte logical blocks: (400 GB/372 GiB)

May 15 14:59:38 obelix kernel: [177729.556128] sd 13:0:0:0: [sdh]
Write Protect is off

May 15 14:59:38 obelix kernel: [177729.561068]  sdh: sdh1 sdh2

May 15 14:59:38 obelix kernel: [177729.590054] sd 13:0:0:0: [sdh]
Attached SCSI disk





* ACTION *



I am connecting disk 4 as USB device /dev/sdi to my Ubuntu system:



* messages.log *



May 15 15:00:14 obelix kernel: [177765.658207] usb 1-7.3.4: new high
speed USB device using ehci_hcd and address 15

May 15 15:00:14 obelix kernel: [177765.752468] usb 1-7.3.4:
configuration #1 chosen from 1 choice

May 15 15:00:14 obelix kernel: [177765.773190] scsi14 : SCSI emulation
for USB Mass Storage devices

May 15 15:00:19 obelix kernel: [177770.777746] scsi 14:0:0:0:
Direct-Access     ST340083 2AS                   PQ: 0 ANSI: 2

May 15 15:00:19 obelix kernel: [177770.778639] sd 14:0:0:0: Attached
scsi generic sg11 type 0

May 15 15:00:19 obelix kernel: [177770.789192] sd 14:0:0:0: [sdi]
781422768 512-byte logical blocks: (400 GB/372 GiB)

May 15 15:00:19 obelix kernel: [177770.796334] sd 14:0:0:0: [sdi]
Write Protect is off

May 15 15:00:19 obelix kernel: [177770.805059]  sdi: sdi1 sdi2

May 15 15:00:19 obelix kernel: [177770.837077] sd 14:0:0:0: [sdi]
Attached SCSI disk




* ACTION *

I am now collecting summarizing information about the USB RAID disks
connected to my Ubuntu box:

$ sudo blkid


* CONSOLE-OUT *

(... other devices ...)

/dev/sdf2: UUID=3D"ecfe8404-2f35-4a45-d668-56da8e136666" TYPE=3D"linux_=
raid_member"
/dev/sdg2: UUID=3D"ecfe8404-2f35-4a45-d668-56da8e136666" TYPE=3D"linux_=
raid_member"
/dev/sdh2: UUID=3D"ecfe8404-2f35-4a45-d668-56da8e136666" TYPE=3D"linux_=
raid_member"
/dev/sdi2: UUID=3D"ecfe8404-2f35-4a45-d668-56da8e136666" TYPE=3D"linux_=
raid_member"


* QUESTION *

The 4 RAID disk partitions are detected as "Linux Raid Members" and
share the same UUID, which should be normal since they belong to the
same RAID array. Is this right?





------

[T002] Disks 1, 2, 3 and 4 geometry and partitions using fdisk -l

------



The purpose of this test suite is to report the physical geomtry and
partitioning information returned by fdisk -l for each physical RAID
disk.



* ACTION *



I am examinating each physical disk geometry and partitioning reported
by fdisk.



$ sudo fdisk -l /dev/sdf



* CONSOLE-OUT *



Disk /dev/sdf: 400.1 GB, 400088457216 bytes

16 heads, 63 sectors/track, 775221 cylinders

Units =3D cylinders of 1008 * 512 =3D 516096 bytes

Disk identifier : 0x00000000



Device Boot          Start        End      Blocks   Id  System

/dev/sdf1               1         389      196024+  83  Linux

/dev/sdf2             390      775221   390515328   fd  Linux raid auto=
detect





$ sudo fdisk -l /dev/sdg



* CONSOLE-OUT *



Disk /dev/sdg: 400.1 GB, 400088457216 bytes

16 heads, 63 sectors/track, 775221 cylinders

Units =3D cylinders of 1008 * 512 =3D 516096 bytes

Disk identifier : 0x00000000



Device Boot          Start        End      Blocks   Id  System

/dev/sdg1               1         389      196024+  83  Linux

/dev/sdg2             390      775221   390515328   fd  Linux raid auto=
detect





$ sudo fdisk -l /dev/sdh



* CONSOLE-OUT *



Disk /dev/sdh: 400.1 GB, 400088457216 bytes

16 heads, 63 sectors/track, 775221 cylinders

Units =3D cylinders of 1008 * 512 =3D 516096 bytes

Disk identifier : 0x00000000



Device Boot          Start        End      Blocks   Id  System

/dev/sdh1               1         389      196024+  83  Linux

/dev/sdh2             390      775221   390515328   fd  Linux raid auto=
detect





$ sudo fdisk -l /dev/sdi



* CONSOLE-OUT *



Disk /dev/sdi: 400.1 GB, 400088457216 bytes

16 heads, 63 sectors/track, 775221 cylinders

Units =3D cylinders of 1008 * 512 =3D 516096 bytes

Disk identifier : 0x00000000



Device Boot          Start        End      Blocks   Id  System

/dev/sdi1               1         389      196024+  83  Linux

/dev/sdi2             390      775221   390515328   fd  Linux raid auto=
detect





------

[T003] Using palimpsest to view disks partition structures.

------



* ACTION *



=46or this diagnostic, I am using graphical disk manager application
"palimpsest" under Gnome to visualize the 4 USB disk devices /dev/sdf,
/dev/sdg, /dev/sdh, /dev/sdi in order to confirm the results I got
from previous fdisk -l commands.



* RESULTS *



- See attached images 01 to 04.

- The 4 USB disks are correctly displayed in the disk tree (image01.png=
)

- For each USB disk, there is an unknown or unused 201MB partition
(image02.png)

- Each Seagate disk contains a second partition labelled "Linux Raid
Member" (image03.png)



- The 4 disks are detected as a coherent RAID drive (image04.png)

- The assembled filesystem is reported "mountable" by Palimpset (image0=
5.png)



* COMMENTS *



- On image 04, one notices that only the second partition (/dev/sdf2,
/dev/sdg2, /dev/sdh2, /dev/sdi2) typed as "linux raid member"
partition of each disk is used for assembling the final RAID drive.

- The assembled filesystem is reported to be an ext2 filesystem

- I am unable to mount the RAID filesystem by using Palimpsest.





------

[T004] Using mdadm to assemble the full disks as one single RAID-0 devi=
ce.

------



* ACTION *



I am using standard raid management tool mdadm to assemble the 4 USB
physical disk as one single RAID device. I am using switch -A (not
switch --create) because I have already created the array previously
and regenerated the persistent superblocks on each disks.
Nevertheless, please note that I am explicitly mentioning which
devices (and their order) are involved in the assembled array.



$ sudo mdadm -A /dev/md0 /dev/sdf /dev/sdg /dev/sdh /dev/sdi
                            ^         ^        ^        ^
                            |         |        |        |
                          DISK 1    DISK 2   DISK 3   DISK 4




* CONSOLE-OUT *



mdadm: no recogniseable superblock on /dev/sdf

mdadm: /dev/sdf has no superblock - assembly aborted



* COMMENTS *



This error seems logical: for each disk, only the second partition,
labelled "Linux raid member" is supposed to be part of the RAID array.





------

[T005] mdadm to assemble the "linux raid" partitions as one single
RAID-0 device.

------



* ACTION *



Same test as [TEST004]. But this time, I am explicitly assembling the
"linux raid member" partition of each disk. See [T001] for the
partitions of each disk.



$ sudo mdadm -A /dev/md0 /dev/sdf2    /dev/sdg2    /dev/sdh2    /dev/sd=
i2
                            ^            ^             ^            ^
                            |            |             |            |
                        RAID comp.1  RAID comp.2  RAID comp.3  RAID com=
p.4


* CONSOLE-OUT *



mdadm: /dev/md0 has been started with 4 drives.





* messages.log *



May 15 16:42:49 obelix kernel: [183920.968499] md: md0 stopped.

May 15 16:42:49 obelix kernel: [183921.161066] md: bind<sdg2>

May 15 16:42:49 obelix kernel: [183921.173482] md: bind<sdh2>

May 15 16:42:49 obelix kernel: [183921.181697] md: bind<sdi2>

May 15 16:42:49 obelix kernel: [183921.183694] md: bind<sdf2>

May 15 16:42:49 obelix kernel: [183921.186312] raid0: looking at sdf2

May 15 16:42:49 obelix kernel: [183921.186318] raid0:   comparing
sdf2(781030528)

May 15 16:42:49 obelix kernel: [183921.186323]  with sdf2(781030528)

May 15 16:42:49 obelix kernel: [183921.186327] raid0:   END

May 15 16:42:49 obelix kernel: [183921.186330] raid0:   =3D=3D> UNIQUE

May 15 16:42:49 obelix kernel: [183921.186333] raid0: 1 zones

May 15 16:42:49 obelix kernel: [183921.186337] raid0: looking at sdi2

May 15 16:42:49 obelix kernel: [183921.186342] raid0:   comparing
sdi2(781030528)

May 15 16:42:49 obelix kernel: [183921.186346]  with sdf2(781030528)

May 15 16:42:49 obelix kernel: [183921.186349] raid0:   EQUAL

May 15 16:42:49 obelix kernel: [183921.186353] raid0: looking at sdh2

May 15 16:42:49 obelix kernel: [183921.186358] raid0:   comparing
sdh2(781030528)

May 15 16:42:49 obelix kernel: [183921.186362]  with sdf2(781030528)

May 15 16:42:49 obelix kernel: [183921.186365] raid0:   EQUAL

May 15 16:42:49 obelix kernel: [183921.186369] raid0: looking at sdg2

May 15 16:42:49 obelix kernel: [183921.186374] raid0:   comparing
sdg2(781030528)

May 15 16:42:49 obelix kernel: [183921.186378]  with sdf2(781030528)

May 15 16:42:49 obelix kernel: [183921.186381] raid0:   EQUAL

May 15 16:42:49 obelix kernel: [183921.186384] raid0: FINAL 1 zones

May 15 16:42:49 obelix kernel: [183921.186393] raid0: done.

May 15 16:42:49 obelix kernel: [183921.186397] raid0 : md_size is
3124122112 sectors.

May 15 16:42:49 obelix kernel: [183921.186401] ******* md0
configuration *********

May 15 16:42:49 obelix kernel: [183921.186405] zone0=3D[sdf2/sdg2/sdh2/=
sdi2/]

May 15 16:42:49 obelix kernel: [183921.186417]         zone offset=3D0k=
b
device offset=3D0kb size=3D1562061056kb

May 15 16:42:49 obelix kernel: [183921.186421]
**********************************

May 15 16:42:49 obelix kernel: [183921.186423]

May 15 16:42:49 obelix kernel: [183921.186446] md0: detected capacity
change from 0 to 1599550521344

May 15 16:42:49 obelix kernel: [183921.194595]  md0: unknown partition =
table





* COMMENTS *



The command now apparently worked.The RAID array seems to be
assembled. In test [T006] below, I am performing simple RAID diagnosis
using the mdadm command.



* QUESTION *



Messages.log indicates that there is no partition table available on
device /dev/md0. Is this normal?







------

[T006] Diagnosing the assembled RAID array using mdadm

------



* ACTION *



Listing the assembled arrays at kernel



$ sudo cat /proc/mdstat



* CONSOLE-OUT *



Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]



md0 : active raid0 sdf2[0] sdi2[3] sdh2[2] sdg2[1]

      1562061056 blocks 64k chunks



* COMMENTS *



The kernel sees a RAID-0 device /dev/md0 assembled with the following
disks devices ordered as /dev/sdf2, /dev/sdg2, /dev/sdh2, and
/dev/sdi2.



* ACTION *



Let's get details about the assembled RAID-0 device /dev/md0



$ sudo mdadm -D /dev/md0



* CONSOLE-OUT *



/dev/md0:

        Version : 00.90

  Creation Time : Fri Feb 19 01:23:02 2010

     Raid Level : raid0

     Array Size : 1562061056 (1489.70 GiB 1599.55 GB)

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 0

    Persistence : Superblock is persistent



    Update Time : Fri Feb 19 01:23:02 2010

          State : clean

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0



     Chunk Size : 64K



           UUID : ecfe8404:2f354a45:d66856da:8e136666

         Events : 0.1



    Number   Major   Minor   RaidDevice State

       0       8       82        0      active sync   /dev/sdf2

       1       8       98        1      active sync   /dev/sdg2

       2       8      114        2      active sync   /dev/sdh2

       3       8      130        3      active sync   /dev/sdi2





* COMMENTS *



This result seems consistent!





* ACTION *



Let's get details about RAID component partition /dev/sdf2 (DISK 1) wit=
h mdadm:



$ sudo mdadm -E /dev/sdf2



* CONSOLE-OUTPUT *



/dev/sdf2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : ecfe8404:2f354a45:d66856da:8e136666

  Creation Time : Fri Feb 19 01:23:02 2010

     Raid Level : raid0

  Used Dev Size : 0

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 0



    Update Time : Fri Feb 19 01:23:02 2010

          State : active

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0

       Checksum : c0d7901b - correct

         Events : 1



     Chunk Size : 64K



      Number   Major   Minor   RaidDevice State

this     0       8       34        0      active sync   /dev/sdc2



   0     0       8       34        0      active sync   /dev/sdc2

   1     1       8       50        1      active sync

   2     2       8       66        2      active sync

   3     3       8       82        3      active sync   /dev/sdf2





* COMMENTS *



This result does not look not consistent:



- Why is /dev/sdc2 mentioned here as the current device? Should be /dev=
/sdf2.

- Why devices 1 and 2 are left blank?

- Why is device /dev/sdf2 (current device) mentioned as device 3?





* ACTION *



Let's get details about RAID component partition /dev/sdg2 (DISK 2) wit=
h mdadm:



$ sudo mdadm -E /dev/sdg2



* CONSOLE-OUTPUT *



/dev/sdg2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : ecfe8404:2f354a45:d66856da:8e136666

  Creation Time : Fri Feb 19 01:23:02 2010

     Raid Level : raid0

  Used Dev Size : 0

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 0



    Update Time : Fri Feb 19 01:23:02 2010

          State : active

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0

       Checksum : c0d7902d - correct

         Events : 1



     Chunk Size : 64K



      Number   Major   Minor   RaidDevice State

this     1       8       50        1      active sync



   0     0       8       34        0      active sync   /dev/sdc2

   1     1       8       50        1      active sync

   2     2       8       66        2      active sync

   3     3       8       82        3      active sync   /dev/sdf2





* COMMENTS *



This result does not look consistent:



- Why is (blank) mentioned here as the current device?  Should be /dev/=
sdg2.

- Why devices 1 and 2 are left blank?

- Why is device /dev/sdf2 mentioned as device 3?





* ACTION *



Let's get details about RAID component partition /dev/sdh2 (DISK 3) wit=
h mdadm:



$ sudo mdadm -E /dev/sdh2



* CONSOLE-OUTPUT *



/dev/sdh2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : ecfe8404:2f354a45:d66856da:8e136666

  Creation Time : Fri Feb 19 01:23:02 2010

     Raid Level : raid0

  Used Dev Size : 0

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 0



    Update Time : Fri Feb 19 01:23:02 2010

          State : active

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0

       Checksum : c0d7903f - correct

         Events : 1



     Chunk Size : 64K



      Number   Major   Minor   RaidDevice State

this     2       8       66        2      active sync



   0     0       8       34        0      active sync   /dev/sdc2

   1     1       8       50        1      active sync

   2     2       8       66        2      active sync

   3     3       8       82        3      active sync   /dev/sdf2





* COMMENTS *



This result does not look consistent:



- Why is (blank) mentioned here as the current device?  Should be /dev/=
sdh2.

- Why devices 1 and 2 are left blank?

- Why is device /dev/sdf2 mentioned as device 3?





* ACTION *



Let's get details about RAID component partition /dev/sdi2 (DISK 4) wit=
h mdadm:



$ sudo mdadm -E /dev/sdi2



* CONSOLE-OUTPUT *



/dev/sdi2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : ecfe8404:2f354a45:d66856da:8e136666

  Creation Time : Fri Feb 19 01:23:02 2010

     Raid Level : raid0

  Used Dev Size : 0

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 0



    Update Time : Fri Feb 19 01:23:02 2010

          State : active

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0

       Checksum : c0d79051 - correct

         Events : 1



     Chunk Size : 64K



      Number   Major   Minor   RaidDevice State

this     3       8       82        3      active sync   /dev/sdf2



   0     0       8       34        0      active sync   /dev/sdc2

   1     1       8       50        1      active sync

   2     2       8       66        2      active sync

   3     3       8       82        3      active sync   /dev/sdf2





* COMMENTS *



This result does not look consistent:



- Why is (blank) mentioned here as the current device?  Should be /dev/=
sdi2.

- Why devices 1 and 2 are left blank?

- Why is device /dev/sdf2 mentioned as device 3?







------

[T007] Mounting the assembled RAID's filesystem as ext3-fs.

------



$ sudo mount -t ext3 /dev/md0 /media/N4100



* CONSOLE-OUT *



mount: wrong fs type, bad option, bad superblock on /dev/md0,

missing codepage or helper program, or other error

In some cases useful info is found in syslog - try

dmesg | tail or so





* kern.log *



May 15 16:48:08 obelix kernel: [184240.160548] EXT3-fs error (device
md0): ext3_check_descriptors: Block bitmap for group 1920 not in group
(block 0)!

May 15 16:48:08 obelix kernel: [184240.163677] EXT3-fs: group
descriptors corrupted!





* COMMENTS *



There is an obvious filesystem issue on the assembled filesystem,
which seems related with corrupted ext3 filesystem descriptors.



* ACTION *



I re-issue the mount command, this time not forcing the filesystem type=
:



$ sudo mount /dev/md0 /media/N4100



* CONSOLE-OUT *



mount: wrong fs type, bad option, bad superblock on /dev/md0,

missing codepage or helper program, or other error

In some cases useful info is found in syslog - try

dmesg | tail or so





* kern.log *



May 15 16:51:42 obelix kernel: [184453.959766] EXT2-fs error (device
md0): ext2_check_descriptors: Block bitmap for group 1920 not in group
(block 0)!

May 15 16:51:42 obelix kernel: [184453.959783] EXT2-fs: group
descriptors corrupted!



* QUESTION *



Is this issue related with the apparent inconsistencies of the mdadm
diagnosis performed on each individual disk in [T006] ?



* COMMENTS *



In its current state, the RAID filesystem of device /dev/md0 cannot be
mounted and exhibits severe inconsistencies...





------

[T008] RAID array device /dev/md0 geometry and partitioning information

------



$ sudo fdisk -l /dev/md0



* CONSOLE-OUT *



Disk /dev/md0: 1599.6 GB, 1599550521344 bytes

2 heads, 4 sectors/track, 390515264 cylinders

Units =3D cylinders of 8 * 512 =3D 4096 bytes

Disk identifier : 0x00000000



Disk /dev/md0 doesn't contain a valid partition table.



[QUESTIONS]



Is there anything to fix here? How?





------

[T009] Checking what is wrong on /dev/md0 filesystem by means of fsck.e=
xt3

------



* COMMENTS *



Not performing any write action on the assembled physical array...



$ sudo e2fsck -n /dev/md0



* CONSOLE-OUT *



e2fsck 1.41.9 (22-Aug-2009)

e2fsck: Group descriptors look bad... trying backing blocks...

the superbloc has an invalid journal (i-node=A08).

Delete=A0? no



e2fsck: Illegal inode number while checking ext3 journal for /dev/md0





* COMMENTS *



This diagnostic is insufficient for now but I do not want to perform
any intrusive diagnostic on the physical disks.









PART 2: TESTS USING testdisk on disk images

*******************************************



------

[T010] Global analysis of the assembled raid image /dev/md0

------



* COMMENTS *



I am performing a testdisk analysis on the final RAID device assembled
from the 4 disk images disk0.hd, disk1.hd, disk2.hd and disk3.hd.



$ sudo testdisk /dev/md0





* CONSOLE-OUT *



Screen 1

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



  TestDisk is free software, and

comes with ABSOLUTELY NO WARRANTY.



Select a media (use Arrow keys, then press Enter):

Disk /dev/md0 - 1599 GB / 1489 GiB







[Proceed ]  [  Quit  ]



Note: Disk capacity must be correctly detected for a successful recover=
y.

If a disk listed above has incorrect size, check HD jumper settings, BI=
OS

detection, and install the latest OS patches and disk drivers.

---------------------------------------------------------------------





Screen 2

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org





Disk /dev/md0 - 1599 GB / 1489 GiB



Please select the partition table type, press Enter when done.

[Intel  ]  Intel/PC partition

[EFI GPT]  EFI GPT partition map (Mac i386, some x86_64...)

[Mac    ]  Apple partition map

[None   ]  Non partitioned media

[Sun    ]  Sun Solaris partition

[XBox   ]  XBox partition

[Return ]  Return to disk selection





Note: Do NOT select 'None' for media with only a single partition. It's=
 very

rare for a drive to be 'Non-partitioned'.

---------------------------------------------------------------------





* ACTION *



I select none: indeed, according to my assumption, /dev/md0 SHOULD be a=
 an

ext3-fs filesystem, and therefore does not contain sub-partitions.





Screen 3

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org





Disk /dev/md0 - 1599 GB / 1489 GiB - CHS 390515264 2 4



[ Analyse  ]  Analyse current partition structure and search for lost p=
artitions

[ Advanced ]  Filesystem Utils

[ Geometry ]  Change disk geometry

[ Options  ]  Modify options

[ Quit     ]  Return to disk selection





Note: Correct disk geometry is required for a successful recovery. 'Ana=
lyse'

process may give some warnings if it thinks the logical geometry is mis=
matched.

---------------------------------------------------------------------





* ACTION *



I select option Analyse





Screen 4

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/md0 - 1599 GB / 1489 GiB - CHS 390515264 2 4

Current partition structure:

     Partition                  Start        End    Size in sectors



   P ext2                     0   0  1 390515263   1  4 3124122112







[Quick Search]

                            Try to locate partition

---------------------------------------------------------------------





* ACTION *



I select Quick Search. The Quik Search analysis gets started... and
the following result is displayed.





Screen 5

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/md0 - 1599 GB / 1489 GiB - CHS 390515264 2 4

     Partition               Start        End    Size in sectors

P ext2                     0   0  1 390515199   1  4 3124121600





Structure: Ok.





Keys T: change type, P: list files,

     Enter: to continue

EXT2 Large file Sparse superblock, 1599 GB / 1489 GiB

---------------------------------------------------------------------





* ACTION *



I press P to list the files on this filesystem.





Screen 6

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org

   P ext2                     0   0  1 390515199   1  4 3124121600

Directory /



No file found, filesystem seems damaged.





Use Right arrow to change directory, c to copy,

    h to hide deleted files, q to quit

---------------------------------------------------------------------





* COMMENTS *



What is wrong?





* ACTION *



I press Q to return to screen 5. Then I press Enter to continue.





Screen 7

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/md0 - 1599 GB / 1489 GiB - CHS 390515264 2 4



     Partition                  Start        End    Size in sectors



   P ext2                     0   0  1 390515199   1  4 3124121600



Write isn't available because the partition table type "None" has been =
selected.





[  Quit  ]  [Deeper Search]

                          Try to find more partitions

---------------------------------------------------------------------





* COMMENTS *



So, what can I do? I cannot write partition organization to the disk
because I have selected "none" as the partition structure for the
analysis... How can I practically modify that?







------

[T011] Analysis of the unkown 201MB partition.

------



* NOTES *



I execute this testdisk analysis on the first loopback partition
mapped as /dev/mapper/loop0p1.



Unlike the /dev/md0 device, it seems I cannot perform any RAID
assembling of the 4 p1 partitions /dev/mapper/loop0p1,
/dev/mapper/loop1p1, /dev/mapper/loop2p1 and /dev/mapper/loop3p1,
because this disk zone does not seem to contain any RAID superblocks.



In clear, the 201 Unknown zone reported on each disk DOES NOT look
like a RAID partition (unless its type was accidentally changed by the
above manipulations). Therefore, and unlike assembled device /dev/md0,
I am forced to run TestDisk one 1 disk image.



I select the first disk image /dev/loop0, and I therefore execute
TestDisk on its p1 partition as follows:





$ sudo test /dev/mapper/loop0p1





* CONSOLE-OUT *



Screen 1

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



  TestDisk is free software, and

comes with ABSOLUTELY NO WARRANTY.



Select a media (use Arrow keys, then press Enter):

Disk /dev/mapper/loop0p1 - 200 MB / 191 MiB





[Proceed ]  [  Quit  ]



Note: Disk capacity must be correctly detected for a successful recover=
y.

If a disk listed above has incorrect size, check HD jumper settings, BI=
OS

detection, and install the latest OS patches and disk drivers.

---------------------------------------------------------------------





Screen 2

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org





Disk /dev/mapper/loop0p1 - 200 MB / 191 MiB



Please select the partition table type, press Enter when done.

[Intel  ]  Intel/PC partition

[EFI GPT]  EFI GPT partition map (Mac i386, some x86_64...)

[Mac    ]  Apple partition map

[None   ]  Non partitioned media

[Sun    ]  Sun Solaris partition

[XBox   ]  XBox partition

[Return ]  Return to disk selection





Note: Do NOT select 'None' for media with only a single partition. It's=
 very

rare for a drive to be 'Non-partitioned'.

---------------------------------------------------------------------





* ACTION *



I select Intel/PC partition just in case this zone would contain some
deleted partition.





Screen 3

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/mapper/loop0p1 - 200 MB / 191 MiB - CHS 392049 1 1

Current partition structure:

     Partition                  Start        End    Size in sectors





Partition sector doesn't have the endmark 0xAA55





*=3DPrimary bootable  P=3DPrimary  L=3DLogical  E=3DExtended  D=3DDelet=
ed

[Quick Search]

                            Try to locate partition

---------------------------------------------------------------------





* COMMENTS *



Where does the end 0xAA55 error come from?





* ACTION *



I select the Quick Search option, and I get the following result.





Screen 4

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/mapper/loop0p1 - 200 MB / 191 MiB - CHS 392049 1 1



     Partition                  Start        End    Size in sectors





No partition found or selected for recovery





[  Quit  ]  [Deeper Search]

                          Try to find more partitions

---------------------------------------------------------------------





* COMMENTS *



Unknown zone p1 does not contain any partition.







------

[T012] Analysis of one RAID disk image /dev/loop0

------



* NOTES *



I execute this testdisk analysis on the first loopback disk mapped as
/dev/loop0.



Identical results would also be found performing a testdisk analysis
on images /dev/loop1, /dev/loop2, or /dev/loop3.



Please note that:



- I ONLY perform an analysis on ONE disk image, not on the entire
/dev/md0 RAID device image,



- I am performing the analysis of ONE whole disk image, unlike test
[T010] where I ONLY analyzed the 201 MB unknown partition.





By doing this test, I expect TestDisk will give me accurate partition
information about each individual disk involved in the RAID array, and
in particular, I do hope I will get more accurate information about
this 201 MB zone.





$ sudo test /dev/loop0





* CONSOLE-OUT *



Screen 1

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



  TestDisk is free software, and

comes with ABSOLUTELY NO WARRANTY.



Select a media (use Arrow keys, then press Enter):

Disk /dev/loop0 - 400 GB / 372 GiB





[Proceed ]  [  Quit  ]



Note: Disk capacity must be correctly detected for a successful recover=
y.

If a disk listed above has incorrect size, check HD jumper settings, BI=
OS

detection, and install the latest OS patches and disk drivers.

---------------------------------------------------------------------





Screen 2

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org





Disk /dev/loop0 - 400 GB / 372 GiB



Please select the partition table type, press Enter when done.

[Intel  ]  Intel/PC partition

[EFI GPT]  EFI GPT partition map (Mac i386, some x86_64...)

[Mac    ]  Apple partition map

[None   ]  Non partitioned media

[Sun    ]  Sun Solaris partition

[XBox   ]  XBox partition

[Return ]  Return to disk selection





Note: Do NOT select 'None' for media with only a single partition. It's=
 very

rare for a drive to be 'Non-partitioned'.

---------------------------------------------------------------------





* ACTION *



I select Intel/PC partition, because I assume there should be a
regular partition available in which the RAID ext2 (or 3) partition is
referenced.





Screen 3

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org





Disk /dev/loop0 - 400 GB / 372 GiB - CHS 781422768 1 1



[ Analyse  ]  Analyse current partition structure and search for lost p=
artitions

[ Advanced ]  Filesystem Utils

[ Geometry ]  Change disk geometry

[ Options  ]  Modify options

[ MBR Code ]  Write TestDisk MBR code to first sector

[ Delete   ]  Delete all data in the partition table

[ Quit     ]  Return to disk selection





Note: Correct disk geometry is required for a successful recovery. 'Ana=
lyse'

process may give some warnings if it thinks the logical geometry is mis=
matched.

---------------------------------------------------------------------





* COMMENTS *



Disk Geometry information CHS=3D781422768 1 1 reported by Testdisk does
not match the CHS information reported by fdisk -l in test [T010].



I decide to correct Testdisk geometry parameters by replacing them
with parameters CHS=3D775221 16 63 reported by fdisk -l in test [T010].
(Note: I also performed test [T018] with no geometry information
change: the results of this test are not reported in this document,
because the results are inconsistent.)



* ACTION *



I select Analyse.





Screen 4

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/loop0 - 400 GB / 372 GiB - CHS 775221 16 63

Current partition structure:

     Partition                  Start        End    Size in sectors



No EXT2, JFS, Reiser, cramfs or XFS marker

 1 P Linux                    0   1  1   388  15 63     392049

 1 P Linux                    0   1  1   388  15 63     392049

 2 P Linux RAID             389   0  1 775220  15 63  781030656 [md0]

No partition is bootable





[Quick Search]  [ Backup ]

                            Try to locate partition

---------------------------------------------------------------------





* COMMENTS *



This time I seem to get some more information about the global
partition structure

of the disk:



- Partition 2 is obviously the RAID component partition



- Partition 1 is suposedly a Linux partition. But where is this
partition? Furthermore, there seems to be 2 traces of the same
partition... Was a second partition created on top of an older one?



Up to now, there seems to be a ray of hope: the RAID partition is
effectively referenced in the partition table of a RAID disk, AND
there also seems to be a Linux partition, probably damaged. I suspect
that this Linux partition may have been created by the NAS Thecus
N4100 and may contain the SHARED FOLDERS configuration and access
rights...



Nevertheless, does the fact that I cannot see this Linux partition 1
prevent me from accessing and mouting the RAID partition 2?





* ACTION *



I select Quick search in order to perform some partition search.
Results are reported in Screen 5 below.







Screen 5

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/loop0 - 400 GB / 372 GiB - CHS 775221 16 63



The harddisk (400 GB / 372 GiB) seems too small! (< 1599 GB / 1489 GiB)

Check the harddisk size: HD jumpers settings, BIOS detection...



The following partitions can't be recovered:

     Partition               Start        End    Size in sectors

  Linux                  389   0  1 3099715  15 47 3124121600

  Linux                  397   0  1 3099723  15 47 3124121600





[ Continue ]

EXT2 Large file Sparse superblock, 1599 GB / 1489 GiB

---------------------------------------------------------------------





* COMMENTS *



The hard disk seems to small!! How is this possible? What is wrong? I
am using the correct geometry information, am not I?





Screen 6

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/loop0 - 400 GB / 372 GiB - CHS 775221 16 63



Warning: the current number of heads per cylinder is 16

but the correct value may be 255.

You can use the Geometry menu to change this value.

It's something to try if

- some partitions are not found by TestDisk

- or the partition table can not be written because partitions overlaps=
=2E





[ Continue ]

---------------------------------------------------------------------





* QUESTION *



What am I supposed to do now? The geometry of /dev/loop0 matches that
reported by the fdisk -l tests performed previously. There cannot be a
disk geometry issue, can it?







Screen 7

---------------------------------------------------------------------



TestDisk 6.11, Data Recovery Utility, April 2009

Christophe GRENIER <grenier@cgsecurity.org>

http://www.cgsecurity.org



Disk /dev/loop0 - 400 GB / 372 GiB - CHS 775221 16 63

     Partition               Start        End    Size in sectors

L Linux RAID           775220  13 62 775220  15 63        128 [md0]





Structure: Ok.  Use Up/Down Arrow keys to select partition.

Use Left/Right Arrow keys to CHANGE partition characteristics:

*=3DPrimary bootable  P=3DPrimary  L=3DLogical  E=3DExtended  D=3DDelet=
ed

Keys A: add partition, L: load backup, T: change type,

     Enter: to continue

md 0.90.0 Raid 0: devices 0(8,34)* 1(8,50) 2(8,66) 3(8,82), 65 KB / 64 =
KiB

---------------------------------------------------------------------







* COMMENTS *



Now, only the RAID partition is shown in the list. Linux partition 1
has disappeared... Why?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
