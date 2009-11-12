From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 18:23:03 -0600
Message-ID: <20091112002315724.HBYG5263@cdptpa-omta04.mail.rr.com>
References: <4AFB2026.2010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFB2026.2010001@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>, 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > would be a pain.  Writing a script to do it automatically is no more
> trouble
> > (or really much different) than writing a script to mount the partition
> > explicitly prior to running mdadm, but it avoids any issues of which I
> am
> > unaware (but can imagine) with, say, trying to grow a bitmap on an array
> > that is other than clean.  I'd rather have mdadm take care of such
> details.
> I think you are overestimating the difficulty of this solution.  It's as
> simple as:
> 
> mdadm -G /dev/md0 --bitmap=none
> mdadm -G /dev/md0 --bitmap=internal --bitmap-chunk=32768 (or even higher)

	No, I was referring to a script which grew an external bitmap on a
mounted file system after mdadm had already done its magic.  What I was
mis-remembering was:

> >>> If you have a temporary space for your data, I'd suggest you move it
> >>> out and go for an internal bitmap solution. It certainly beats the
> >>> patch work you're going to have to do on the startup scripts (and
> >>> every time you update mdadm, or the distro).
> >>>
> >> There should be no need to move the data off - you can add an internal
> >> bitmap using the --grow option.  An internal bitmap does have more of
> an
> >> overhead than an external one though.
> >
> > 	I thought I remembered reading in the man page than an internal
> > bitmap could only be added when the array was created?  Is that
> incorrect?
> 
> Yes, very incorrect.  You can use grow to add an internal bitmap later,

	I guess I skimmed over the manual rather quickly back then, and I
was dealing with serious RAID issues at the time, so I must have improperly
inferred the man page to imply this in the section which says, "Note that
if you add a bitmap stored in a file which is in a filesystem that is on the
raid array being affected, the system will deadlock.  The bitmap must be on
a separate filesystem" to read something more like, "Note that if you add a
bitmap ...  the bitmap must be on a separate filesystem.

> the only limitation is that the bitmap must be small enough to fit in
> the reserved space around the superblock.  It's in the case that you
> want to create some super huge, absolutely insanely fine grained bitmap
> that it must be done at raid device creation time and that's only so it
> can reserve sufficient space for the bitmap.

	How can I know how much space is available?  I tried adding the
internal bitmap without specifying anything, and it seems to have worked
fine.  When I created the bitmap in an external file (without specifying the
size), it was around 100K, which seems rather small.  Both of these systems
use un-partitioned disks with XFS mounted directly on the RAID array.  One
is a 7 drive RAID5 array on 1.5 TB disks and the other is a 10 drive RAID6
array on 1.0TB disks.  Both are using a version 1.2 superblock.  The only
thing which jumps out at me is --examine, but it doesn't seem to tell me
much:

RAID-Server:/usr/share/pyTivo# mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
           Name : RAID-Server:0  (local to host RAID-Server)
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953524896 (931.51 GiB 1000.20 GB)
     Array Size : 15628197888 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d40c9255:cef0739f:966d448d:e549ada8

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Nov 11 18:17:26 2009
       Checksum : 9a4cc480 - correct
         Events : 488380

     Chunk Size : 256K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : Uuuuuuuuuu


Backup:/etc/gadmin-rsync# mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 940ae4e4:04057ffc:5e92d2fb:63e3efb7
           Name : 'Backup':0
  Creation Time : Sun Jul 12 20:44:02 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 2930276896 (1397.26 GiB 1500.30 GB)
     Array Size : 17581661184 (8383.59 GiB 9001.81 GB)
  Used Dev Size : 2930276864 (1397.26 GiB 1500.30 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6156794f:00807e1b:306ed20d:b81914de

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Nov 11 11:52:43 2009
       Checksum : 12afc60a - correct
         Events : 10100

         Layout : left-symmetric
     Chunk Size : 256K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6)
   Array State : Uuuuuuu

