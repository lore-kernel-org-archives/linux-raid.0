From: Neil Brown <neilb@suse.de>
Subject: Re: Newbie: Kernel panic during RAID1 test & reboot loses one disk
Date: Mon, 4 Sep 2006 15:35:18 +1000
Message-ID: <17659.47894.664930.94286@cse.unsw.edu.au>
References: <ecqek4$tnu$1@sea.gmane.org>
	<17650.19291.747235.505927@cse.unsw.edu.au>
	<44F365D7.2020001@orange.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Brown on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: James Brown <jbrown@orange.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, jbrown@orange.net wrote:
> Neil Brown wrote:
> > On Saturday August 26, jbrown@orange.net wrote:
> >> All,
> >>
> >> [...]
> >>
> >> * Problem 1: Since moving from 2.4 -> 2.6 kernel, a reboot kicks one 
> >> device out of the array (c.f. post by Andreas Pelzner on 24th Aug 2006).
> >>
> >> * Problem 2: When booting my system, unless both disks plugged in, I get 
> >> a kernel panic (oh dear!):
> >>
> >>  > mdadm md0 stopped
> >>  > mdadm cannot open device /dev/hda6 no such device or address
> >>  > mdadm /dev/hda6 has wrong uuid
> >>  > mdadm no devices found for /dev/md0
> >>  > ext3fs unable to read superblock
> >>  > ecit 2 - unable to read superblock cramfs
> >>  > kernel panic attempting to kill init
> > 
> > At a guess, I'd say something is wrong with your initramfs/initrd.
> > Can you look inside it and see what /etc/mdadm/mdadm.conf contains?
> 
> Sure, this is the first time I've mounted an initrd, here goes:
> 
> # file /boot/initrd.img-2.6.8-3-386
> [...]Linux Compressed ROM File System data, little endian size 4333568 
> version #2 sorted_dirs CRC 0xa04ccaa3, edition 0, 2492 blocks, 312 files
> 
> # losetup /dev/loop0
> 
> # mkdir /tmp/initrdmount
> 
> # mount -t cramfs /dev/loop0 /tmp/initrdmount
> 
> # ls -al /tmp/initrdmount/etc/
> total 1.0K
> drwxr-xr-x  1 root root 64 1970-01-01 01:00 modprobe.d/
> -rw-r--r--  1 root root  0 1970-01-01 01:00 mtab
> 
> There is no mdadm/mdadm.conf! What I should do about this?

Sorry, I don't think.  You'll have to ask on some Debian list.  I
don't know the intricacies of Debian initrd.

NeilBrown

-- 
VGER BF report: U 0.5
