From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: opensuse 11.1: after growing a raid1 by one disk, no md1 on boot
Date: Mon, 12 Jan 2009 18:43:00 -0500
Message-ID: <496BD584.5060605@tmr.com>
References: <496A4085.8040904@rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496A4085.8040904@rhm.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Rieke <bernd@rhm.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bernd Rieke wrote:
> Hi all,
>
> we made the following steps:
>
> install an opensuse 11.1 as RAID1 on two scsi-disks:
>
> /dev/md0 .... swap (/dev/sda1 /dev/sdb1)
> /dev/md1 .... root (/dev/sda2 /dev/sdb2)
>
> Just the install with no modifications, nothing else!
>
> Everything works fine. We rebooted the system several times, it came up
> as expected. Then we noticed that we forgot the third disk within the
> arrays as we meant to have for more redundancy. So we made a
>
> mdadm --grow -n 3 /dev/md0
> mdadm --grow -n 3 /dev/md1
> mdadm -a /dev/md0 /dev/sdc1
> mdadm -a /dev/md1 /dev/sdc2
>
> The third disk was synced, everything fine again. But on the next reboot
> the system stopped with 'waiting for /dev/md1 to appear'.
>
> When the system is installed initially with 3 disks there are no
> problems. To produce the problem it needs only the --grow -n 3. After
> this the root-partition /dev/md1 seems to be corrupted or not known to 
> the kernel for any reasons.
>
> When we try to assemble with the rescue system it tells us that there is
> no superblock on /dev/sdx2. And when we try to mount one of the disks
> directly it tells us that the filesystem linux-raid-xxx (forgot the xxx,
> it was something like 'type', i think) is not a valid filesystem-type.
>
> What goes wrong?
>
> Kernel: 2.6.27.7-9-pae #1 SMP 2008-12-04 18:10:04 +0100

I'm guessing that this would be cured by creating a new initrd file, 
because I but the mdadm.conf file used device names instead of 
PARTITIONS and a UUID. Mind you, guessing, but look at /etc/mdadm.conf 
and see if in fact this is the case after install.

If you can get up on a recovery CD, check the mdadm.conf, fix if needed, 
run mkinitrd and reboot, assuming SuSE gave you the right tools.

If you are a wizard you can boot from a recovery CD, unpack the initrd 
file somewhere, patch the mdadm.conf, recompress, save the initrd file, 
and everything will be fine. I have done this before, so if you find 
that this is your problem and you understand the outline of steps I 
mentioned, go to it. I'm not about to try details, if I forget one you lose.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


