From: Federico Foschini <undicizeri@gmail.com>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sat, 8 Mar 2014 13:08:50 +0100
Message-ID: <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
 <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com>
 <531B0229.7030800@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531B0229.7030800@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think ubuntu kernel has mdadm in itself, but I'm not sure. How can I
check? Remember also my boot disc is sdc and it's not part of any raid

Anyway in addition to my configuration I've posted in my first mail
this is my fstab and mdadm.conf:
# /etc/fstab: static file system information.
#
# Use 'blkid -o value -s UUID' to print the universally unique identifier
# for a device; this may be used with UUID= as a more robust way to name
# devices that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    nodev,noexec,nosuid 0       0
# / was on /dev/sdc5 during installation
UUID=a53356cf-05a3-42d8-a2ec-8a7fd4702e30 /               ext4
errors=remount-ro 0       1
# swap was on /dev/sdc1 during installation
UUID=df505cf8-aac8-42d6-805a-908d5909f8d5 none            swap    sw
           0       0
/dev/md1 /media/dischi  ext4 defaults 0 1

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

ARRAY /dev/md0 metadata=1.2 name=petra:0
UUID=952ad074:4039f24a:2ec1808e:d555a88c
ARRAY /dev/md1 metadata=1.2 name=petra:md1
UUID=03c85017:15cecfb6:13d059bc:a8ff8779

Thank you for your help!

2014-03-08 12:42 GMT+01:00 Rudy Zijlstra <rudy@grumpydevil.homelinux.org>:
> On 08-03-14 12:16, Federico Foschini wrote:
>>
>> The old system had only sda and sdb in raid1. Now I've made a linear
>> array with sda and sdb and created a new raid1 array with sdd.
>>
>>>> Is there something wrong with my setup?
>>>
>>> Do you have any reason to think so?
>>
>> Yes, because yesterday I've update the kernel and grub complained
>> about "raid array -1 not found".
>> Also why sda and sdb have both a partition defined as "linux raid" but
>> sdd doesn't? Where is the correct way to create an array? If I
>> remember correctly these are the steps I did:
>>
>> 0) The system was /dev/sda1 /dev/sdb1 in raid1 (dev/md0) with a LVM
>> partition on top of the raid
>> 1) I created a new degradeted raid 1 /dev/md1 array with /dev/sdd
>> (without defining any partition)
>> 2) I've mounted /dev/md1 and formatted as ext4. Then I copied
>> everything from /dev/md0
>> 3) I destroyed the old /dev/md0 and than recreated a new /dev/md0 as a
>> linear array
>> 4) I've added /dev/md0 on /dev/md1 and the drivers start syncying
>>
>> Than I've update the kernel and grub complained about "raid array -1".
>> When I restarted the system a Grub error 17 was showed.
>> So I booted from an usb key and restored grub (I think I installed it
>> wrongly on /dev/sda instead of the correct drive /dev/sdc) and the
>> system booted correctly.
>>
> one more question before i give my best guess
>
> Do you use a initrd to load modules during boot, or do does your kernel
> contain all drivers in itself?
>
> Cheers
>
>
> Rudy



-- 
Federico Foschini.
