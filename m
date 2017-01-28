From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 5 reshape stalled at 77.5% - next steps??
Date: Sat, 28 Jan 2017 18:29:32 -0500
Message-ID: <CAF-KpgbmnOmbCXDi6_xr9d9Ms5rFt+D3WN=3gu=7xFv0G6U5vw@mail.gmail.com>
References: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
 <20170129041559.723d8259@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170129041559.723d8259@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

On Sat, Jan 28, 2017 at 6:15 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sat, 28 Jan 2017 18:01:30 -0500
> George Rapp <george.rapp@gmail.com> wrote:
>
>> The reshape proceeded normally until it hit 77.5%, where it has been
>> stuck for the last couple of days:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md4 : active raid5 sdd4[13](R) sdb4[12] sdg4[10](F) sdi4[8] sdl4[9]
>> sdf4[1] sdj4[7] sdh4[2] sde4[0] sdk4[11]
>>
>> 13454923776 blocks super 1.1 level 5, 512k chunk, algorithm 2 [10/9]
>> [UUUU_UUUU_]
>> [===============>.....] reshape = 77.5% (1490403328/1922131968)
>> finish=2544246.9min speed=2K/sec
>
> It shows you have a failed device (sdg4) but you don't mention anything about
> that? Post your mdadm --detail /dev/md4, and what do you have in dmesg.

Roman -

Good catch. I didn't notice that.

# mdadm --detail /dev/md4
/dev/md4:
        Version : 1.1
  Creation Time : Thu Feb 17 14:54:06 2011
     Raid Level : raid5
     Array Size : 13454923776 (12831.62 GiB 13777.84 GB)
  Used Dev Size : 1922131968 (1833.09 GiB 1968.26 GB)
   Raid Devices : 10
  Total Devices : 10
    Persistence : Superblock is persistent

    Update Time : Thu Jan 26 08:06:56 2017
          State : active, FAILED, reshaping
 Active Devices : 8
Working Devices : 9
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Reshape Status : 77% complete
  Delta Devices : 2, (8->10)

           Name : localhost.localdomain:4
           UUID : 359d41dc:a2e506e3:5e802a49:a84ef89c
         Events : 3957775

    Number   Major   Minor   RaidDevice State
       0       8       68        0      active sync   /dev/sde4
       1       8       84        1      active sync   /dev/sdf4
       2       8      116        2      active sync   /dev/sdh4
       9       8      180        3      active sync   /dev/sdl4
      10       8      100        4      faulty   /dev/sdg4
      13       8       52        4      spare rebuilding   /dev/sdd4
      11       8      164        5      active sync   /dev/sdk4
       8       8      132        6      active sync   /dev/sdi4
       7       8      148        7      active sync   /dev/sdj4
      12       8       20        8      active sync   /dev/sdb4
      18       0        0       18      removed

Relevant dmesg output:

[128702.154193] md: super_written gets error=-5
[128702.154197] md/raid:md4: Disk failure on sdg4, disabling device.
                md/raid:md4: Operation continuing on 9 devices.
[128702.154205] md: super_written gets error=-5
[128702.254561] mvsas 0000:03:00.0: Phy2 : No sig fis
[128703.151620] md: md4: reshape interrupted.
[128706.343757] sas: sas_form_port: phy2 belongs to port2 already(1)!

Attempting to re-add /dev/sdg4 to the array fails on a busy device:

# mdadm --manage /dev/md4 --re-add /dev/sdg4
mdadm: Cannot open /dev/sdg4: Device or resource busy

To free up /dev/sdg4, I tried to stop the array. Not surprisingly,
this command hung as well:

# mdadm --stop /dev/md4


-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
