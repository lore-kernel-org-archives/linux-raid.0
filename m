From: Dominique <dcouot@hotmail.com>
Subject: Re: mdadm - level change from raid 1 to raid 5
Date: Sun, 2 Oct 2011 16:24:48 +0200
Message-ID: <BLU0-SMTP1299BD19297F8D4A02E6D13C9F50@phx.gbl>
References: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl> <20111001080250.65dc83bd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111001080250.65dc83bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

Thanks for the Info, I'll try a new series of VM tomorrow.

I do have a question though. I thought that RAID5 required 3 HDD not 2. 
Hence I am a bit puzzled by your last comment....
"Nope. This is because md won't change a 5-device RAID1 to RAID5. It 
will only change a 2-device RAID1 to RAID5. This is trivial to do 
because a 2-device RAID1 and a 2-device RAID5 have data in exactly the 
same places. " Or do I grow to a 3HDD RAID5 config with a 'missing' HDD.

I understand the 2HDD to 5HDD growth, but not how to make the other one. 
Since I cant test it right know, I'll both tomorrow.

Dom


On 01/10/2011 00:02, NeilBrown wrote:
> On Fri, 30 Sep 2011 20:31:37 +0200 Dominique<dcouot@hotmail.com>  wrote:
>
>> Hi,
>>
>> Using Ubuntu 11.10 server , I am testing RAID level changes through
>> MDADM. The objective is to migrate RAID 1 (1+ HDD) environment to RAID 5
>> (3+ HDD) without data loss.
>> In order to make as simple as possible, I started in a VM environment
>> (Virtual Box).
> Very sensible!!
>
>
>> Initial Setup:
>> U11.10 + 2 HDD (20GB) in Raid 1 ->  no problem
>> The setup is made with 3 RAID 1 partition on each disk (swap (2GB), boot
>> (500MB), and root (17,5GB)). I understand that this will allow to
>> eventually grow to a RAID 5 configuration (in Ubuntu) and maintain boot
>> on a RAID construct (swap and boot would remain on RAID 1, while root
>> would migrate to RAID 5).
>>
>> Increment number of disks:
>> add 3 HDD to the setup ->  no problem
>> increase the RAID 1 from 2 HDD to 5 HDD ->  no problem, all disks added
>> and synchronized
> This is the bit you don't want.  Skip that step and it should work.
>
>
>> root@ubuntu:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md2 : active raid1 sda3[0] sde3[4] sdb3[1] sdc3[2] sdd3[3]
>>         18528184 blocks super 1.2 [5/5] [UUUUU]
>>
>> md1 : active raid1 sda2[0] sde2[4] sdb2[1] sdd2[3] sdc2[2]
>>         488436 blocks super 1.2 [5/5] [UUUUU]
>>
>> md0 : active raid1 sdb1[1] sde1[4] sda1[0] sdc1[2] sdd1[3]
>>         1950708 blocks super 1.2 [5/5] [UUUUU]
>>
>>
>> Change Level:
>> That's where the problem occurs:
>> I initially tried 3 different approaches for md2 (the root partition)
>>
>>       1. Normal boot
>>
>>       mdadm /dev/md2 --grow --level=5
>>
>>       Not working: 'Could not set level to raid 5'. I suppose this is
>> because the partition is in use. Makes sense.
> Nope.  This is because md won't change a 5-device RAID1 to RAID5.  It will
> only change a 2-device RAID1 to RAID5.  This is trivial to do because a
> 2-device RAID1 and a 2-device RAID5 have data in exactly the same places.
> Then you can change your 2-device RAID5 to a 5-device RAID5 - which takes a
> while but this can all be done while the partition is in use.
>
> i.e. if you start with a RAID1 with 2 active devices and 3 spares and issue
> the command
>      mdadm /dev/md2 --grow --level=5 --raid-disks=5
>
> it will convert to RAID5 and then start reshaping out to include all 5 disks.
>
>
> NeilBrown
