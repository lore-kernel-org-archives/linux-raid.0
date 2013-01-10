From: chris <tknchris@gmail.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Thu, 10 Jan 2013 15:19:06 -0500
Message-ID: <CAKnNFz9arLw6NBr4y0E3T+tGc6E5F5CZdGtRjSjwZcSgyyLtgw@mail.gmail.com>
References: <CAKnNFz96pxExLDpoX1Yi+m0ASb-pV9eUVwZ7xmNQE9LnQHWT_g@mail.gmail.com>
	<50EEF5E4.8070509@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50EEF5E4.8070509@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Jiang <dave.jiang@intel.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dave,

Thanks for the tip, this has gotten me further

# mdadm --assemble --scan
# cat /proc/mdstat
Personalities :
md127 : inactive sdd[1](S) sdb[0](S)
      4520 blocks super external:imsm

So atleast now it has created an array of sorts but it only has 2 out
of the 4 disks it should and also all disks appear to be marked as
spares.

Would I follow the same logic as typical mdadm recovery where I need
to create the array again with the right layout and disks in right
order and gain access to data without wiping it ?

Any advice what direction to go in from here?

This info I was able to get using mdadm seems accurate as far as how
the array was setup so I just need to know how to recreate or assemble
the array and get it online so I can access it

          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : 226cc5df
         Family : 226cc5df
     Generation : 000019dc
     Attributes : All supported
           UUID : b67ea029:aaea7da2:2540c1eb:ebe98af1
       Checksum : 651263bf correct
    MPB Sectors : 2
          Disks : 4
   RAID Devices : 1

  Disk02 Serial : Z1E1RPA9
          State : active
             Id : 00030000
    Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)

[Volume0]:
           UUID : 51a415ba:dc9c8cd7:5b3ea8de:465b4630
     RAID Level : 5
        Members : 4
          Slots : [__U_]
    Failed disk : 0
      This Slot : 2
     Array Size : 11721072640 (5589.04 GiB 6001.19 GB)
   Per Dev Size : 3907024648 (1863.01 GiB 2000.40 GB)
  Sector Offset : 0
    Num Stripes : 15261814
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : failed
    Dirty State : clean

  Disk00 Serial : Z1E1AKPH:0
          State : active
             Id : ffffffff
    Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)

  Disk01 Serial : Z24091Q5:0
          State : active
             Id : ffffffff
    Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)

  Disk03 Serial : Z1E19E4K:0
          State : active
             Id : ffffffff
    Usable Size : 3907024648 (1863.01 GiB 2000.40 GB)


thanks
chris

On Thu, Jan 10, 2013 at 12:09 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> export IMSM_NO_PLATFORM=1
