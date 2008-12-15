From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Mon, 15 Dec 2008 15:47:40 -0600
Message-ID: <cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18757.62097.166706.244330@notabene.brown>
	 <cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
	 <18758.52536.345145.238926@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18758.52536.345145.238926@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 3:33 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>>
>> However, it raises a question: bitmaps are about 'resync' not
>> 'recovery'?  How do they differ?
>
> With resync, the expectation is that most of the device is correct.
> The bitmap tells us which sectors aren't, and we just resync those.
>
> With recover, the expectation is that the entire drive contains
> garbage and it has to be recovered from beginning to end.
>
> Each device has a flag to say where the device is in sync write the
> array.  The bit map records which sectors of "in-sync" devices may not
> actually in in-sync at the moment.
> 'resync' synchronises the 'in-sync' devices.
> 'recovery' synchronises a 'not-in-sync' device.b
>
>
>>
>> >> Question 1:
>> >> I'm using a bitmap. Why does the rebuild start completely over?
>> >
>> > Because the bitmap isn't used to guide a rebuild, only a resync.
>> >
>> > The effect of --re-add is to make md do a resync rather than a rebuild
>> > if the device was previously a fully active member of the array.
>>
>> Aha!  This explains a question I raised in another email. What
>> happened there is a previously fully active member of the raid got
>> added, somehow, as a spare, via --incremental. That's when the entire
>> raid thought it needed to be rebuilt. How did that (the device being
>> treated as a spare instead of as a previously fully active member)
>> happen?
>
> It is hard to guess without details, and they might be hard to collect
> after the fact.
> Maybe if you have the kernel logs of when the server rebooted and the
> recovery started, that might contain some hints.

I hope this helps.

Prior to the reboot:

Dec 15 15:19:39 turnip kernel: md: md11: recovery done.
Dec 15 15:19:39 turnip kernel: RAID1 conf printout:
Dec 15 15:19:39 turnip kernel:  --- wd:2 rd:2
Dec 15 15:19:39 turnip kernel:  disk 0, wo:0, o:1, dev:nbd0
Dec 15 15:19:39 turnip kernel:  disk 1, wo:0, o:1, dev:sda

During booting:

<6>raid1: raid set md11 active with 1 out of 2 mirrors
<6>md11: bitmap initialized from disk: read 1/1 pages, set 1 bits
<6>created bitmap (10 pages) for device md11

After boot:

Dec 15 15:34:38 turnip kernel: md: bind<nbd0>
Dec 15 15:34:38 turnip kernel: RAID1 conf printout:
Dec 15 15:34:38 turnip kernel:  --- wd:1 rd:2
Dec 15 15:34:38 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
Dec 15 15:34:38 turnip kernel:  disk 1, wo:0, o:1, dev:sda
Dec 15 15:34:38 turnip kernel: md: recovery of RAID array md11
Dec 15 15:34:38 turnip kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Dec 15 15:34:38 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 15 15:34:38 turnip kernel: md: using 128k window, over a total of
78123988 blocks.

/dev/nbd0 was added via --incremental (mdadm 3.0)


--detail:

/dev/md11:
        Version : 01.00.03
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
     Array Size : 78123988 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (149.01 GiB 160.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 11
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Dec 15 15:35:17 2008
          State : active, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 9% complete

           Name : turnip:11  (local to host turnip)
           UUID : cf24d099:9e174a79:2a2f6797:dcff1420
         Events : 3914

    Number   Major   Minor   RaidDevice State
       2      43        0        0      spare rebuilding   /dev/nbd0
       3       8        0        1      active sync   /dev/sda


turnip:~ # mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11  (local to host turnip)
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 0059434c:ecef51a0:2974482d:ba38f944

Internal Bitmap : 2 sectors from superblock
    Update Time : Mon Dec 15 15:45:21 2008
       Checksum : 21396863 - correct
         Events : 3916


    Array Slot : 3 (failed, failed, empty, 1)
   Array State : _U 2 failed
turnip:~ #

turnip:~ # mdadm --examine /dev/nbd0
/dev/nbd0:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11  (local to host turnip)
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 01524a75:c309869c:6da972c9:084115c6

Internal Bitmap : 2 sectors from superblock
      Flags : write-mostly
    Update Time : Mon Dec 15 15:45:21 2008
       Checksum : 63bab8ce - correct
         Events : 3916


    Array Slot : 2 (failed, failed, empty, 1)
   Array State : _u 2 failed
turnip:~ #



Thanks!!

-- 
Jon
