From: rrk <rrk@prairie.lakes.com>
Subject: Re: re mdadm  raid1 creation problems
Date: Sun, 13 Jun 2004 04:26:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40CC1DAA.70808@prairie.lakes.com>
References: <40CAD765.7040307@prairie.lakes.com> <006401c4507c$f7e62b40$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006401c4507c$f7e62b40$6705a8c0@a30>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jay Strauss wrote:

>rrk,
>
>You say make filesystem on hda, do you really mean you created
>filesystems hda[123]?
>  
>
yes

>After you edited /etc/boot/grub/menu.lst did you run grub?
>  
>
no i'm wondering if that is somehow part of the problem
the error message does not match the data

/dev/md1 file system size (according to the superblock) is 2560351
the pyhical size of the device is 2560320 either the superblock or the partion 

is corrupt

note the device size 2560320  ---where did that come from ?

superblock

>dev/hda1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : cdbefbc6:eae47c90:4bc54343:35b9dfcc
> Creation Time : Fri Jun 11 06:29:17 2004
>    Raid Level : raid1
>   Device Size : 10241280 (9.77 GiB 10.49 GB)
>  Raid Devices : 2
> Total Devices : 3
>You don't need to reboot so often
>
>take a look at:
>http://marc.theaimsgroup.com/?l=linux-raid&m=108571782912454&w=2
>  
>
mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdc1[1] hda1[0]
     10241280 blocks [2/2] [UU]

mdstat and superblock both match as they should be one in the same
and when you look at the fdisk partion dump

Disk /dev/hda: 120.0 GB, 120000000000 bytes
255 heads, 63 sectors/track, 14589 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

  Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1      1275  10241406   fd  Linux raid autodetect
/dev/hda2          1276     14589 106944705    5  Extended
/dev/hda5          1276      1676   3221001   fd  Linux raid autodetect
/dev/hda6          1677      2377   5630751   fd  Linux raid autodetect
/dev/hda7          2378      2414    297171   82  Linux swap
/dev/hda8          2415     14589  97795656   fd  Linux raid autodetect

note that the partion size is larger than the superblock size by 126 blocks
so where did the 2560320 number come from in the boot error msg
the boot process is getting bad data -- how and why -- grub is the boot 
loader
so it must be involved both hardrives appear to be the same.

i read the link you sent -- it was different in some respects however 
the grub
cfg was the same as well as the fstab -- the last raid1 i built was with 
the 2.4.23
kernel  maybe that could be part of the problem

line 16 of the link

16. Reboot and check /proc/mdstat see if you are mirroring

what is the definitive answer for checking the mirroring  - - i maybe wrong
i thought if you booted off of mdx and mdstat looked good you were
mirroring

thanks
rob



>Jay
>----- Original Message ----- 
>From: "rrk" <rrk@prairie.lakes.com>
>To: <linux-raid@vger.kernel.org>
>Sent: Saturday, June 12, 2004 5:13 AM
>Subject: re mdadm raid1 creation problems
>
>
>  
>
>>sorry my reply's are not making it to the list
>>
>>the error msg i get is
>>
>>/dev/md1 file system size ( according to the superblock) is 2560351
>>the pyhical size of the device is 2560320 either the superblock or
>>the partion table is corrupt
>>
>>/dev/md1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY
>>
>>i get this msg on the first boot with md1 as the primary boot partion
>>
>>i thought i was being pretty careful about rebooting after all partion
>>changes
>>
>>the build order/process is
>>
>>build and test hda  debian 2.4.26 with raid compiled in
>>sfdisk to transfer partions   sfdisk -d /dev/hda | sfdisk /dev/hdc
>>set hdc partion type  to fd
>>reboot
>>mk file system on hdc and copy hda to hdc
>>reboot
>>test hdc as primary boot
>>reboot
>>create md1   mdadm --create /dev/md1 --level=1 --raid-devices=2 missing
>>/dev/hdc1
>>there are 3 md devices / home & var
>>reboot
>>mount md device for test
>>change hda partion type to fd
>>reboot
>>edit fstab and grub on md devices
>>shutdown
>>boot from mepis rescue disk
>>mdadm --add /dev/md1 /dev/hda1
>>wait for resync
>>shutdown
>>reboot from md1
>>
>>thanks
>>rob
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>    
>>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

