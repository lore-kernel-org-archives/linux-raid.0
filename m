From: Rick Bragg <lists@gmnet.net>
Subject: RE: fsck problems.  Can't restore raid
Date: Sat, 26 Dec 2009 20:01:35 -0500
Message-ID: <1261875695.10448.1335.camel@vibe>
References: <59.77.01567.9BC763B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59.77.01567.9BC763B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Thanks again Leslie, they are partitioned as linux raid, and the format
was Ext3.  They are all sdx1 (where x is a, b, c, d)   The raid array is
not a bootable system at all, but a mounted drive.  I am running the
system off of a totally different drive. (/dev/sde)  Also, I am running
a smart test now on all the drives 
# smartctl -t /dev/sdx...  I didn't know this existed, so I will await
the output and hope to make sense of it.  I will try to change up the
cables and ports once the smartctl results are in. 



Following is some more info:

fdisk info:

# fdisk /dev/sda
Unable to read /dev/sda

# fdisk /dev/sdb
Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       60801   488384001   fd  Linux raid
autodetect

# fdisk /dev/sdc
Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00045567

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       60801   488384001   fd  Linux raid
autodetect

# fdisk /dev/sdd
Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       60801   488384001   fd  Linux raid
autodetect



# mdadm --examine /dev/sda1
mdadm: No md superblock detected on /dev/sda1.
(no surprise there...)


# mdadm --examine /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.

(Does this mean that sdb1 is bad? or is that OK?)


# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Thu Dec 24 19:25:58 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : eddec3ad - correct
         Events : 1131438

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Thu Dec 24 19:25:58 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : eddec3bf - correct
         Events : 1131438

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



Also, for the controlers, I am using a couple of Promise cards:

# lspci
...
01:02.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
300 TX4) (rev 02)
...
01:06.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
300 TX4) (rev 02)


If any of this stands out as something really wrong, please let me know.
Thanks again so much for your help!
rick








On Sat, 2009-12-26 at 15:14 -0600, Leslie Rhorer wrote:
> > Thanks, it was an array that was up and running for a long time, and all
> > of a sudden, this happened.  so there were formatted and up and running
> > fine.
> 
> 	Well, you didn't quite answer my question.  Are the drives
> partitioned, or not?
> 
> > If I run, `mdadm --examine /dev/sda` etc. on all my disks, I get the
> > following error on all disks:
> > mdadm: No md superblock detected on /dev/sda.
> > thats on all disks... (sda, sdb, sdc, and sdd)
> 
> 	Well, we know the array is at least partially assembling, so it is
> finding at least some of the superblocks.  It sounds to me like perhaps the
> drives are partitioned.
> 
> > When I run fdisk on /dev/sda I get the following error:
> > Unable to read /dev/sda
> 
> 	That sounds like a dead drive.  I suggest running SMART tests on it.
> You might try changing the cable or moving it to another controller port.
> 
> > However, running fdisk on all other disks shows that they are up and
> > formatted with "raid" file type.
> 
> 	Formatted, or partitioned?  You might post the output from fdisk
> when you type "p" at the FDISK prompt.  At a guess, I would say perhaps your
> drives are partitioned and the devices are /dev/sda1 (or 2, or 3, or 4,
> ...), /dev/sdb1, etc.  Try typing
> 
> `ls /dev/sd*`
> 
> and see what pops up.  There should be references to sda, sdb, etc.  If
> there are also references to sdb1, sdb2, etc, then your drives have valid
> partitions, and it is those (or some of them, at least) which are targets
> for md.  Once you have determined which drives have which partitions, then
> issue the commands
> 
> ` mdadm --examine /dev/sdxy`, where x is "a", "b", "c", "d", etc., and y is
> "1", "2", "3", etc., including only those values returned by the ls command.
> 
> 	For example, on one of my systems:
> 
> RAID-Server:/etc/ssmtp# ls /dev/sd*
> /dev/sda   /dev/sda2  /dev/sdb  /dev/sdd  /dev/sdf  /dev/sdh  /dev/sdj
> /dev/sdl
> /dev/sda1  /dev/sda3  /dev/sdc  /dev/sde  /dev/sdg  /dev/sdi  /dev/sdk
> RAID-Server:/etc/ssmtp# ls /dev/hd*
> /dev/hda  /dev/hda1  /dev/hda2  /dev/hda3
> 
> 	This result tells us I have one PATA drive (hda) with three
> partitions on it.  It also tells us I have one (probably) SATA or SCSI drive
> (sda) with three partitions, and 11 SATA or SCSI drives (sdb - sdl) with no
> partitions on them.
> 
> 	If I issue the examine command on /dev/sda, I get an error:
> 
> RAID-Server:/etc/ssmtp# mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> 
> 	That's because in this case the DRIVE does not have an md
> superblock.  It is the PARTITIONS which have superblocks:
> 
> RAID-Server:/etc/ssmtp# mdadm --examine /dev/sda1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
>            Name : 'RAID-Server':1
>   Creation Time : Wed Dec 23 23:46:28 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 803160 (392.23 MiB 411.22 MB)
>      Array Size : 803160 (392.23 MiB 411.22 MB)
>    Super Offset : 803168 sectors
>           State : clean
>     Device UUID : 28212297:1d982d5d:ce41b6fe:03720159
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Sat Dec 26 13:00:32 2009
>        Checksum : af8f04b1 - correct
>          Events : 204
> 
> 
>     Array Slot : 1 (failed, 1, 0)
>    Array State : uU 1 failed
> 
> 	The other 11 drives, however, are un-partitioned, and the md
> superblock rests on the drive device itself:
> 
> RAID-Server:/etc/ssmtp# mdadm --examine /dev/sdb
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
>            Name : 'RAID-Server':0
>   Creation Time : Sat Apr 25 01:17:12 2009
>      Raid Level : raid6
>    Raid Devices : 11
> 
>  Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
>      Array Size : 17581722624 (8383.62 GiB 9001.84 GB)
>   Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : d40c9255:cef0739f:966d448d:e549ada8
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Sat Dec 26 15:09:44 2009
>        Checksum : e290ec2f - correct
>          Events : 1193460
> 
>      Chunk Size : 256K
> 
>     Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 10, 8, 9, 7)
>    Array State : Uuuuuuuuuuu
> 
> > 
> > Not sure what I can do next...
> > 
> > Thanks
> > Rick
> > 
> > 
> > 
> > 
> > 
> > 
> > On Sat, 2009-12-26 at 12:47 -0600, Leslie Rhorer wrote:
> > > 	I take it from your post the drives are not partitioned, and the
> > > RAID array consists of raw disk members?  First, check the superblocks
> > of
> > > the md devices:
> > >
> > > 	`mdadm --examine /dev/sda`, etc.  If 2 or more of the superblocks
> > > are corrupt, then that's your problem.  If not, then it should be
> > possible
> > > to get the array mounted one way or the other.  Once you get the array
> > > assembled again, then you can repair it, if need be.  Once that is done,
> > you
> > > can repair the file system if it is corrupted.  Once everything is
> > clean,
> > > you can mount the file system, and if necessary attempt to recover any
> > lost
> > > files.
> > >
> > > > -----Original Message-----
> > > > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > > > owner@vger.kernel.org] On Behalf Of Rick Bragg
> > > > Sent: Friday, December 25, 2009 9:13 PM
> > > > To: Linux RAID
> > > > Subject: Re: fsck problems. Can't restore raid
> > > >
> > > > On Fri, 2009-12-25 at 21:47 -0500, Rick Bragg wrote:
> > > > > On Fri, 2009-12-25 at 20:33 -0500, Rick Bragg wrote:
> > > > > > Hi,
> > > > > >
> > > > > > I have a raid 10 array and for some reason the system went down
> > and I
> > > > > > can't get it back.
> > > > > >
> > > > > > during re-boot, I get the following error:
> > > > > >
> > > > > > The superblock could not be read or does not describe a correct
> > ext2
> > > > > > filesystem.  If the device is valid and it really contains an ext2
> > > > > > filesystem (and not swap or ufs or something else), then the
> > > > superblock
> > > > > > is corrupt, and you might try running e2fsck with an alternate
> > > > > > superblock:
> > > > > >     e2fsck -b 8193 <device>
> > > > > >
> > > > > > I have tried everything I can think of and I can't seem to do an
> > fsck
> > > > or
> > > > > > repair the file system.
> > > > > >
> > > > > > what can I do?
> > > > > >
> > > > > > Thanks
> > > > > > Rick
> > > > > >
> > > > >
> > > > >
> > > > > More info:
> > > > >
> > > > > My array is made up of /dev/sda, sdb, sdc, and sdd.  However they
> > are
> > > > > not mounted right now.  My OS is booted off of /dev/sde.  I am
> > running
> > > > > ubuntu 9.04
> > > > >
> > > > > mdadm -Q --detail /dev/md0
> > > > > mdadm: md device /dev/md0 does not appear to be active.
> > > > >
> > > > > Where do I take if from here?  I'm not up on this as much as I
> > should be
> > > > > at all.  In fact I am quite a newbe to this... Any help would be
> > greatly
> > > > > appreciated.
> > > > >
> > > > > Thanks
> > > > > Rick
> > > > >
> > > >
> > > >
> > > > Here is even more info:
> > > >
> > > > # mdadm --assemble --scan
> > > > mdadm: /dev/md0 assembled from 2 drives - not enough to start the
> > array.
> > > >
> > > > # mdadm --assemble /dev/sda /dev/sdb /dev/sdc /dev/sdd
> > > > mdadm: cannot open device /dev/sdb: Device or resource busy
> > > > mdadm: /dev/sdb has no superblock - assembly aborted
> > > >
> > > > Is my array toast?
> > > > What can I do?
> > > >
> > > > Thanks
> > > > Rick
> > > >
> > > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



