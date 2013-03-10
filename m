From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Sun, 10 Mar 2013 12:49:53 +0800
Message-ID: <513C10F1.7070907@fnarfbargle.com>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com> <513AC802.8070306@fnarfbargle.com> <CAKHEz2ZstCbbTF-nALjSDZ7O7yW7DRSN8YpKpcpTj1Ur404NWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2ZstCbbTF-nALjSDZ7O7yW7DRSN8YpKpcpTj1Ur404NWw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/03/13 03:56, Dave Cundiff wrote:
> On Sat, Mar 9, 2013 at 12:26 AM, Brad Campbell
> <lists2009@fnarfbargle.com> wrote:
>>
>> I'd be interested if you could test it against 3.7.9.
>>
>> I have a 6 drive RAID10. 3 Drives are on the on-board AHCI, and the other
>> three are on an LSI 9240-8i (SAS2008 with mpt2sas module).
>>
>> TRIM is being passed down the stack as after an fstrim of the ext4 fs on the
>> RAID the mismatch count goes through the roof.
>>
>> The 3 drives on the LSI are Intel 330 (which support deterministic read
>> after trim) while the drives on the AHCI are Samsung 830 (which are *not*
>> deterministic after trim).
>>
>> My raid is 6 drives in an n2 configuration, so three pairs of mirrors. Each
>> one a Samsung and an Intel.
>>
>
> While I set this up could you let me know what you have in the
> following sys files?
>
> /sys/block/[mddevice]/discard_alignment
> /sys/block/[mddevice]/queue/discard_granularity
> /sys/block/[mddevice]/queue/discard_max_bytes
>
> Also what chunk size is your array set to?


brad@srv:~$ cat /sys/block/md2/discard_alignment
32504832
brad@srv:~$ cat /sys/block/md2/queue/discard_granularity
33553920
brad@srv:~$ cat /sys/block/md2/queue/discard_max_bytes
65536

/dev/md2:
         Version : 1.2
   Creation Time : Fri Nov  9 15:49:44 2012
      Raid Level : raid10
      Array Size : 628752000 (599.62 GiB 643.84 GB)
   Used Dev Size : 209584000 (199.87 GiB 214.61 GB)
    Raid Devices : 6
   Total Devices : 6
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sun Mar 10 12:49:41 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 64K

            Name : unset:2
            UUID : 5a6bc3c5:f37768c6:909783aa:2c3fbd28
          Events : 23015

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync set-A   /dev/sda2
        1      65       66        1      active sync set-B   /dev/sdu2
        2       8       18        2      active sync set-A   /dev/sdb2
        3      65       34        3      active sync set-B   /dev/sds2
        4       8       50        4      active sync set-A   /dev/sdd2
        5      65       50        5      active sync set-B   /dev/sdt2

Regards,
Brad
