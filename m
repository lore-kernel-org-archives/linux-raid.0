From: rrk <rrk@prairie.lakes.com>
Subject: Re: raid1 creation problems
Date: Sat, 12 Jun 2004 04:38:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40CACF03.6070900@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 11, rrk@prairie.lakes.com wrote:

sorry i sent a relpy but never showed on the list 
so i'll try this


>> why would mdadm be creating a md device (raid1) that was larger than the 
>> partition table?
>  
>

Because the partition table hadn't  been read after it was last
changed maybe.


****
i was trying to be real carefull about rebooting after any partion changes


>> these are two identical seagate 120's --debian 2.4.26 with raid compiled in.
>> i have built the partition tables with fdisk cfdisk and parted same 
>> problem everytime . everything is fine
>> up until i boot at which time it say's the superblock is larger than the 
>> partition by about 20 or 30 blocks
>  
>

At which time *what* says that *what* superblock is larger by exactly
*how*many* blocks.

*****
i get the following error on the intial boot after adding the second drive 
and waiting for the rsync. The add and rsync was done with the drives unmounted
under a mepis resuce disk

/dev/md1 file system size (according to the superblock) is 2560351
the pyhical size of the device is 2560320 either the superblock or the partion
is corrupt

/dev/md1: unexpected inconsistency; run fsck manually
 

>> I have built several other raid1 system's  over the last year and have 
>> not seen this problem before.
>> to add the drives to the array i boot under a recuse disk and sync under 
>> the rescue disk. same mdadm
>> version as they were built with. The partition tables match in all cases 
>> -- with fdisk i kept everything on cyl
>> boundaries.
>  
>

I really think that if you want help, you need to provide better
details.  I'm guessing that this is a raid array that you are booting
off. Is that correct?

Exactly what do you do, and exactly what happens.

build process order

build hda with debian and compile new kernel with raid 2.4.26
use sfdisk -d /dev/hda |sfdisk /dev/hdc to create hdc partions
set hdc partion type to fd
reboot
mk file system for hdc copy hda to hdc
test hdc with a reboot as primary
reboot with hda as primary
mdadm --create /dev/md1 --level=1 --raid-devices=2 missing /dev/hdc1
reboot
test mount md1
unmount md1
change hda partion type to fd
shutdown 
boot mepis rescue 
mdadm --add /dev/md1 /dev/hd1
wait for rsync
shutdown 
reboot with /dev/md1 as primary boot
that when i get the error:

/dev/md1 file system size (according to the superblock) is 2560351
the pyhical size of the device is 2560320 either the superblock or the partion
is corrupt

/dev/md1: unexpected inconsistency; run fsck manually










>> 
>> where and how does mdadm check partition size?
>  
>

It uses an ioctl to ask the partition device how big it is.

NeilBrown


>> 
>

