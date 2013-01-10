From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Thu, 10 Jan 2013 10:09:56 -0700
Message-ID: <50EEF5E4.8070509@intel.com>
References: <CAKnNFz96pxExLDpoX1Yi+m0ASb-pV9eUVwZ7xmNQE9LnQHWT_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKnNFz96pxExLDpoX1Yi+m0ASb-pV9eUVwZ7xmNQE9LnQHWT_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/10/2013 09:23 AM, chris wrote:
> Hello,
>
> I have a machine which was running a imsm raid volume, where the
> motherboard failed and I do not have access to another system with
> imsm. I remember noticing some time ago that mdadm could recognize
> these arrays, so I decided to try recovery in a spare machine with the
> disks from the array.
>
> I guess my questions are:
> Is this the right forum for help with this?
> Am I even going down a feasible path here or is this array dependent
> on the HBA in some way?
> If it is possible any ideas of anything else I can do to debug this further?

Typically mdadm probes the OROM and look for platform details. But you 
can try overriding with:
export IMSM_NO_PLATFORM=1

See if that works for you.

> The original array was a raid 5 of 4x2TB sata disks
>
> When I examine the first disk, things look good:
>
> mdadm --examine /dev/sdb
> mdadm: /dev/sdb is not attached to Intel(R) RAID controller.
> mdadm: /dev/sdb is not attached to Intel(R) RAID controller.
> /dev/sdb:
>            Magic : Intel Raid ISM Cfg Sig.
>          Version : 1.3.00
>      Orig Family : 226cc5df
>           Family : 226cc5df
>       Generation : 000019dc
>       Attributes : All supported
>             UUID : b67ea029:aaea7da2:2540c1eb:ebe98af1
>         Checksum : 651263bf correct
>      MPB Sectors : 2
>            Disks : 4
>     RAID Devices : 1
>
>    Disk02 Serial : Z1E1RPA9
>            State : active
>               Id : 00030000
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
> [Volume0]:
>             UUID : 51a415ba:dc9c8cd7:5b3ea8de:465b4630
>       RAID Level : 5
>          Members : 4
>            Slots : [__U_]
>      Failed disk : 0
>        This Slot : 2
>       Array Size : 11721072640 (5589.04 GiB 6001.19 GB)
>     Per Dev Size : 3907024648 (1863.01 GiB 2000.40 GB)
>    Sector Offset : 0
>      Num Stripes : 15261814
>       Chunk Size : 128 KiB
>         Reserved : 0
>    Migrate State : idle
>        Map State : failed
>      Dirty State : clean
>
>    Disk00 Serial : Z1E1AKPH:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk01 Serial : Z24091Q5:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk03 Serial : Z1E19E4K:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>
> When I try to scan for arrays I get this:
> # mdadm --examine --scan
> HBAs of devices does not match (null) != (null)
> ARRAY metadata=imsm UUID=b67ea029:aaea7da2:2540c1eb:ebe98af1
> ARRAY /dev/md/Volume0 container=b67ea029:aaea7da2:2540c1eb:ebe98af1
> member=0 UUID=51a415ba:dc9c8cd7:5b3ea8de:465b4630
> ARRAY metadata=imsm UUID=b67ea029:aaea7da2:2540c1eb:ebe98af1
> ARRAY /dev/md/Volume0 container=b67ea029:aaea7da2:2540c1eb:ebe98af1
> member=0 UUID=51a415ba:dc9c8cd7:5b3ea8de:465b4630
>
> My first concern is the warning that the HBA is missing, the whole
> reason I am going at it this way is because I don't have the HBA.
> Second concern is duplicate detection of the same array.
>
> If i try to run # mdadm -As:
> mdadm: No arrays found in config file or automatically
>
>   I also tried adding the output from --examine --scan to
> /etc/mdadm/mdadm.conf but after trying that I now get blank output:
>
> # mdadm --assemble /dev/md/Volume0
> #
> # mdadm --assemble --scan
> #
>
> full examine of all disks involved:
>
> /dev/sdb:
>            Magic : Intel Raid ISM Cfg Sig.
>          Version : 1.3.00
>      Orig Family : 226cc5df
>           Family : 226cc5df
>       Generation : 000019dc
>       Attributes : All supported
>             UUID : b67ea029:aaea7da2:2540c1eb:ebe98af1
>         Checksum : 651263bf correct
>      MPB Sectors : 2
>            Disks : 4
>     RAID Devices : 1
>
>    Disk02 Serial : Z1E1RPA9
>            State : active
>               Id : 00030000
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
> [Volume0]:
>             UUID : 51a415ba:dc9c8cd7:5b3ea8de:465b4630
>       RAID Level : 5
>          Members : 4
>            Slots : [__U_]
>      Failed disk : 0
>        This Slot : 2
>       Array Size : 11721072640 (5589.04 GiB 6001.19 GB)
>     Per Dev Size : 3907024648 (1863.01 GiB 2000.40 GB)
>    Sector Offset : 0
>      Num Stripes : 15261814
>       Chunk Size : 128 KiB
>         Reserved : 0
>    Migrate State : idle
>        Map State : failed
>      Dirty State : clean
>
>    Disk00 Serial : Z1E1AKPH:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk01 Serial : Z24091Q5:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk03 Serial : Z1E19E4K:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
> /dev/sdc:
>     MBR Magic : aa55
> Partition[0] :   3907027057 sectors at           63 (type 42)
> /dev/sdd:
>            Magic : Intel Raid ISM Cfg Sig.
>          Version : 1.3.00
>      Orig Family : 226cc5df
>           Family : 226cc5df
>       Generation : 000019d9
>       Attributes : All supported
>             UUID : b67ea029:aaea7da2:2540c1eb:ebe98af1
>         Checksum : 641438ba correct
>      MPB Sectors : 2
>            Disks : 4
>     RAID Devices : 1
>
>    Disk03 Serial : Z1E19E4K
>            State : active
>               Id : 00020000
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
> [Volume0]:
>             UUID : 51a415ba:dc9c8cd7:5b3ea8de:465b4630
>       RAID Level : 5
>          Members : 4
>            Slots : [__UU]
>      Failed disk : 0
>        This Slot : 3
>       Array Size : 11721072640 (5589.04 GiB 6001.19 GB)
>     Per Dev Size : 3907024648 (1863.01 GiB 2000.40 GB)
>    Sector Offset : 0
>      Num Stripes : 15261814
>       Chunk Size : 128 KiB
>         Reserved : 0
>    Migrate State : idle
>        Map State : failed
>      Dirty State : clean
>
>    Disk00 Serial : Z1E1AKPH:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk01 Serial : Z24091Q5:0
>            State : active
>               Id : ffffffff
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
>
>    Disk02 Serial : Z1E1RPA9
>            State : active
>               Id : 00030000
>      Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)
> /dev/sde:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
>
> # dpkg -l | grep mdadm
> ii  mdadm                                                       3.2.5-1+b1
>
> thanks
> chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

