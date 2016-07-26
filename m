From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 15:34:28 -0500
Message-ID: <5797C954.2070705@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 10:19 AM, Chris Murphy wrote:
> It'd be interesting to see mdadm -E for sdc and sdd.
> 
> GPT uses LBA 0-3. And mdadm metadata 1.2 is 4K from the start. These
> do not overlap. So I'm unconvinced that mdadm -C applied to sdc and
> sdd instead of sdc1 and sdd1 is the source of the problem.
> 
> Further, gdisk specifically said the GPT header was corrupt. The PMBR,
> LBA 0, is intact, and the table data (LBA 2) is intact. Only LBA 2 was
> stepped on by something?
> 
> What do you get for gdisk -l /dev/sdc? Another warning or is it OK?
> 
> Also for what it's worth: primary, extended, logical are terms that do
> not apply to GPT partitioned disks. There is only one kind of
> partition with GPT disks, no distinctions.
> 
> 

Chris, sdc is now my degraded array (in the original drive state), sdd is the
one I fixed the gdisk error on. /dev/sdc still reports the main GPT header
corruption. The mdadm -E on both sdc/sdd show:

# mdadm -E /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 6e520607:f152d8b9:dd2a3bec:5f9dc875
           Name : valkyrie:4  (local to host valkyrie)
  Creation Time : Mon Mar 21 02:27:21 2016
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 2930135488 (2794.39 GiB 3000.46 GB)
  Used Dev Size : 5860270976 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=48 sectors
          State : clean
    Device UUID : e15f0ea7:7e973d0c:f7ae51a1:9ee4b3a4

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Jul 26 15:15:50 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ff210f72 - correct
         Events : 4248


   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)

# mdadm -E /dev/sdd
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

The GPT header error shown on sdc is:

# gdisk -l /dev/sdc
GPT fdisk (gdisk) version 1.0.1

Caution: invalid main GPT header, but valid backup; regenerating main header
from backup!

Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
Disk /dev/sdc: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 3F835DD0-AA89-4F86-86BF-181F53FA1847
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 212958 sectors (104.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            8192      5860328334   2.7 TiB     FD00  Linux RAI

The sdd drive is just waiting in limbo for me to decide how best to tackle
putting all the pieces together again. Either (1) blow away md4 and lose the
array, recreate the array using sdc1/sdd1, create a new filesystem, and then
recopy the data (few hours of watching it format and copy....) or (2) save the
array and add sdd back and see if it will be come part of the array and just
live with my initial screwup of using sdc/sdd instead of sdc1/sdd1 and ignore
the gdisk warning (that is complaining about a partition table that isn't being
used anyway?) gdisk on sdd is now happy (of course nothing is using sdd at the
moment).

# gdisk -l /dev/sdd
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdd: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 3F835DD0-AA89-4F86-86BF-181F53FA1847
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 212958 sectors (104.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            8192      5860328334   2.7 TiB     FD00  Linux RAID

What do you think my best option is? Or, is it a take your pick type scenario?
Thanks for your help.

-- 
David C. Rankin, J.D.,P.E.
