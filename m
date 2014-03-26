From: Tide <lovetide@qq.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size, why?
Date: Wed, 26 Mar 2014 20:00:59 +0000 (UTC)
Message-ID: <loom.20140326T205013-837@post.gmane.org>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike <at> swm.pp.se> writes:

> 
> On Wed, 26 Mar 2014, Tide wrote:
> 
> > The partition size of each disk in the two arrays are identical (all 
> > partitions have 5860531087 logical sectors), so why the array size are 
> > different? Is it caused by different mdadm version (I guess so) or 
> > different array level or something else?
> 
> Do mdadm -E on one component device from each md volume. My first guess 
> would be different data offset.
> 

Yes, the data offset are different. But why? When creating array, I didn't
specified any other options:
mdadm -C /dev/md127 -l 5 -n 3 /dev/sd[bcd]1
mdadm --add /dev/md127 /dev/sd[ef]1
mdadm --grow /dev/md127 -n 4

mdadm -C /dev/md127 -l 6 -n 5 /dev/sd[bcdef]1

=================
Array 1 (RAID 5):
=================
# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dfd3bbe7:4b0231fe:9007bc4a:e106acac
           Name : RecordBackup01:127  (local to host RecordBackup01)
  Creation Time : Fri Jan 11 17:56:18 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860529039 (2794.52 GiB 3000.59 GB)
     Array Size : 8790792192 (8383.55 GiB 9001.77 GB)
  Used Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=911 sectors
          State : active
    Device UUID : 85fa01f1:b8e7875c:5f19039f:b198c0bb

    Update Time : Thu Mar 27 03:35:06 2014
       Checksum : 16ff8ff5 - correct
         Events : 7266

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


=================
Array 2 (RAID 6):
=================
# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 923c9658:12739258:506fc8b0:f8c5edf3
           Name : RecordBackup02:127  (local to host RecordBackup02)
  Creation Time : Fri Mar 21 18:12:00 2014
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 8790402048 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=911 sectors
          State : clean
    Device UUID : 94a83f3f:33991f7a:9545d12f:87bd169f

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Mar 27 01:55:49 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 5a7094a4 - correct
         Events : 8178

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)



