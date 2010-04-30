From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: converting to raid - Error 2
Date: Fri, 30 Apr 2010 14:58:00 -0700
Message-ID: <4BDB5268.8050102@vorgon.com>
References: <4BDB4076.7010909@vorgon.com> <4BDB4358.80009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDB4358.80009@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 4/30/2010 1:53 PM, Doug Ledford wrote:
> On 04/30/2010 04:41 PM, Timothy D. Lenz wrote:
>> This is something I've been trying to do for some time and there are 2
>> older threads, but the last post got no responce, so starting a new
>> thread. The old ones are:
>>
>> Converting system to raid
>> Removing drives
>>
>> The computer with 2 sata drives switched over fine a long time ago, but
>> I have yet to get the one with 3 sata drives to boot with raid. Raid
>> support is built into the kernel, partitions are type fd.
>>
>> fdisk -l shows:
>> -----------------------------------------------------------------------
>> Disk /dev/hda: 40.0 GB, 40020664320 bytes
>> 255 heads, 63 sectors/track, 4865 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x6b381dfe
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/hda1   *           1        4660    37431418+  83  Linux
>> /dev/hda2            4661        4865     1646662+   5  Extended
>> /dev/hda5            4661        4865     1646631   82  Linux swap /
>> Solaris
>>
>> Disk /dev/sda: 500.1 GB, 500107862016 bytes
>> 255 heads, 63 sectors/track, 60801 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x94140963
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1   *           1        3040    24418768+  fd  Linux raid
>> autodetect
>> /dev/sda2            3041        3649     4891792+  fd  Linux raid
>> autodetect
>> /dev/sda3            3650       60801   459073440   fd  Linux raid
>> autodetect
>>
>> Disk /dev/sdb: 500.1 GB, 500107862016 bytes
>> 255 heads, 63 sectors/track, 60801 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0xf1814421
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1   *           1        3040    24418768+  fd  Linux raid
>> autodetect
>> /dev/sdb2            3041        3649     4891792+  fd  Linux raid
>> autodetect
>> /dev/sdb3            3650       60801   459073440   fd  Linux raid
>> autodetect
>>
>> Disk /dev/sdc: 500.1 GB, 500107862016 bytes
>> 255 heads, 63 sectors/track, 60801 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x371b6063
>>
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc3            3650       60801   459073440   fd  Linux raid
>> autodetect
>>
>> Disk /dev/md0: 25.0 GB, 25004736512 bytes
>> 2 heads, 4 sectors/track, 6104672 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/md0 doesn't contain a valid partition table
>>
>> Disk /dev/md2: 940.1 GB, 940182208512 bytes
>> 2 heads, 4 sectors/track, 229536672 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/md2 doesn't contain a valid partition table
>>
>> Disk /dev/md1: 5009 MB, 5009113088 bytes
>> 2 heads, 4 sectors/track, 1222928 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/md1 doesn't contain a valid partition table
>> -----------------------------------------------------------------------
>>
>> Orginaly I had made both md0 and md1 2-way mirrors with a spare. But
>> when it wouldn't boot, I was told it might be because of the spare and
>> to grow them in. That also didn't work. I change md0 and md1 to 2-way
>> mirrors, and removed the boot flag for sdc1 and zeroed superblock And I
>> corrected the mdadm.conf file to reflect the changes to md0/1. Still
>> would not boot from raid. I removed the two partitions sdc1 and sdc2
>> leaving just sdc3 which is part of md2 raid5. Also re-ran grub on md0
>> using:
>>
>>   sudo grub
>>   grub>device (hd0) /dev/sda
>>   grub>root (hd0,0)
>>   grub>setup (hd0)
>
> You can't use the setup macro (can't remember why, I just know it
> generally doesn't work) when putting grub on your raid1 array.  You need:
>
> install --stage2=/grub/stage2 /grub/stage1 (hd0) /grub/e2fs_stage1_5
> /grub/stage2 /grub/grub.conf
>
> and if that doesn't work in your particular configuration, you can add
> the d option after stage1 and before (hd0), but if you use it, then your
> boot disk must always be BIOS device 0x80, which means setting your BIOS
> to boot off of some disk other than the first disk found usually won't
> work and instead you just have to make whatever disk you want to boot
> off of the first disk found by the BIOS.  You can switch (hd0) to
> (hd0,0) if you want and if you have a normal DOS master boot record.
>
>>   grub>device (hd0) /dev/sdb
>>   grub>root (hd0,0)
>>   grub>setup (hd0)
>>
>> To copy the current boot drive hda1 over to md0, I use a GRML boot disk,
>> mount /dev/md0 to /mnt/md0 and /dev/sdd1 (/dev/hda1) to /mnt/sdd1, then do:
>>
>> rsync -caHh --progress --delete /mnt/sdd1/ /mnt/md0.
>>
>> Then I reboot normally. I have 2 copies of /boot/grub/device.map,
>> /boot/grub/menu.lst and /etc/fstab. one for normal boot and one for
>> raid. On /mnt/md0 I swap the normal boot files for the raid files by
>> adding .old to the names of normal boot and removing .raid from the raid
>> versions. Then reboot again and in cmos move the pata drive to the
>> bottom of the list so cmos tries the sata drives first. That worked for
>> the 32bit linux 2 drive system. But on this 64bit 3 drive I get:
>>
>> Grub loading stage 1.5
>> Grub loading, please wait
>> Error 2
>>
>> I can't remove the 3rd drive because it has part of md2 and I shouldn't
>> need to anyway. Copies of the above mentioned files I put at:
>> http://24.255.17.209:2400/vdr/local/raid/

grrr, used reply instead of reply all again, sorry:

I don't understand why using those commands at the grub> prompt won't 
work. It worked on the other computer. This is grub 1, not grub 2. I 
haven't updated it yet. It is using lenny. I did start the upgrade to 
grub2 on the other computer a short time ago, but haven't yet done the 
final command to finish the change. Trying to solve one thing at a time 
and right now this is the oldest. I don't recall ever doing any install 
--stage2=/grub/st.... on the other system.

Here is what I get when I do this for sda:
---------------------------------------
grub> device (hd0) /dev/sda

grub> root (hd0,0)
  Filesystem type is ext2fs, partition type 0xfd

grub> setup (hd0)
  Checking if "/boot/grub/stage1" exists... yes
  Checking if "/boot/grub/stage2" exists... yes
  Checking if "/boot/grub/e2fs_stage1_5" exists... yes
  Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are 
embedded.
succeeded
  Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p 
(hd0,0)/boot/grub/stage2 /boot/grub/menu.l
st"... succeeded
Done.
---------------------------------------
And I just noticed something.I used sda, not sda1. I can't remember 
which I did before with the other, but my notes show sda. Would that matter?

