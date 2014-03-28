From: Tide <lovetide@qq.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size, why?
Date: Fri, 28 Mar 2014 02:44:29 +0000 (UTC)
Message-ID: <loom.20140328T033136-569@post.gmane.org>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se> <loom.20140326T205013-837@post.gmane.org> <53334347.4050108@hardwarefreak.com> <5334425D.5010704@fastmail.fm> <53348C82.1060506@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan <at> hardwarefreak.com> writes:

> 
> On 3/27/2014 10:23 AM, Bernd Schubert wrote:
> ...
> >> commit 508a7f16b242d6c3353e15aab46ac8ca8dc7cd08
> >> Author: NeilBrown <neilb <at> suse.de>
> >> Date:   Wed Apr 4 14:00:40 2012 +1000
> >>
> >>     super1: leave more space in front of data by default.
> >>
> >>     The kernel is growing the ability to avoid the need for a
> >>     backup file during reshape by being able to change the data offset.
> >>
> >>     For this to be useful we need plenty of free space before the
> >>     data so the data offset can be reduced.
> >>
> >>     So for v1.1 and v1.2 metadata make the default data_offset much
> >>     larger.  Aim for 128Meg, but keep a power of 2 and don't use more
> >>     than 0.1% of each device.
> >>
> >>     Don't change v1.0 as that is used when the data_offset is required to
> >>     be zero.
> 
> This is a good match because the discrepancy on his RAID6 is pretty
> close to 128MB per drive.  However, both his RAID5 and RAID6 arrays are
> metadata 1.2.  So this commit alone may not fully explain the capacity
> difference he's seeing between RAID5 and RAID6.  Or is this commit RAID6
> specific?  I don't see that in the comments above.
> 
> Cheers,
> 
> Stan

Yes, it's not fully explain the difference. Here's another test with mdadm
v3.2.6 (which already have the 508a7f16b242d6c3353e15aab46ac8ca8dc7cd08
commit) in CentOS 6.5.

Created a RAID 5 array with 5 1GiB loop devices, the data_offset of this new
array is only 1024 sectors (0.5M).

# MAKEDEV /dev/loop

# for hdd in {1..5}; do truncate -s 1G hdd5$hdd; losetup /dev/loop5$hdd
hdd5$hdd; done

# mdadm -C /dev/md5 -l5 -n4 -x1 /dev/loop5[1-5]

# mdadm --version
mdadm - v3.2.6 - 25th October 2012

# mdadm --examine /dev/loop51
/dev/loop51:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5fb7e243:01760f20:c773f451:09928fa0
           Name : RecordFileServer:5  (local to host RecordFileServer)
  Creation Time : Fri Mar 28 10:14:36 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2096128 (1023.67 MiB 1073.22 MB)
     Array Size : 3142656 (3.00 GiB 3.22 GB)
  Used Dev Size : 2095104 (1023.17 MiB 1072.69 MB)
    Data Offset : 1024 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d662c632:b2aafbac:406c84a6:ae519102

    Update Time : Fri Mar 28 10:15:07 2014
       Checksum : ab92e515 - correct
         Events : 20

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)

# mdadm -D /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Fri Mar 28 10:14:36 2014
     Raid Level : raid5
     Array Size : 3142656 (3.00 GiB 3.22 GB)
  Used Dev Size : 1047552 (1023.17 MiB 1072.69 MB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Fri Mar 28 10:14:56 2014
          State : clean 
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : RecordFileServer:5  (local to host RecordFileServer)
           UUID : 5fb7e243:01760f20:c773f451:09928fa0
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       7       51        0      active sync   /dev/loop51
       1       7       52        1      active sync   /dev/loop52
       2       7       53        2      active sync   /dev/loop53
       5       7       54        3      active sync   /dev/loop54

       4       7       55        -      spare   /dev/loop55


