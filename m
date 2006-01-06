From: PFC <lists@peufeu.com>
Subject: Kanotix crashed my raid...
Date: Fri, 06 Jan 2006 12:03:48 +0100
Message-ID: <op.s2yecmeocigqcu@apollo13>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43BE3C99.4050706@ieee.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Hello !
	This is my first post here, so hello to everyone !

	So, I have a 1 Terabyte 5-disk RAID5 array (md) that is now dead. I'll  
try to explain.
	It's a bit long because I tried to be complete...

----------------------------------------------------------------

	Hardware :
	- Athlon 64, nforce mobo with 4 IDE and 4 SATA
	- 2 IDE HDD making up a RAID1 array
	- 4 SATA HDD + 1 IDE HDD making up a RAID5 array.

	Software :
	- gentoo compiled in 64 bits ; kernel is 2.6.14-archck5
	- mdadm - v2.1 - 12 September 2005

	RAID1 config :

	/dev/hda (80 Gb) and /dev/hdc (120 Gb) contain :
	- mirrored /boot partitions,
	- a 75 GB RAID1 (/dev/md0) mounted on /
	- a 5 GB RAID1 (/dev/md1) for storing mysql and postgres databases  
separately
	- and hdc, which is larger, has a non-RAID scratch partition for all the  
unimportant stuff.

	RAID5 config :
	/dev/hdb, /dev/sd{a,b,c,d} are 5 x 250 GB hard disks ; some maxtor, some  
seagate, 1 IDE and 4 SATA.
	They are assembled in a RAID5 array, /dev/md2

----------------------------------------------------------------

	What happened ?

	So, I'm very happy with the software RAID 1 on my / partition ;  
especially since one of the two disks of the mirror died yesterday . The  
drive which died was a 100 GB. I had a spare drive lying around, but it  
was only 80 GB. So I had to resize a few partitions including / and remake  
the raid array. No problem with a Kanotix boot CD ; I thought :

	- copy contents of /dev/md0 (/) to the big RAID5
	- destroy /dev/md0
	- rebuild it in a smaller size to accomodate the new disk
	- copy the data back from the RAID5

	Kanotix (version 2005.3) had detected the RAID1 partitions and had no  
problems with them.

	However the RAID5 was not detected. "cat /proc/mdstat" showed no trace of  
it.
	So I typed in Kanotix :

	mdadm --assemble /dev/md2 /dev/hdb1 /dev/sd{a,b,c,d}1

	Then it hung. The PC did not crash, but the mdadm process was hung.
	And I couldn't cat /proc/mdstat anymore (it would hang also).
	After waiting for a long time and seeing that nothing happened, I did a  
hard reset.

	So I resized my / partition with the usual trick (create a mirror with 1  
real drive and 1 failed 'virtual drive', copy data, add old drive).

	And I rebooted and all was well. Except /dev/md2 showed no life signs.  
This thing had been working flawlessly up until I typed
the dreaded "mdadm --assemble" in Kanotix. However now it's dead.

	Yeah, I have backups, sort of. This is my CD collection, all ripped and  
converted to lossless FLAC. And now my original CDs (about 900) are nicely  
packed in cardboard boxes in the basement. The thought of having to re-rip  
900 cds is what motivated me to use RAID by the way.

	Anyway :

-------------------------------------------------
apollo13 ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
md1 : active raid1 hdc7[1] hda7[0]
       6248832 blocks [2/2] [UU]

md2 : inactive sda1[0] hdb1[4] sdc1[3] sdb1[1]
       978615040 blocks

md0 : active raid1 hdc6[0] hda6[1]
       72292992 blocks [2/2] [UU]

unused devices: <none>
-------------------------------------------------

/dev/md2 is the problem. it's inactive so :

apollo13 ~ # mdadm --run /dev/md2
mdadm: failed to run array /dev/md2: Input/output error

ouch !
-------------------------------------------------
Here is dmesg output (/var/log/messages says the same) :

md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: hdc7 has different UUID to sdd1
md: hdc6 has different UUID to sdd1
md:  adding hdb1 ...
md: hda7 has different UUID to sdd1
md: hda6 has different UUID to sdd1
md: created md2
md: bind<hdb1>
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1><sdb1><sda1><hdb1>
md: kicking non-fresh sdd1 from array!
md: unbind<sdd1>
md: export_rdev(sdd1)
md: md2: raid array is not clean -- starting background reconstruction
raid5: device sdc1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 1
raid5: device sda1 operational as raid disk 0
raid5: device hdb1 operational as raid disk 4
raid5: cannot start dirty degraded array for md2
RAID5 conf printout:
  --- rd:5 wd:4 fd:1
  disk 0, o:1, dev:sda1
  disk 1, o:1, dev:sdb1
  disk 3, o:1, dev:sdc1
  disk 4, o:1, dev:hdb1
raid5: failed to run raid set md2
md: pers->run() failed ...
md: do_md_run() returned -5
md: md2 stopped.
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<hdb1>
md: export_rdev(hdb1)
-------------------------------------------------

So, it seems sdd1 isn't fresh enough so it gets kicked ; and 4 drives  
remain, which should be OK to run the array but somehow isn't.

Let's --examine the superblocks :

apollo13 ~ # mdadm --examine /dev/hdb1 /dev/sd?1
/dev/hdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 2

     Update Time : Fri Jan  6 06:57:15 2006
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : fe3f58c8 - correct
          Events : 0.61952

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       3       65        4      active sync   /dev/hdb1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       33        3      active sync   /dev/sdc1
    4     4       3       65        4      active sync   /dev/hdb1

/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 2

     Update Time : Fri Jan  6 06:57:15 2006
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : fe3f5885 - correct
          Events : 0.61952

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       33        3      active sync   /dev/sdc1
    4     4       3       65        4      active sync   /dev/hdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 2

     Update Time : Fri Jan  6 06:57:15 2006
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : fe3f5897 - correct
          Events : 0.61952

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       33        3      active sync   /dev/sdc1
    4     4       3       65        4      active sync   /dev/hdb1
/dev/sdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 2

     Update Time : Fri Jan  6 06:57:15 2006
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : fe3f58ab - correct
          Events : 0.61952

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       33        3      active sync   /dev/sdc1
    4     4       3       65        4      active sync   /dev/hdb1
/dev/sdd1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 2

     Update Time : Thu Jan  5 17:51:25 2006
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : fe3f9286 - correct
          Events : 0.61949

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       49        2      active sync   /dev/sdd1
    3     3       8       33        3      active sync   /dev/sdc1
    4     4       3       65        4      active sync   /dev/hdb1

-------------------------------------------------

sdd1 does not have the same "Events" than the others -- does this explain  
why it's not fresh ?
So, doing mdadm --assemble in Kanotix did "something" which caused this.

-------------------------------------------------

kernel source code : raid5.c line 1759 :

	if (mddev->degraded == 1 &&
	    mddev->recovery_cp != MaxSector) {
		printk(KERN_ERR
			"raid5: cannot start dirty degraded array for %s (%lx %lx)\n",
			mdname(mddev), mddev->recovery_cp, MaxSector);
		goto abort;
	}

I added some %lx in the printk so it prints :
"raid5: cannot start dirty degraded array for md2 (0 ffffffffffffffff)"
So, mddev->recovery_cp is 0 and MaxSector is -1 in unsigned 64 bit int. I  
have ansolutely no idea what this means !

-------------------------------------------------

	So, what can I do to get my data back ? I don't care if it's dirty and a  
few files are corrupt ; I can re-rip 1 or 2 CDs, no problem, but not ALL  
of them.

	Shall I remove the "goto abort;" and fasten seats belt ?
	What can I do ?

	Thanks for your help !!












