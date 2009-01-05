From: "hank peng" <pengxihan@gmail.com>
Subject: Re: Are there some alignment settings when creating filesystem on RAID5 array which can improve performance?
Date: Mon, 5 Jan 2009 19:44:51 +0800
Message-ID: <389deec70901050344t3216690i9ecd1350bbf016b4@mail.gmail.com>
References: <389deec70901041707l1613a8e8jb6a6a3fbba57ea91@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97C0337C80B@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C0337C80B@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/1/5 David Lethe <david@santools.com>:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of hank peng
>> Sent: Sunday, January 04, 2009 7:08 PM
>> To: linux-raid
>> Subject: Are there some alignment settings when creating filesystem on
>> RAID5 array which can improve performance?
>>
>> Hi, everybody:
>> I have a machine and centos 5.2 installed on it. I have created a
>> RAID5 array with five SATA disks, then I create LVM on this array.
>> #pvcreate /dev/md0
>> #vgcreate myvg /dev/md0
>> #lvcreate -n mylv myvg
>> As you see, I want to use XFS or ReiserFS on "mylv" volume. I wonder
>> if there are some alignment settings when creating such file systems
>> so that a better R/W performance can be achieved. Thx in advance.
>>
>>
>> --
>> The simplest is not all best but the best is surely the simplest!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Yes, but be specific.  How do you use the volume?   Do you want to optimize for IOPs or
> raw file transfer?  What is mix of random vs sequential for both reads and writes.
> What is block/chunk size of volume, raidset, filesystem?  Reveal your
> journaling settings.  What are you getting now, and how did you measure it?   Are things
> like NCQ/TCQ/read-write cache enabled or disabled?
>
> How are the disks physically attached?  PCI(-X) or PCIe, how many channels  are you using, or are
> the disks attached via USB ports.
>
I am new to this area, so I'm not quite familiar with some words what
you mentioned.
The machine has a SATA controller (chip is Marvell 6081) attached on
PCI-X bus. Five SATA II disks are attached to it.
Each disk has 500G space.
The following is my procedure:
#mdadm -C /dev/md0 -l5 -n5 /dev/sd{a,b,c,d,e}
After recovery is done, I do this:
#pvcreate /dev/md0
#vgcreate myvg /dev/md0
#lvcreate -n mylv -L 1000G myvg
#mkfs.xfs /dev/myvg/mylv  or  #mkfs.reiserfs /dev/myvg/mylv
mount this file system and begin to use it.
I mainly want to optimise its sequential write performace, IOPs is not
my concern.
SATA driver is provided by marvell, so NCQ/TCQ/read-write is default.


> Need more info.
>
>
>



-- 
The simplest is not all best but the best is surely the simplest!
