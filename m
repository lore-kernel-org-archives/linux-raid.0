From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: re mdadm  raid1 creation problems
Date: Sun, 13 Jun 2004 20:15:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16588.10577.168302.64598@cse.unsw.edu.au>
References: <40CAD765.7040307@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rrk on Saturday June 12
To: rrk <rrk@prairie.lakes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 12, rrk@prairie.lakes.com wrote:
> sorry my reply's are not making it to the list
> 
> the error msg i get is
> 
> /dev/md1 file system size ( according to the superblock) is 2560351
> the pyhical size of the device is 2560320 either the superblock or
> the partion table is corrupt
> 
> /dev/md1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY
> 
> i get this msg on the first boot with md1 as the primary boot
> partion

2560351 is the size of /dev/hda1 - in separate my to me you included:

> fdisk info
> 255 heads 63 sectors 14589 cyl
> units = cyl of 16065 * 512  = 8225280
> dev       bootable   start   end    blocks   type
> /dev/hda1    *         1    1275   10241406   fd
> 
> the partion tables are an exact match between hda and hdc

fsck reports 4k blocks, fdisk reports 1k blocks, and
   2560351 * 4 == 10241406

So it would appear that you did a "mkfs" on /dev/hda1 (or /dev/hdc1)
rather than on /dev/md1.  This is the source of your problem.
If /dev/md0 is created from /dev/hda1 and /dev/hdc1, then /dev/md1
will be slightly smaller that either /dev/hda1 or /dev/hdc1 (between
64 and 128 K smaller.  124K in your case).

> 
> i thought i was being pretty careful about rebooting after all partion 
> changes
> 
> the build order/process is
> 
> build and test hda  debian 2.4.26 with raid compiled in
> sfdisk to transfer partions   sfdisk -d /dev/hda | sfdisk /dev/hdc
> set hdc partion type  to fd
> reboot
> mk file system on hdc and copy hda to hdc

This was the wrong thing to do.
You should:
   create /dev/md1 at this point using exactly the command that you
    mention below,
   mkfs /dev/md1
   mount /dev/md1 /mnt/somewhere
   cp -ax / /mnt/somewhere

as md1 will be slightly smaller than hd1, you need to copy the
filesystem with 'cp' or similar, you cannot just 'dd' the whole
partition.

The rest should then work.

NeilBrown


> reboot
> test hdc as primary boot
> reboot
> create md1   mdadm --create /dev/md1 --level=1 --raid-devices=2 missing 
> /dev/hdc1
> there are 3 md devices / home & var
> reboot
> mount md device for test
> change hda partion type to fd
> reboot
> edit fstab and grub on md devices
> shutdown
> boot from mepis rescue disk
> mdadm --add /dev/md1 /dev/hda1
> wait for resync
> shutdown
> reboot from md1
> 
> thanks
> rob
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
