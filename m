From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Need to shrink md component disk partitions - what is the best
 method?
Date: Mon, 10 Jul 2017 23:56:07 -0500
Message-ID: <2f8f0538-2a5f-a01a-616f-34b98cc7d67e@gmail.com>
References: <317ec719-0979-e1ae-b6ad-7192ef074ac4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <317ec719-0979-e1ae-b6ad-7192ef074ac4@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/10/2017 09:27 PM, Ram Ramesh wrote:
> I shrunk md device to suit my needs and now I need to shrink the 
> partition of each component device so that I can reuse the unused 
> space on the component disks. Every google search that I encountered 
> only outlines a method where you fail, remove, re-partition, add, sync 
> each disk. With bitmap, I guess each sync will be very fast as data is 
> really not being changed. Since I have raid6, I should be able to work 
> on one disk at a time without much risk also.
>
> However, is this the recommended method? Why not simply boot on a 
> rescue system, do not assemble the array, simply change all partitions 
> and reboot the original system so that the array will get assembled 
> the normal way? Is this too risky or inferior?
>
> While we are at it, mdadm -E says
>>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
> What is Used Dev Size? Is is the last sector used or the number of 
> sectors used? If my current partition(s) start at 2048, does it mean I 
> should end the md partitions on or after 6174015488 or (6174015488+2048)?
>
> How do I make mdadm scrub the entire array even though bit map says 
> there is no need?
>
> Ramesh
>
My attempt to remove a drive repartition and readd did not work. mdadm 
refused to readd the device. Any one know why? This is what I did.

sudo mdadm /dev/md0 --fail /dev/sdb1
sudo mdadm /dev/md0 --remove /dev/sdb1
sudo gdisk /dev/sdb
< shrunk the partition size so that /dev/sdb1 is  2048 - 6442452991 and 
created /dev/sdb2 6442452992-11721045134>

    New partition table:
    Number  Start (sector)    End (sector)  Size       Code  Name
        1            2048      6442452991   3.0 TiB     FD00  Linux RAID
        2      6442452992     11721045134   2.5 TiB     FD00  Linux RAID

sudo mdadm /dev/md0 --re-add /dev/sdb1
***mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible***

Why? I have enabled bit maps and /proc/mdstat shows that.

Any way, I simply added the drive and it is rebuilding. I thought I knew 
what will happen. You live and learn.

Now I am happy that I did not redo the partition on more than one drive. 
I will wait for expert advice before proceeding.

Ramesh


