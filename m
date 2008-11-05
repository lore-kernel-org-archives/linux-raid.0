From: Brad Campbell <brad@wasp.net.au>
Subject: Solved : Re: Time to ask for help. Raid-5 Dual drive failure
Date: Wed, 05 Nov 2008 12:50:22 +0400
Message-ID: <49115E4E.7000002@wasp.net.au>
References: <4910BC0E.9000307@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4910BC0E.9000307@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:
> Ok, so it finally died.
> 
> I was doing a large copy to an ext3 filesystem on md0 when one drive 
> dropped out (SATA error). 3 minutes later a second drive dropped out 
> (SATA error).
> 
> I've tried to re-assemble the array with
> mdadm --assemble --force /dev/md0 but it errors out with
> 
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> 

So I re-read my archives on the linux-raid list, consulted google and decided I had enough 
information available to be able to re-create the array.

I figured looking at the output from --examine on the first drive to die would give me a good 
indicator on what the array *should* look like.

/dev/sdj1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:23:33 2008
           State : active
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 210701c1 - correct
          Events : 0.1338267

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     0       8      145        0      active sync   /dev/sdj1

    0     0       8      145        0      active sync   /dev/sdj1
    1     1       8      161        1      active sync   /dev/sdk1
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg


I supposed the most important thing was the order of the disks, so I tried this magic incantation..

mdadm --create /dev/md0 --assume-clean --level 5 --raid-devices=10 missing /dev/sdk1 /dev/sdl 
/dev/sdm1 /dev/sdo1 /dev/sdn1 /dev/sdh1 /dev/sdi1 /dev/sdf1 /dev/sdg

That failed being completely unable to locate the superblock.

Then I wondered if perhaps it was defaulting to a different chunk size, (never thought to check with 
--examine on one of the newly created components)

Second time I added --chunk 128 and e2fsck found a superblock however it was very mangled.

Third time I did an --examine on one of the newly created components and noticed that the new array 
defaulted to left-symmetric, so I added --layout left-asymmetric and it all came back up.

mdadm --create /dev/md0 --assume-clean --level 5 --chunk 128 --layout left-asymmetric 
--raid-devices=10 missing /dev/sdk1 /dev/sdl /dev/sdm1 /dev/sdo1 /dev/sdn1 /dev/sdh1 /dev/sdi1 
/dev/sdf1 /dev/sdg

For those following along at home, double check everything!
Don't _ever_ try to see if it's right by mounting the array, use fsck -n which will do a read only 
check of the filesystem and not try and write anything. A mount will try and replay the journal.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
