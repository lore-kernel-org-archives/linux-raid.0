From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm array not found on reboot
Date: Mon, 7 May 2007 13:02:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705071302200.968@p34.internal.lan>
References: <463F5796.1060808@charter.net> <Pine.LNX.4.64.0705071258410.968@p34.internal.lan>
 <463F5CA6.6090407@charter.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463F5CA6.6090407@charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Jeffrey B. Layton" <laytonjb@charter.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 7 May 2007, Jeffrey B. Layton wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Mon, 7 May 2007, Jeffrey B. Layton wrote:
>> 
>>> Hello,
>>> 
>>> I apologize if this is a FAQ question or a typical newbie question,
>>> but by google efforts have yielded anything yet.
>>> 
>>> I built a RAID-1 using mdadm (Centos 4.2 with 2.6.16.19 kernel
>>> and mdadm 1.6.0-2). It's just two SATA drives that I created using:
>>> 
>>> mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2 /dev/sda1 
>>> /dev/sdb1
>>> 
>>> The md built correctly and I built an ext3 on it. I created 
>>> /etc/mdadm.conf
>>> and modified /etc/fstab to mount the device. But when I reboot, the kernel
>>> drops into RAID repair mode because it can't seem to find /dev/md1 and
>>> yells about not finding any valid superblock (I can get the exact message
>>> if needed). However I can mount /dev/sda1 with no problems.
>>> 
>>> The only way I can get md1 back is to issue the command:
>>> 
>>> mdadm -A /dev/md1 /dev/sda1 /dev/sdb1
>>> 
>>> and everything works. I want to have /dev/md1 mounted automatically
>>> on boot. I'm missing something simple here - how do I do this?
>>> 
>>> TIA!
>>> 
>>> Jeff
>>> 
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
>> Sounds like a udev issue and/or you did not create the mdadm.conf properly. 
>> Show us your mdadm.conf.
>> 
> ARRAY /dev/md1 level=raid1 num-devices=2 
> UUID=e235ee6c:415f1494:23c28b59:afd20140
>  devices=/dev/sda1,/dev/sdb1
> ARRAY /dev/md0 level=raid1 num-devices=2 
> UUID=7121b438:7d36f9f6:8aa9c8b3:b5b0d211
>  devices=/dev/hdc1,/dev/hdd1
>
> Thanks!
>
> Jeff
>

What distro?

Checkout my mdadm.conf and look att he auto-create devices option.

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

# definitions of existing MD arrays
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=82009f4a:35cca4ed:b9b6bb73:9360360
7
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=bb7106b3:1645d1e5:201cd0a5:395e2d2
a
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=12473837:fbc2b583:a5c8a649:8695efb
a
ARRAY /dev/md3 level=raid5 num-devices=10 
UUID=957d8b7d:c80043bc:083fb634:68e9eb
49

# This file was auto-generated on Sat, 28 Apr 2007 18:59:02 -0400
# by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $

