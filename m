From: Sam Bingner <sam@bingner.com>
Subject: Re: Reshape Shrink Hung Again
Date: Wed, 1 May 2013 02:00:30 +0000
Message-ID: <7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
 <20130422072414.3e30882c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422072414.3e30882c@notabene.brown>
Content-Language: en-US
Content-ID: <35E223D058FBC84288079936E3C067D8@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 21, 2013, at 11:24 AM, NeilBrown <neilb@suse.de> wrote:

> On Fri, 19 Apr 2013 08:29:37 +0000 Sam Bingner <sam@bingner.com> wrote:
> 
>> I'll start this off by saying that no data is in jeopardy, but I would like to track down the cause of this problem and fix it.  I originally thought it must have been due to the incorrect backup-file size with a raid array shrunk to smaller than the final size when it happened to me last time but this time this was not the case.
>> 
>> I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this shrink had no problems except that a drive failed right at the end of the reshape... then it hung at 99.9% and does not allow me to remove the failed drive from the array because it is "rebuilding".  I am not sure if the drive failed at the end, or if it was after it had gotten to 99.9% because I didn't see this until the next morning as it ran overnight.
>> 
>> Sam
>> 
>> root@fs:/var/log# uname -a
>> Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/Linux
>> 
>> Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity change from 749122093056 to 499414728704
>> Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID array md1
>> Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>> Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, over a total of 243854848 blocks.
>> Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on sda2, disabling device.
>> Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation continuing on 2 devices.
>> Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets error=-5, uptodate=0
>> Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
>> Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID array md1
>> Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed_  speed: 100 KB/sec/disk.
>> Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>> Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, over a total of 243854848 blocks.
>> 
>> 
>> md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
>>      487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
>>      [===================>.]  reshape = 99.9% (243853824/243854848) finish=343.6min speed=0K/sec
>> 
> 
> Looks like a bug - probably in mdadm.
> mdadm needs to help the reshape over the last little bit, and md is probably
> waiting for it to do that.  This will be the only time in the whole process
> when the backup file is used.
> 
> I would try stopping the array and re-assembling it.  That might require a
> reboot.  If that doesn't fix it, let me know and I'll prioritise this.
> Otherwise - I've put it on my to-do list.  I'll try to reproduce and fix it
> in due course.
> 
> Thanks for the report,
> NeilBrown

Sorry for the delay in responding, the server was at a remote location and didn't have a remote console.  My attempt to make an initrd that provided me SSH failed for unknown reasons (it works now that I've got physical access to the server).  Based on the results below, it looks like the drive that did drop out was pretty much at the very end and I really don't think it was related to the error.  I can leave the system in this state and get you access to it to see if you desire.  This system was in the process of being decommissioned and soon after the failure the replacement came in.  This same error happened to me twice, but I also did another reshape where it didn't happen.  I can play with this system and try to duplicate it again also.  As I said, I'll be happy to do anything to help
  find the source of this. 

In any case, here is what happened from initramfs:

 # /sbin/mdadm --assemble /dev/md1
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

# /sbin/mdadm --assemble /dev/md1 --backup-file=/boot/backup.md
mdadm: Failed to restore critical section for reshape, sorry.

# /sbin/mdadm -V
mdadm - v3.1.4 - 31st August 2010

I saw that the mdadm version was out of date, so I got the newest one and compiled it:

# ./mdadm.static -V
mdadm - v3.2.6 - 25th October 2012

# ./mdadm.static --assemble /dev/md1 --backup-file=/boot/backup.md
mdadm: Failed to restore critical section for reshape, sorry.

/boot # ./mdadm.static  -E  /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
           Name : fs:1
  Creation Time : Sat Feb 11 02:45:46 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 487710720 (232.56 GiB 249.71 GB)
     Array Size : 487709696 (465.12 GiB 499.41 GB)
  Used Dev Size : 487709696 (232.56 GiB 249.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bc2c6c48:d81125bf:f767cb14:14ce323e

  Reshape pos'n : 13312 (13.00 MiB 13.63 MB)
  Delta Devices : -1 (4->3)

    Update Time : Thu Apr 18 11:49:51 2013
       Checksum : ecff7119 - correct
         Events : 33742236

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/boot # ./mdadm.static  -E  /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
           Name : fs:1
  Creation Time : Sat Feb 11 02:45:46 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 487710720 (232.56 GiB 249.71 GB)
     Array Size : 487709696 (465.12 GiB 499.41 GB)
  Used Dev Size : 487709696 (232.56 GiB 249.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e2f23785:e2cc299e:d03ee428:ced00761

  Reshape pos'n : 2048
  Delta Devices : -1 (4->3)

    Update Time : Mon Apr 22 03:01:24 2013
       Checksum : 3fc5d100 - correct
         Events : 33910936

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .AAA ('A' == active, '.' == missing)
/boot # ./mdadm.static  -E  /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
           Name : fs:1
  Creation Time : Sat Feb 11 02:45:46 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 487710720 (232.56 GiB 249.71 GB)
     Array Size : 487709696 (465.12 GiB 499.41 GB)
  Used Dev Size : 487709696 (232.56 GiB 249.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f43b602c:1f8e0fe1:37778958:fff328e8

  Reshape pos'n : 2048
  Delta Devices : -1 (4->3)

    Update Time : Mon Apr 22 03:01:24 2013
       Checksum : e09a36e5 - correct
         Events : 33910936

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : .AAA ('A' == active, '.' == missing)
/boot # ./mdadm.static  -E  /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
           Name : fs:1
  Creation Time : Sat Feb 11 02:45:46 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 487710720 (232.56 GiB 249.71 GB)
     Array Size : 487709696 (465.12 GiB 499.41 GB)
  Used Dev Size : 487709696 (232.56 GiB 249.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 13cefd7d:7bb42450:c229d326:a41b9ba7

  Reshape pos'n : 2048
  Delta Devices : -1 (4->3)

    Update Time : Mon Apr 22 03:01:24 2013
       Checksum : 2f08c991 - correct
         Events : 33910936

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)
	


