From: Tim Small <tim@buttersideup.com>
Subject: Re: read errors with md RAID5 array
Date: Tue, 16 Aug 2016 12:40:45 +0100
Message-ID: <d1ccb93d-6856-4b07-04ea-3c4ff9541d60@buttersideup.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <20160815145937.dsjtzpjdnwfpmxyv@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160815145937.dsjtzpjdnwfpmxyv@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 15/08/16 15:59, Andreas Klauer wrote:
> On Mon, Aug 15, 2016 at 02:12:23PM +0100, Tim Small wrote:
>> > I'm seeing some strange read errors whilst reading from an md RAID5
>> > array (3x 2TB SATA Drives, Intel AHCI controller).
> mdadm --examine and --examine-badblocks for all disks/partitions?
> 


Hi,

Thanks very much for your suggestions...


# for i in a c d ; do mdadm --examine-badblocks  /dev/sd${i}2 ; done
Bad-blocks on /dev/sda2:
          2321554488 for 512 sectors
          2321555000 for 512 sectors
          2321555512 for 152 sectors
Bad-blocks on /dev/sdc2:
             1656848 for 128 sectors
            28490768 for 512 sectors
            28491280 for 392 sectors
            28572344 for 120 sectors
            32760864 for 128 sectors
          2321554488 for 512 sectors
          2321555000 for 512 sectors
          2321555512 for 152 sectors
Bad-blocks on /dev/sdd2:
             1656848 for 128 sectors
            28490768 for 512 sectors
            28491280 for 392 sectors
            28572344 for 120 sectors
            32760864 for 128 sectors
          2321554488 for 512 sectors
          2321555000 for 512 sectors
          2321555512 for 152 sectors

I didn't know about the bad block functionality in md.  The mdadm manual
page doesn't say much, so is this the canonical document?

http://neil.brown.name/blog/20100519043730

Until recently, two of the drives (sda, sdc) were running a firmware
version which (as far as I can work out) made them occasionally lock up
and disappear from the OS (requiring a power cycle), this firmware has
now been updated, so hopefully they'll now behave.

Degraded array reporting was also broken on this machine for a couple of
weeks due to an email misconfiguration (now fixed), so last week I found
it with sda (ML0220F30ZE35D) apparently missing from the machine, and
also with pending sectors on sdb (ML0220F31085KD).  The array rebuilt
quite quickly from the bitmap, and then I turned to trying to resolve
the pending sectors...

When the 'check' action didn't force the reallocations, I ran a 'repair'
action instead (thinking that perhaps the check wasn't attempting the
read+recontruct+write for some reason, however I now assume that this
was the wrong thing to do in the light of the bad block list entries).

I'm not really sure from the blog post, under what circumstances a bad
block entry would end up being written to multiple devices in the array,
and under what circumstances it might be written to all devices in an
array?  There are no entries on these array members which appear on only
one array member, and some are present on all three drives - which seems
strange to me.

I suppose a combination of the "Firstly" and "Secondly" paragraphs would
result in the same block being marked as bad on two devices.

Will the detection of an inconsistency (e.g. via a check) mark the
stripe which was impacted as bad on all active array members?

FWIW, what I'd like to do in the future with this array, is to reshape
it into a 4 drive RAID6, and then grow it to a 5 drive RAID6, and
possibly replace one or both of sda (ML0220F30ZE35D) and sdc
(ML0220F31085KD).  However I'd like to try and do this without losing
any data which is currently on the array but marked as inaccessible.
I'd also like to avoid losing the entire array, if the reshape fails
when the array is in this state with unreadable portions.

In the meantime I'm trying to work out what data (if any) is now
inaccessible.  This is made slightly more interesting because this array
has 'bcache' sitting in front of it, so I might have good data in the
cache on the SSD which is marked bad/inaccessible on the raid5 md device.

Tim.


# for i in a c d ; do mdadm --examine  /dev/sd${i}2 ; done


/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : ad7ef7fa:e78344ea:a8778f06:abf07bf5
           Name : magic:2  (local to host magic)
  Creation Time : Wed Jul 15 14:43:06 2015
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3885793456 (1852.89 GiB 1989.53 GB)
     Array Size : 3885793280 (3705.78 GiB 3979.05 GB)
  Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=176 sectors
          State : clean
    Device UUID : fcc77733:e7e3582c:e8bff1ce:dd8d5232

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug 16 09:05:35 2016
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : d18d7379 - correct
         Events : 520706

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : ad7ef7fa:e78344ea:a8778f06:abf07bf5
           Name : magic:2  (local to host magic)
  Creation Time : Wed Jul 15 14:43:06 2015
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3885793456 (1852.89 GiB 1989.53 GB)
     Array Size : 3885793280 (3705.78 GiB 3979.05 GB)
  Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=176 sectors
          State : clean
    Device UUID : 55004cc7:b2e691de:c612612a:675ea2f3

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug 16 09:05:35 2016
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 345a1f90 - correct
         Events : 520706

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : ad7ef7fa:e78344ea:a8778f06:abf07bf5
           Name : magic:2  (local to host magic)
  Creation Time : Wed Jul 15 14:43:06 2015
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3885793456 (1852.89 GiB 1989.53 GB)
     Array Size : 3885793280 (3705.78 GiB 3979.05 GB)
  Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=176 sectors
          State : clean
    Device UUID : 9abd8f30:29cb5ff5:2742646f:df56aa87

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug 16 09:05:35 2016
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 8d769b9e - correct
         Events : 520706

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
