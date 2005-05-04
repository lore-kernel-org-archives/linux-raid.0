From: Tyler <pml@dtbb.net>
Subject: Re: mdadm create size problem
Date: Wed, 04 May 2005 03:24:18 -0700
Message-ID: <4278A2D2.1020901@dtbb.net>
References: <4277825A.1070405@cc.kuleuven.be> <42789B24.6040206@cc.kuleuven.be> <4278A023.3040004@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4278A023.3040004@cc.kuleuven.be>
Sender: linux-raid-owner@vger.kernel.org
To: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What version were you trying?  1.9.0 and 1.11.0 are considered the 
latest stable versions i believe.

Regards,
Tyler.

Herta Van den Eynde wrote:

> FWIIW, I reverted to mdadm-1.4.0-1, and that version creates the 
> RAID1+0 just fine.
>
> Herta
>
> Herta Van den Eynde wrote:
>
>> OK, there's definitely something wrong here.  I ran a
>> # mdadm --zero-superblock --force /dev/sdX
>> followed by
>> # dd if=/dev/zero of=/dev/sdX bs=64k
>> where X=[g-in-p], and when I try to create a RAID 1 using two of these
>> devices, it still sets the size to 139904K.  When I create a RAID 0
>> using the same devices, mdadm does set the size correctly.
>>
>> # mdadm --create --verbose /dev/md6 --level=1 --raid-devices=2 /dev/sdh
>> /dev/sdo
>> mdadm: size set to 139904K
>> mdadm: array /dev/md6 started.
>>
>> # mdadm --create --verbose /dev/md6 --level=0 --raid-devices=2 /dev/sdh
>> /dev/sdo
>> mdadm: chunk size defaults to 64K
>> mdadm: array /dev/md6 started.
>> # mke2fs -j -v  /dev/md6
>> (...)
>> # mount /dev/md6 /mnt; df /mnt
>> Filesystem           1k-blocks      Used Available Use% Mounted on
>> /dev/md6             141124600     32828 133923052   1% /mnt
>>
>> Is this a bug, or am I overlooking something?
>>
>> Herta
>>
>>
>> Herta Van den Eynde wrote:
>>
>>> Red Hat AS 2.1 mdadm 1.11
>>> I have two devices that used to be part of a now corrupt RAID10 
>>> configuration.  When I try to reuse them to create a RAID1, it only 
>>> uses about 1 third of the diskspace available.
>>> # fdisk -l /dev/sdg
>>>
>>> Disk /dev/sdg: 255 heads, 63 sectors, 8924 cylinders
>>> Units = cylinders of 16065 * 512 bytes
>>>
>>>    Device Boot    Start       End    Blocks   Id  System
>>> /dev/sdg1             1      8924  71681998+  fd  Linux raid autodetect
>>>
>>> # fdisk -l /dev/sdn
>>>
>>> Disk /dev/sdn: 255 heads, 63 sectors, 8924 cylinders
>>> Units = cylinders of 16065 * 512 bytes
>>>
>>>    Device Boot    Start       End    Blocks   Id  System
>>> /dev/sdn1             1      8924  71681998+  fd  Linux raid autodetect
>>>
>>> # mdadm --create --verbose /dev/md5 --level=1 --raid-devices=2 
>>> /dev/sdg /dev/sdn
>>> mdadm: /dev/sdg appears to contain an ext2fs file system
>>>     size=419520K  mtime=Mon May  2 17:04:04 2005
>>> mdadm: /dev/sdn appears to contain an ext2fs file system
>>>     size=419520K  mtime=Mon May  2 17:04:04 2005
>>> mdadm: size set to 139904K
>>> Continue creating array? n
>>>
>>> If I try to add the --size option, even a size that is 139904K or 
>>> less, it tells me the size is invalid:
>>>
>>> # mdadm --create --verbose /dev/md5 --level=1 --raid-devices=2 
>>> /dev/sdg /dev/sdn --size=139904K
>>> mdadm: invalid size: 139904K
>>>
>>> I did reboot the system after fdisk'ing the devices.
>>>
>>> Do I need to low-level format these devices to be able to reuse them?
>>>
>>> Kind regards,
>>>
>>> Herta
>>
