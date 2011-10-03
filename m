From: Dominique <dcouot@hotmail.com>
Subject: Re: mdadm - level change from raid 1 to raid 5
Date: Mon, 3 Oct 2011 12:52:37 +0200
Message-ID: <BLU0-SMTP2333DCB3FF0B31A1F4A3D99C9FA0@phx.gbl>
References: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl>	<20111001080250.65dc83bd@notabene.brown>	<BLU0-SMTP1299BD19297F8D4A02E6D13C9F50@phx.gbl>	<20111003075041.188ff3ff@notabene.brown>	<BLU0-SMTP22900A6C32A672C1C40BF7CC9FA0@phx.gbl> <20111003210744.45e637d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003210744.45e637d7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well,...
I thought I was not that stupid.
But it seems I need more explanation/help. I just tried to change the 
chunk size, but I got the weirdest answer of all:"mdadm: component size 
18919352 is not a multiple of chunksize 32k".
18919352 is indeed not a multiple of 32 or any other multiple of 8 for 
that matter (up to 1024, after that I gave up). So what did I do wrong 
in my setup.

To be clear is what I did this morning:
1. Setup a new VM with 5HDD (20G each) under Ubuntu 11.10 server
2. Setup a RAID1 with 2 HDD (3 spares) md0 2GB (swap), md1 100 MB 
(boot), md2 the rest (root)
3. Convert md2 from RAID1 to Raid5
mdadm --grow /dev/md2 --level=5
4. Copied the content of sda to sdc, sdd and sde by doing
sfdisk -d /dev/sda | sfdisk /dev/sdc --force (and so on for sdd and sde)
5. Then added and extended the various arrays
mdadm --add /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm --add /dev/md1 /dev/sdc2 /dev/sdd2 /dev/sde2
mdadm --add /dev/md2 /dev/sdc3 /dev/sdd3 /dev/sde3
mdadm --grow /dev/md0 --raid-devices=5
mdadm --grow /dev/md1 --raid-devices=5
mdadm --grow /dev/md2 --raid-devices=5
on that last one, I got "mdadm: Need to backup 32K of critical section.."
but a cat /proc/mdstat showed all arrays being reshaped without problems.
At the end, a simple reboot and all was in order.
So any idea where I went wrong ?

Dom


On 03/10/2011 12:07, NeilBrown wrote:

> On Mon, 3 Oct 2011 10:53:50 +0200 Dominique<dcouot@hotmail.com>  wrote:
>
>> Hi Neil,
>>
>> Followed your advice an tried a few things... RAID5 with 2HDD, seems to
>> work well. After growing all arrays, I've got my 3 arrays working (2
>> RAID1 and 1 RAID5), and I can boot. But I have one last question since
>> the raid.wiki.kernel.org server seems to be down.
>> What about chunk size. I let it go with default values - 8k (for not
>> setting it before the --grow command). What is the optimal size...Is
>> there a nice math formula to define its optimal size ? And can it be
>> changed once the array is build ?
> The default for chunksize should be 512K I thought..
> I once saw a mathematical formula, but it was a function of the number of
> concurrent accesses and the average IO size - I think.
>
> Big is good for large streaming requests.  Smaller is good for lots of random
> IO.  Only way to know for sure is to measure your workload on different sizes.
>
> You can change it once the array is build, but it is a very slow operation as
> it has to move every block on every disk to somewhere else.
>
>   mdadm -G /dev/md2 --chunk=32
>
> NeilBrown
>
>
>
>> Thanks,
>>
>> Dom
>>
>> On 02/10/2011 22:50, NeilBrown wrote:
>>> On Sun, 2 Oct 2011 16:24:48 +0200 Dominique<dcouot@hotmail.com>   wrote:
>>>
>>>> Hi Neil,
>>>>
>>>> Thanks for the Info, I'll try a new series of VM tomorrow.
>>>>
>>>> I do have a question though. I thought that RAID5 required 3 HDD not 2.
>>>> Hence I am a bit puzzled by your last comment....
>>>> "Nope. This is because md won't change a 5-device RAID1 to RAID5. It
>>>> will only change a 2-device RAID1 to RAID5. This is trivial to do
>>>> because a 2-device RAID1 and a 2-device RAID5 have data in exactly the
>>>> same places. " Or do I grow to a 3HDD RAID5 config with a 'missing' HDD.
>>> It is a common misunderstanding that RAID5 requires 3 drives, not 2.
>>> 2 is a perfectly good number of drives for RAID5.  On each stripe, on drive
>>> holds the data, and the other drive holds the 'xor' of all the data blocks
>>> with zero which results in exactly the data ( 0 xor D == D).
>>> So a 2-drive RAID5 is nearly identical to a 2-drive RAID1, thus it is seen as
>>> pointless and not considered to be a RAID5  (just as a triangle is not
>>> considered to be a real quadrilateral, just because one of the 4 sides is of
>>> length '0'!).
>>> Some RAID5 implementations rule out 2-drive RAID5 for just this reason.
>>> However 'md' is not so small-minded.
>>> 2-drive RAID5s are great for testing ... I used to have graphs showing
>>> throughput for 2,3,4,5,6,7,8 drives - the '2' made a nice addition.
>>> And 2-drive RAID5s are very useful for converting RAID1 to RAID5.  First
>>> convert a 2-drive RAID1 to a 2-drive RAID5, then change the number of drives
>>> in the RAID5.
>>>
>>>
>>> RAID6 should really work with only 3 drives, but md is not so enlightened.
>>> When hpa wrote the code he set the lower limit to 4 drives.  I would like to
>>> make it 3, but I would have to check that 3 really does work and I haven't
>>> done that yet.
>>>
>>>
>>>> I understand the 2HDD to 5HDD growth, but not how to make the other one.
>>>> Since I cant test it right know, I'll both tomorrow.
>>> You really don't need too think to much - just do it.
>>> You have a 2 drive RAID1.  You want to make a 5 drive RAID5, simply add 3
>>> drives with
>>>      mdadm /dev/md2 --add /dev/first /dev/second /dev/third
>>>
>>> then ask mdadm to change it for you:
>>>      mdadm --grow /dev/md2 --level=5 --raid-disks=5
>>>
>>> and mdadm will do the right thing.
>>> (Not that I want to discourage you from thinking, but sometimes experimenting
>>> is about trying this that you don't think should work..)
>>>
>>> NeilBrown
>>>
>>>> Dom
>>>>
>>>>
>>>> On 01/10/2011 00:02, NeilBrown wrote:
>>>>> On Fri, 30 Sep 2011 20:31:37 +0200 Dominique<dcouot@hotmail.com>    wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Using Ubuntu 11.10 server , I am testing RAID level changes through
>>>>>> MDADM. The objective is to migrate RAID 1 (1+ HDD) environment to RAID 5
>>>>>> (3+ HDD) without data loss.
>>>>>> In order to make as simple as possible, I started in a VM environment
>>>>>> (Virtual Box).
>>>>> Very sensible!!
>>>>>
>>>>>
>>>>>> Initial Setup:
>>>>>> U11.10 + 2 HDD (20GB) in Raid 1 ->    no problem
>>>>>> The setup is made with 3 RAID 1 partition on each disk (swap (2GB), boot
>>>>>> (500MB), and root (17,5GB)). I understand that this will allow to
>>>>>> eventually grow to a RAID 5 configuration (in Ubuntu) and maintain boot
>>>>>> on a RAID construct (swap and boot would remain on RAID 1, while root
>>>>>> would migrate to RAID 5).
>>>>>>
>>>>>> Increment number of disks:
>>>>>> add 3 HDD to the setup ->    no problem
>>>>>> increase the RAID 1 from 2 HDD to 5 HDD ->    no problem, all disks added
>>>>>> and synchronized
>>>>> This is the bit you don't want.  Skip that step and it should work.
>>>>>
>>>>>
>>>>>> root@ubuntu:~# cat /proc/mdstat
>>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>>>>>> [raid4] [raid10]
>>>>>> md2 : active raid1 sda3[0] sde3[4] sdb3[1] sdc3[2] sdd3[3]
>>>>>>           18528184 blocks super 1.2 [5/5] [UUUUU]
>>>>>>
>>>>>> md1 : active raid1 sda2[0] sde2[4] sdb2[1] sdd2[3] sdc2[2]
>>>>>>           488436 blocks super 1.2 [5/5] [UUUUU]
>>>>>>
>>>>>> md0 : active raid1 sdb1[1] sde1[4] sda1[0] sdc1[2] sdd1[3]
>>>>>>           1950708 blocks super 1.2 [5/5] [UUUUU]
>>>>>>
>>>>>>
>>>>>> Change Level:
>>>>>> That's where the problem occurs:
>>>>>> I initially tried 3 different approaches for md2 (the root partition)
>>>>>>
>>>>>>         1. Normal boot
>>>>>>
>>>>>>         mdadm /dev/md2 --grow --level=5
>>>>>>
>>>>>>         Not working: 'Could not set level to raid 5'. I suppose this is
>>>>>> because the partition is in use. Makes sense.
>>>>> Nope.  This is because md won't change a 5-device RAID1 to RAID5.  It will
>>>>> only change a 2-device RAID1 to RAID5.  This is trivial to do because a
>>>>> 2-device RAID1 and a 2-device RAID5 have data in exactly the same places.
>>>>> Then you can change your 2-device RAID5 to a 5-device RAID5 - which takes a
>>>>> while but this can all be done while the partition is in use.
>>>>>
>>>>> i.e. if you start with a RAID1 with 2 active devices and 3 spares and issue
>>>>> the command
>>>>>        mdadm /dev/md2 --grow --level=5 --raid-disks=5
>>>>>
>>>>> it will convert to RAID5 and then start reshaping out to include all 5 disks.
>>>>>
>>>>>
>>>>> NeilBrown
