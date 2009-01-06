From: whollygoat@letterboxes.org
Subject: Re: RAID5 (mdadm) array hosed after grow operation
Date: Tue, 06 Jan 2009 00:45:01 -0800
Message-ID: <1231231501.19066.1293214739@webmail.messagingengine.com>
References: <1231144738.2997.1293010001@webmail.messagingengine.com>
 <alpine.DEB.1.10.0901050913470.3359@p34.internal.lan>
 <18786.34570.756734.253596@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18786.34570.756734.253596@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 6 Jan 2009 09:17:46 +1100, "Neil Brown" <neilb@suse.de> said:
> On Monday January 5, jpiszcz@lucidpixels.com wrote:
> > cc linux-raid
> > 
> > On Mon, 5 Jan 2009, whollygoat@letterboxes.org wrote:
> > 
> > > I think growing my RAID array after replacing all the
> > > drives with bigger ones has somehow hosed the array.
> > >
> > > The system is Etch with a stock 2.6.18 kernel and
> > > mdadm v. 2.5.6, running on an Athlon 1700 box.
> > > The array is 6 disk (5 active, one spare) RAID 5
> > > that has been humming along quite nicely for
> > > a few months now.  However, I decided to replace
> > > all the drives with larger ones.
> > >
> > > The RAID reassembled fine at each boot as the drives
> > > were replaced one by one.  After the last drive was
> > > partitioned and added to the array, I issued the
> > > command
> > >
> > >   "mdadm -G /dev/md/0 -z max"
> > >
> > > to grow the array to the maximum space available
> > > on the smallest drive.  That appeared to work just
> > > fine at the time, but booting today the array
> > > refused to assemble with the following error:
> > >
> > >    md: hdg1 has invalid sb, not importing!
> > >    md: md_import_device returned -22
> > >
> > > I tried to force assembly but only two of the remaining
> > > 4 active drives appeared to be fault free.  dmesg gives
> > >
> > >    md: kicking non-fresh hde1 from array!
> > >    md: unbind<hde1>
> > >    md: export_rdev(hde1)
> > >    md: kicking non-fresh hdi1 from array!
> > >    md: unbind<hdi1>
> > >    md: export_rdev(hdi1)
> 
> Please report
>    mdadm --examine /dev/whatever
> for every device that you think should be a part of the array.

I noticed as I copied and pasted below the requested info,
that "Device Size" and "Used Size" all make sense, whereas
with the -X option "Sync Size" reflects the sizes of the 
swapped out drives "39078016 (37.27 GiB 40.02 GB)" 
for hdg1 and hdo1.

Also, when booting today, I was able to get my eye balls 
moving fast enough to capture boot messages I noticed but
couldn't decipher yesterday "incorrect meta data area
header checksum" for hdo and hdg, but for at least one, and I 
think two other drives that I still wasn't fast enough to
capture.

Also, with regard to your comment below, what do you mean by
"active bitmap".  I seems to me I couldn't do anything with
the array until it was activated.

Hmm, just noticed something else that seems weird. There seem
to be 10 and 11 place holders (3 drives each) in the "Array Slot"
field below which is respectively 4 and 5 more places than there
are drives.

Thanks for you help.

------------- begin output --------------
fly:~# mdadm -E /dev/hde1
/dev/hde1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 160086320 (76.34 GiB 81.96 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 160086448 sectors
          State : clean
    Device UUID : d0992c0a:d645873f:d1e325cc:0a00327f

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Jan  3 21:31:41 2009
       Checksum : 1a5674a1 - correct
         Events : 218

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 9 (failed, failed, failed, failed, failed, empty, 3, 2,
    0, 1, 4)
   Array State : uUuuu 5 failed

 
fly:~# mdadm -E /dev/hdg1
/dev/hdg1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 156296176 (74.53 GiB 80.02 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 156296304 sectors
          State : clean
    Device UUID : 72b7258a:22e70cea:cc667617:8873796f

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Jan  3 21:31:41 2009
       Checksum : 7ff97f89 - correct
         Events : 218

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 10 (failed, failed, failed, failed, failed, empty, 3,
    2, 0, 1, 4)
   Array State : uuuuU 5 failed

 
fly:~# mdadm -E /dev/hdi1
/dev/hdi1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 160086320 (76.34 GiB 81.96 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 160086448 sectors
          State : clean
    Device UUID : ade7e4e9:e58dc8df:c36df5b7:a938711d

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Jan  3 21:31:41 2009
       Checksum : 245ecd1e - correct
         Events : 218

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 8 (failed, failed, failed, failed, failed, empty, 3, 2,
    0, 1, 4)
   Array State : Uuuuu 5 failed
 

fly:~# mdadm -E /dev/hdk1
/dev/hdk1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 234436336 (111.79 GiB 120.03 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 234436464 sectors
          State : clean
    Device UUID : a7c337b5:c3c02071:e0f1099c:6f14a48e

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Jan  4 16:15:10 2009
       Checksum : df2d3ea6 - correct
         Events : 222

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 7 (failed, failed, failed, failed, failed, empty, 3, 2,
    failed, failed)
   Array State : __Uu_ 7 failed
 
 
fly:~# mdadm -E /dev/hdm1
/dev/hdm1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 156360432 (74.56 GiB 80.06 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 156360560 sectors
          State : clean
    Device UUID : 01c88710:44a63ce1:ae1c03ba:0d8aaca0

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Jan  4 16:15:10 2009
       Checksum : d14c18ec - correct
         Events : 222

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 6 (failed, failed, failed, failed, failed, empty, 3, 2,
    failed, failed)
   Array State : __uU_ 7 failed

 
fly:~# mdadm -E /dev/hdo1
/dev/hdo1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 6d57c75c:01b1b110:524cdc82:f2fc9c68
           Name : fly:FlyFileServ  (local to host fly)
  Creation Time : Mon Aug  4 00:59:16 2008
     Raid Level : raid5
   Raid Devices : 5

    Device Size : 234436336 (111.79 GiB 120.03 GB)
     Array Size : 625184768 (298.11 GiB 320.09 GB)
      Used Size : 156296192 (74.53 GiB 80.02 GB)
   Super Offset : 234436464 sectors
          State : clean
    Device UUID : bbb30d5a:39f90588:65d5b01c:3e1a4d9a

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Jan  4 16:15:10 2009
       Checksum : 27385082 - correct
         Events : 222

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 5 (failed, failed, failed, failed, failed, empty, 3, 2,
    failed, failed)
   Array State : __uu_ 7 failed

-------------- end output ---------------
> 
> > >
> > > I also noticed that "mdadm -X <drive>" shows
> > > the pre-grow device size for 2 of the devices
> > > and some discrepancies between event and event cleared
> > > counts.
> 
> You cannot grow an array with an active bitmap... or at least you
> shouldn't be able to.  Maybe 2.6.18 didn't enforce that.  Maybe that
> is what caused the problem - not sure.
> 
> > >
> > > One last thing I found curious---from dmesg:
> > >
> > >    EXT3-fs error (device hdg1): ext3_check_descriptors: Block
> > >    bitmap for group 0 not in group (block 2040936682)!
> > >    EXT3-fs: group descriptors corrupted!
> > >
> > > There is not ext3 directly on hdg1.  LVM sits between the
> > > and the filesystem, so the above message seems suspect.
> 
> Seems like something got confused during boot and the wrong device got
> mounted.  That is bad.
> 
> NeilBrown
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - The professional email service

