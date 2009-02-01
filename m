From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: some ?? re failed disk and resyncing of array
Date: Sun, 01 Feb 2009 14:41:37 -0500
Message-ID: <4985FAF1.2090208@tmr.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com> <49842A1E.1090105@dgreaves.com> <1233403388.29916.1297756217@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233403388.29916.1297756217@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: whollygoat@letterboxes.org
Cc: linux-raid@vger.kernel.org, David Greaves <david@dgreaves.com>
List-Id: linux-raid.ids

whollygoat@letterboxes.org wrote:
> On Sat, 31 Jan 2009 10:38:22 +0000, "David Greaves" <david@dgreaves.com>
> said:
>   
>> whollygoat@letterboxes.org wrote:
>>     
>>> On a boot a couple of days ago, mdadm failed a disk and
>>> started resyncing to spare (raid5, 6 drives, 5 active, 1
>>> spare).  smartctl -H <disk> returned info (can't remember
>>> the exact text) that made me suspect the drive was
>>> fine, but the data connection was bad.  Sure enough the
>>> data cable was damaged.  Replaced the cable and smartctl
>>> sees the disk just fine and reports no errors.
>>>
>>> - I'd like to readd the drive as a spare.  Is it enough
>>> to "mdadm --add /dev/hdk" or do I need to prep the drive to
>>> remove any data that said where it previously belonged
>>> in the array?
>>>       
>> That should work.
>> Any issues and you can zero the superblock (man mdadm)
>> No need to zero the disk.
>>     
>
> Would --re-add be better?
>
>   
I don't think do. And I would zero the superblock. The more detail you 
put into preventing unwanted autodetection the fewer learning 
experiences you will have.

> I've noticed something else since I made the initial post
>
> --------- begin output -------------
> fly:~# mdadm -D /dev/md0
> /dev/md0:
>         Version : 01.00.03
>   Creation Time : Sun Jan 11 21:49:36 2009
>      Raid Level : raid5
>      Array Size : 312602368 (298.12 GiB 320.10 GB)
>     Device Size : 156301184 (74.53 GiB 80.03 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Fri Jan 30 15:52:01 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : fly:FlyFileServ_md  (local to host fly)
>            UUID : 0e2b9157:a58edc1d:213a220f:68a555c9
>          Events : 16
>
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      34        1        1      active sync   /dev/hdg1
>        2      56        1        2      active sync   /dev/hdi1
>        5      89        1        3      active sync   /dev/hdo1
>        6      88        1        4      active sync   /dev/hdm1
>
>
> fly:~# mdadm -E /dev/hdo1
> /dev/hdo1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x1
>      Array UUID : 0e2b9157:a58edc1d:213a220f:68a555c9
>            Name : fly:FlyFileServ_md  (local to host fly)
>   Creation Time : Sun Jan 11 21:49:36 2009
>      Raid Level : raid5
>    Raid Devices : 5
>
>     Device Size : 234436336 (111.79 GiB 120.03 GB)
>      Array Size : 625204736 (298.12 GiB 320.10 GB)
>       Used Size : 156301184 (74.53 GiB 80.03 GB)
>    Super Offset : 234436464 sectors
>           State : clean
>     Device UUID : e072bd09:2df53d6d:d23321cc:cf2c37de
>
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Fri Jan 30 15:52:01 2009
>        Checksum : 4689ff5 - correct
>          Events : 16
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>     Array Slot : 5 (0, 1, 2, failed, failed, 3, 4)
>    Array State : uuuUu 2 failed
> --------- end output -------------
>
> Why does the "Array Slot" field show 7 slots?  And why
> does the field "Array State" show 2 failed?  There 
> ever only were 6 disks in the array.  Only one of those
> is currently missing.  mdadm -D above doesn't list any
> failed devices in the "Failed Devices" field.
>
>   
No idea, but did you explicitly remove the failed drive? Was there a 
failed drive at some time in the past?

I've never seen this, but I always remove drives, which may or may not 
be related.

> Thanks for your answers below as well.  It's kind of 
> what I was expecting.  There was a h/w problem that
> took ages to track down and I think it was reponsible
> for all the e2fs errors.
>
> WG
>
>   
>>> - When I tried to list some files on one of the filesystems
>>> on the array (the fact that it took so long to react to
>>> the ls is how I discovered the box was in the middle of
>>> rebuiling to spare)
>>>       
>> This is OK - resync involves a lot of IO and can slow things down. This
>> is tuneable.
>>
>>     
>>> it couldn't find the file (or many 
>>> others).  I thought that resyncing was supposed to be
>>> transparent, yet parts of the fs seemed to be missing.
>>> Everything was there afterwards.  Is that normal?
>>>       
>> No. This is nothing to do with normal md resyncing and certainly not
>> expected.
>>
>>     
>>> - On a subsequent boot I had to run e2fsck on the three
>>> filesystems housed on the array.  Many stray blocks, 
>>> illegal inodes, etc were found.  An artifact of the rebuild
>>> or unrelated?
>>>       
>> Well, you had a fault in your IO system there's a good chance your O
>> broke.
>>
>> Verify against a backup.
>>
>> David
>>
>>
>> -- 
>> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
>>     


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


