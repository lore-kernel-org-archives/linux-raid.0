From: Jeff Allison <jeff.allison@allygray.2y.net>
Subject: Re: raid resync speed
Date: Fri, 21 Mar 2014 11:44:24 +1100
Message-ID: <CAPrpM6x=BBXA30JEiO4Y3-JcZz2vBjM18wGuAf5HWfaAczg=tw@mail.gmail.com>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
	<532B2988.5070600@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532B2988.5070600@itwm.fraunhofer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't think it's the raid code I've dropped the disk out of the
array and I still cannot get anymore that 4MB/sec out of it...

[jeff@nas ~]$dd if=/dev/zero of=/mnt/sdj/bonnie/test.tmp bs=4k
count=2000000 && sync && dd if=/dev/zero of=/mnt/sdd/bonnie/test.tmp
bs=4k count=2000000 && sync

2000000+0 records in
2000000+0 records out
8192000000 bytes (8.2 GB) copied, 231.778 s, 35.3 MB/s <-- WD Green
RMA I got back yesterday.

2000000+0 records in
2000000+0 records out
8192000000 bytes (8.2 GB) copied, 1818.18 s, 4.5 MB/s <-- Dud one.

Perhaps it's time to RMA the RMA.

On 21 March 2014 04:46, Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:
> On 03/20/2014 02:12 AM, Jeff Allison wrote:
>>
>> The gist of my question is what kind of resync speed should I expect?
>>
>> I have a HP N54L Microserver running centos 6.5.
>>
>> In this box I have a 3x2TB disk raid 5 array, which I am in the
>> process of extending to a 4x2TB raid 5 array.
>>
>> I've added the new disk --> mdadm --add /dev/md0 /dev/sdb
>>
>> And grown the array --> mdadm --grow /dev/md0 --raid-devices=4
>>
>> Now the problem the resync speed is v slow, it refuses to rise above
>> 5MB, in general it sits at 4M.
>
>
> Per second?
>
>
>>
>> from looking at glances it would appear that writing to the new disk
>> is the bottle neck, /dev/sdb is the new disk.
>>
>> Disk I/O In/s Out/s
>> md0 0 0
>> sda1 0 0
>> sda2 0 1K
>> sdb1 3.92M 0
>> sdc1 24.2M 54.7M
>> sdd1 11.2M 54.7M
>> sde1 16.3M 54.7M
>
>
> Could you please send output of 'iostat -xm 1'? Also, do you anything in
> 'top' that takes 100% CPU?
>
> Thanks,
> Bernd
>
>
