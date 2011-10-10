From: maurice <mhilarius@gmail.com>
Subject: Re: Odd booting problem
Date: Mon, 10 Oct 2011 10:02:00 -0600
Message-ID: <4E9316F8.7040800@gmail.com>
References: <4E8F8C63.1080600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E8F8C63.1080600@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

I am top and bottom posting this reply to myself, so as to satisfy the 
tastes of each camp:

I just tried using only one of the disks, and NOT as md RAID devices.
This works perfectly.
Which, at least to my eyes, implies there is some interaction with mdadm 
that is causing the
failure of dracut and of booting.

Is there anyone here interested in helping me with this?




>
> An odd problem, and hopefully someone reading this can tell me what to 
> do differently:
>
> I am converting a machine from a single disk to one with 2 disks and 4 
> md RAIDs.
>
> I do not know how much detail people might like, so I will keep it as 
> terse as possible to start:
> Original install CentOS 6.0, with all updates.
> XC86_64 kernel
>
> mdadm v3.2.2
>
> I have added the second physical disk, and duplicated the partition 
> table from the existing system disk
> created 4 md RAID1s, to be used for /boot, /, /var, and /home
> All were created with the second part missing:
> mdadm --create /dev/md0 --metadata=0.90 --level=1 --raid-disks=2 
> /dev/sda1 missing
> mdadm --create /dev/md1 --level=1 --raid-disks=2 /dev/sda2 missing
> mdadm --create /dev/md2 --level=1 --raid-disks=2 /dev/sda5 missing
> mdadm --create /dev/md3 --level=1 --raid-disks=2 /dev/sda6 missing
>
> System is booting on GRUB 0.97.
> Therefore I made the md0 ( /boot) with 0.90
> And then made md1, md2 and md3 with 1.2
>
> Everything looks good in /proc/mdstat
> I made file systems ( ext for boot and ext for others) , then copied 
> over all data from original disk.
>
> Created the mdadm.conf file:
> mdadm --detail --scan > /etc/mdadm.conf
>
> I used dracut to rebuild the initramfs with the new mdadm.conf:
>
> dracut --mdadmconf --force /boot/initramfs-$(uname -r).img $(uname -r)
> This completed uneventfully.
>
> Edited /etc/fstab and rebooted.
> Now I have all my filesystems on the md devices with no complaints.
>
> Ran grub and installed on the new disk :
> root (hd0,0)
> setup (hd0)
> Completed successfully
>
> Next, rebooted again, and this time manually edited the grub command 
> line to change
> from root=/dev/sdb2  to root=/dev/md1
>
> And here it gets funny:
>
> Boots a bit, then I see:
>
> dracut Warning: No root device "block: /dev/md1" found.
>
> And a few seconds later we get a kernel panic.
>
Good morning,

I am top and bottom posting this reply to myself, so as to satisfy the 
tastes of each camp:

I just tried using only one of the disks, and NOT as md RAID devices.
This works perfectly.
Which, at least to my eyes, implies there is some interaction with mdadm 
that is causing the
failure of dracut and of booting.

Is there anyone here interested in helping me with this?


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
