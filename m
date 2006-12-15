From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID1 root and swap and initrd
Date: Fri, 15 Dec 2006 19:14:14 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net>
References: <20061215175630.GA11400@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061215175630.GA11400@aym.net2.nerim.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Dec 2006, Andre Majorel wrote:

> Pardon the probably silly question but...
>
> Can you use RAID1 devices for your root and swap with a "straight"
> kernel ? (i.e. without the need for initrd/initramfs.)

Yes - but you need the md (and ide/scsi/sata) drivers compiled into your 
kernel, and make sure the parition types are 0xFD and trust the kernel 
auto-detection.

This is how I do it on all my servers. No initrd etc. (apart from the ones 
that boot off flash, but thats another story!)


% cat /proc/mdstat
Personalities : [raid0] [raid1]
md1 : active raid1 hdc1[1] hda1[0]
        248896 blocks [2/2] [UU]

md2 : active raid1 hdc2[1] hda2[0]
        995904 blocks [2/2] [UU]

md3 : active raid1 hdc3[1] hda3[0]
        2000000 blocks [2/2] [UU]

md5 : active raid1 hdc5[1] hda5[0]
        7815488 blocks [2/2] [UU]

md6 : active raid1 hdc6[1] hda6[0]
        68974976 blocks [2/2] [UU]

unused devices: <none>

% lsmod
Module                  Size  Used by

% cat /etc/fstab

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0

/dev/md1        /               ext3    defaults,errors=remount-ro 0       1
/dev/md2        none            swap    sw                      0       0
/dev/md3        /usr            ext3    defaults                0       2
/dev/md5        /var            ext3    defaults                0       2
/dev/md6        /home           ext3    defaults                0       2


> If that matters, the boot manager would be LILO and each MD device
> would be assembled from "parallel" logical partitions.

Lilo is fine. Even kernel auto-detection is fine for me. A nice little tip 
I learned from someone else on the list is to have your md 
devices named after the partition numbers. So:

md1 is /dev/hda1 and /dev/hdc1
md2 is /dev/hda2 and /dev/hdc2

etc.

Gordon
