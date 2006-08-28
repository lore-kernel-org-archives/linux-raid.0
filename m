From: Neil Brown <neilb@suse.de>
Subject: Re: Newbie: Kernel panic during RAID1 test & reboot loses one disk
Date: Mon, 28 Aug 2006 11:48:11 +1000
Message-ID: <17650.19291.747235.505927@cse.unsw.edu.au>
References: <ecqek4$tnu$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Brown on Saturday August 26
Sender: linux-raid-owner@vger.kernel.org
To: James Brown <jbrown@orange.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 26, jbrown@orange.net wrote:
> All,
> 
> I'm fairly new to Linux/Debian and have been trying to configure mdadm 
> for RAID1 with 2x120Gb IDE disks. Unfortunately, I have two problems 
> with the configuration and would really appreciate some advice.
> 
> * Problem 1: Since moving from 2.4 -> 2.6 kernel, a reboot kicks one 
> device out of the array (c.f. post by Andreas Pelzner on 24th Aug 2006).
> 
> * Problem 2: When booting my system, unless both disks plugged in, I get 
> a kernel panic (oh dear!):
> 
>  > mdadm md0 stopped
>  > mdadm cannot open device /dev/hda6 no such device or address
>  > mdadm /dev/hda6 has wrong uuid
>  > mdadm no devices found for /dev/md0
>  > ext3fs unable to read superblock
>  > ecit 2 - unable to read superblock cramfs
>  > kernel panic attempting to kill init

At a guess, I'd say something is wrong with your initramfs/initrd.
Can you look inside it and see what /etc/mdadm/mdadm.conf contains?

> * mdadm Config:
> # cat /etc/mdadm/mdadm.conf
> DEVICE partitions
> ARRAY /dev/md1 level=raid1 num-devices=2 
> UUID=cc518d12:0e602331:8715a849:6dac0873
>     devices=/dev/hda7,/dev/hdc7
> ARRAY /dev/md0 level=raid1 num-devices=2 
> UUID=07c5cab1:1b86a5ca:f4599353:4ccfc5c1
>     devices=/dev/hda6,/dev/hdc6

You don't want the 'devices=' lines, but they shouldn't be causing a
problem in this context.

> * System md logs don't mention hdc6
> # grep md /var/log/messages

 grep -C 5 md /var/log/messages
might be better as it gives a bit more context.l

But I'm betting on the initramfs being a problem.

NeilBrown
