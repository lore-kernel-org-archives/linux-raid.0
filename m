From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: RE: Moving a RAID5 array
Date: Fri, 28 May 2004 19:42:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c44526$963eac20$7001a8c0@darwin>
References: <16566.53192.813557.80559@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16566.53192.813557.80559@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've put 3 out of the 4 disks of the RAID5 array into a linux PC and
have done:

[root@masterbackend root]# mdadm --assemble /dev/md0 /dev/hde1 /dev/hdf1
/dev/hdg1
mdadm: /dev/md0 has been started with 3 drives (out of 4).
[root@masterbackend root]# more /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hde1[0] hdg1[2] hdf1[1]
      872738880 blocks level 5, 32k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>
 [root@masterbackend root]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Fri May 28 19:09:21 2004
     Raid Level : raid5
     Array Size : 872738880 (832.31 GiB 893.68 GB)
    Device Size : 290912960 (277.44 GiB 297.89 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri May 28 19:37:59 2004
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      33       65        1      active sync   /dev/hdf1
       2      34        1        2      active sync   /dev/hdg1
       3       0        0        3      faulty removed
           UUID : 3d673dbc:9d78693a:d8ffca9d:d63912cc
         Events : 0.5
[root@masterbackend root]# fsck -N /dev/md0
fsck 1.34 (25-Jul-2003)
[/sbin/fsck.ext2 (1) -- /dev/md0] fsck.ext2 /dev/md0 
[root@masterbackend root]# mkdir /mnt/array
[root@masterbackend root]# mount /dev/md0 /mnt/array
mount: you must specify the filesystem type
[root@masterbackend root]# mount /dev/md0 /mnt/array -t ext2
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
[root@masterbackend root]# mount /dev/md0 /mnt/array -t jfs
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
[root@masterbackend root]# mount /dev/md0 /mnt/array -t xfs
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
[root@masterbackend root]# mount /dev/md0 /mnt/array -t ext3
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems


Am I doing something wrong regarding mounting /dev/md0?  I believe the
filesystem used is supposed to be JFS, but I can't seem to mount it as
jfs,xfs,ext2, or ext3.  Is there some way I can determine what FS is
used?  Could it be a different version of jfs?

Thanks for any help... I believe I'm close!

Tim

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Thursday, May 27, 2004 10:36 PM
> To: Tim Harvey
> Cc: linux-raid@vger.kernel.org
> Subject: RE: Moving a RAID5 array
> 
> On Thursday May 27, tharvey@alumni.calpoly.edu wrote:
> >
> > It looks like I need to do an 'mdadm --assemble' to assemble the
> > previously created array into an active array.  But I'm not clear
how to
> > examine the /dev/md0 device to see what partitions are available
(fdisk
> > didn't work in a test... I guess its not compatible with /dev/md0).
> >
> 
> /dev/md0 will not have any partitions.  It will just have a
> filesystem.
> You could try 'fsck -n /dev/md0'  to see if the filesystem is
recognised.
> 
> > >
> > > Issue #1 Can be assured (AFAIK) by just attaching one disk less.
Then
> > the
> > > array will be in degraded mode and cannot / will not attempt a
resync.
> > > In addition, this will enable you to choose another set of disks,
> > should
> > > the
> > > outlook on the first three be less than favourable...
> > >
> >
> > Does disallowing the raid to start any reconstruction mean that the
> > array is not 'started' and that I cannot mount the filesystem?  I
guess
> > I'm not clear if there is a difference between the array being
'started'
> > and 'allowing reconstruction'.  Is leaving a disk out of the RAID5
array
> > the only way to force this to occur?  I noticed mdadm has a
--readonly
> > option but I'm not sure if it affects the assemble mode.
> 
> "starting" an array is like mounting a filesystem.  It makes it
> accessible.
> There is no simple way to start an array but not let it
> reconstruct. '--readonly' doesn't do this (though it probably
> should).
> Leaving one drive out disables reconstruction simply by making it
> impossible.
> 
> >
> > > Issue #2 Should be assured by mounting read-only, without prior
fsck.
> > >
> >
> > Sounds like a safe bet to mount the partition read-only.  How can I
> > examine /dev/md0 to see what partitions are available?  I'm fairly
> > certain XFS is used.  The RAID HOWTO doesn't seem to go into detail
> > regarding how to examine filesystems on an array.
> 
> There are no partition tables.  Just a filesystem.  Does xfs have a
> check-and-repair tool?  Try that.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

