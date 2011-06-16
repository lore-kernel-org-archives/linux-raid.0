From: "Lawrence, Joe" <Joe.Lawrence@stratus.com>
Subject: mdadm 3.2.1 segfaulting on boot when missing RaidDevice 0
Date: Thu, 16 Jun 2011 09:51:51 -0400
Message-ID: <CC98C7236C1DB341A7369B3274581F8E063E36@EXHQ1.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Using mdadm 3.2.1 from RedHat, I'm seeing occasional segmentation faults
on boot when only the first member (RaidDisk 0) of a RAID 1 pair is
present.

The crash occurs in Assemble.c and seems to be only invoked when the
initramfs is created with an /etc/mdadm.conf containing a line that
specifies an md device that is missing RaidDisk 1.  In RedHat terms,
this is during the Dracut environment, so I'm not sure how easy it would
be to save a core from this.

Analyzing the code backwards from the segfault address (it occurs on
lines 1386 or 1387 depending upon whatever random bits are living on the
heap), I added debugging prints and realized that the loop immediately
after the "If any devices did not get added because the kernel rejected
them ..." comment is stepping past the end of the best[] array.  This
value then indexes devices[].  Notice that the loop on line 1385 starts
at 0 and ends at bestcnt (inclusive).

I can see that on line 850, only 10 best[] entries are allocated, but
then on line 1386, a read of entry [10] is attempted.

dmesg output:

kernel: md: md5 stopped.
kernel: dracut: mdadm: Assemble.c(710) : allocated 16 entries (6400
bytes) @ 0x126bf00
kernel: dracut: mdadm: Assemble.c(837) : i = devices[0].i.disk.raid_disk
= 0
kernel: dracut: mdadm: Assemble.c(850) : allocated 10 entries (40 bytes)
@ 0x12740d0
kernel: md: bind<sdr3>
kernel: md/raid1:md5: active with 1 out of 2 mirrors
kernel: created bitmap (1 pages) for device md5
kernel: md5: bitmap initialized from disk: read 1/1 pages, set 2 bits
kernel: md5: detected capacity change from 0 to 16844251136
kernel: dracut: mdadm: /dev/md5 has been started with 1 drive (out of
2).
kernel: dracut: mdadm: Assemble.c(1386) : best @ 0x12740d0, bestcnt == i
== 10
kernel: md5: unknown partition table

I have tested breaking out of the loop starting on line 1385 when i ==
bestcnt (after my debugging output) and I do not see any further
segmentation faults.  I would think this loop should be rewritten as:

for (i = 0; i < bestcnt; i++) {
...
}

Additional debugging prints revealed that line 837, i =
devices[devcnt].i.disk.raid_disk;  is executed prior to the allocation
of newbest[].  When I had RaidDisk 0 inserted, i=0.  When the other disk
was present, i=1.  In the latter case, enough best[] was allocated and
boot succeeded, though I'm not sure if best[newbestcnt] was ever
properly initialized.  I think we just got lucky and booted ok.

The md device was created like so:

mdadm -C /dev/md5 -b internal --level=1 --raid-devices=2 /dev/sdc1
/dev/sdk1

mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Wed Jun 15 15:15:24 2011
     Raid Level : raid1
     Array Size : 8224212 (7.84 GiB 8.42 GB)
  Used Dev Size : 8224212 (7.84 GiB 8.42 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Jun 15 15:16:26 2011
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : yowler.mno.stratus.com:5  (local to host
yowler.mno.stratus.com)
           UUID : d74aa8e8:14f85390:0cc61025:a0046ec2
         Events : 23

    Number   Major   Minor   RaidDevice State
       0      65       17        0      active sync   /dev/sdc1
       1      65       33        1      active sync   /dev/sdk1


and its corresponding entry in /etc/mdadm.conf:

ARRAY /dev/md5 level=raid1 num-devices=2
UUID=471cf895:ba6ef375:a0bd54b3:1a6b3b08

If any other configuration, logs, or debugging information needs to be
provided, I'll be glad to provide it.

Thanks,

-- Joe Lawrence
