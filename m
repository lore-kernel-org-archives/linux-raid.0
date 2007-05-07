From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm array not found on reboot
Date: Mon, 7 May 2007 13:11:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705071310150.968@p34.internal.lan>
References: <463F5796.1060808@charter.net> <Pine.LNX.4.64.0705071258410.968@p34.internal.lan>
 <463F5CA6.6090407@charter.net> <Pine.LNX.4.64.0705071302200.968@p34.internal.lan>
 <463F5EB6.2090605@charter.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463F5EB6.2090605@charter.net>
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
>>> Justin Piszcz wrote:
>>>> 
>>>> 
>>>> On Mon, 7 May 2007, Jeffrey B. Layton wrote:
>>>> 
>>>>> Hello,
>>>>> 
>>>>> I apologize if this is a FAQ question or a typical newbie question,
>>>>> but by google efforts have yielded anything yet.
>>>>> 
>>>>> I built a RAID-1 using mdadm (Centos 4.2 with 2.6.16.19 kernel
>>>>> and mdadm 1.6.0-2). It's just two SATA drives that I created using:
>>>>> 
>>>>> mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2 
>>>>> /dev/sda1 /dev/sdb1
>>>>> 
>>>>> The md built correctly and I built an ext3 on it. I created 
>>>>> /etc/mdadm.conf
>>>>> and modified /etc/fstab to mount the device. But when I reboot, the 
>>>>> kernel
>>>>> drops into RAID repair mode because it can't seem to find /dev/md1 and
>>>>> yells about not finding any valid superblock (I can get the exact 
>>>>> message
>>>>> if needed). However I can mount /dev/sda1 with no problems.
>>>>> 
>>>>> The only way I can get md1 back is to issue the command:
>>>>> 
>>>>> mdadm -A /dev/md1 /dev/sda1 /dev/sdb1
>>>>> 
>>>>> and everything works. I want to have /dev/md1 mounted automatically
>>>>> on boot. I'm missing something simple here - how do I do this?
>>>> 
>>>> Sounds like a udev issue and/or you did not create the mdadm.conf 
>>>> properly. Show us your mdadm.conf.
>>> ARRAY /dev/md1 level=raid1 num-devices=2 
>>> UUID=e235ee6c:415f1494:23c28b59:afd20140
>>>  devices=/dev/sda1,/dev/sdb1
>>> ARRAY /dev/md0 level=raid1 num-devices=2 
>>> UUID=7121b438:7d36f9f6:8aa9c8b3:b5b0d211
>>>  devices=/dev/hdc1,/dev/hdd1
>> 
>> What distro?
> CentOS 4.2. I've been reading something about raidautorun. Would help in this 
> case?
>
> Thanks!
>
> Jeff
>
>

That is probably what you want-- also technically you don't 'need' to have 
the partitions set to 0xfd [Linux Raid Auto Detect], but that may help as 
well.

  fdisk -l /dev/sda

Disk /dev/sda: 74.3 GB, 74355769344 bytes
255 heads, 63 sectors/track, 9039 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        2090    16787893+  fd  Linux raid autodetect
/dev/sda2   *        2091        2107      136552+  fd  Linux raid autodetect
/dev/sda3            2108        9039    55681290   fd  Linux raid autodetect


Justin.
