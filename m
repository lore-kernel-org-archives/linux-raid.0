From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Creating an md with 3TB drives.
Date: Wed, 28 Sep 2011 10:31:57 +0200
Message-ID: <4E82DB7D.4050104@yazzy.org>
References: <4E82D53F.3050409@yazzy.org> <20110928182302.39cfd4b0@notabene.brown>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110928182302.39cfd4b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/28/11 10:23 AM, NeilBrown wrote:
[...]

>>
>> Then I used fdisk to change the partition type to Linux raid auto
>
> You can do that if you like but it will have no effect.  The "raid auto"
> partition type only means anything on MBR partitions.  You don't need to, so
> don't bother.

Thanks Neil.
Not using fdisk worked like a charm.

# mdadm -QD /dev/md2
mdadm: bad uuid: UUID=aaa23fb6:a7bce189:b5293030:df5c4a2
/dev/md2:
         Version : 1.2
   Creation Time : Wed Sep 28 10:27:31 2011
      Raid Level : raid0
      Array Size : 5860530176 (5589.04 GiB 6001.18 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Wed Sep 28 10:27:31 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 512K

            Name : odin:2  (local to host odin)
            UUID : 5577bbc0:8ec6a7ff:07aff1ed:5610061c
          Events : 0

     Number   Major   Minor   RaidDevice State
        0       8       49        0      active sync   /dev/sdd1
        1       8       65        1      active sync   /dev/sde1



-- 

Marcin M. Jessa
