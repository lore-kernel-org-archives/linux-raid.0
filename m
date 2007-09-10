From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 09 Sep 2007 18:53:32 -0700
Message-ID: <46E4A39C.8040509@amfes.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46D49F1A.7030409@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Daniel L. Miller wrote:
>> Hi!
>>
>> I have a four-disk Raid-10 array that I created and mount with 
>> mdadm.  It seems like every re-boot, either the array is not 
>> recognized altogether, or one of the disks is not added.  Manually 
>> adding using mdadm works.
>
> What superblock version and partition type did you use? mdadm -D please.
Thanks for the reply.  I've been wondering why no one answered me - then 
discovered your answer in my mailbox!  Must have been hiding somewhere . 
. . .

Anyway -
 mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Oct  3 19:11:53 2006
     Raid Level : raid10
     Array Size : 312581632 (298.10 GiB 320.08 GB)
  Used Dev Size : 156290816 (149.05 GiB 160.04 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Sep  9 18:51:17 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2, far=1
     Chunk Size : 32K

           UUID : 9d94b17b:f5fac31a:577c252b:0d4c4b2a
         Events : 0.10811466

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd

And you didn't ask, but my mdadm.conf:
DEVICE partitions
ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a

Daniel
