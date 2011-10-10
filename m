From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Odd booting problem
Date: Mon, 10 Oct 2011 11:19:25 -0600
Message-ID: <20111010171936.E9DF8581FD6@mail.futurelabusa.com>
References: <4E8F8C63.1080600@gmail.com>
 <4E9316F8.7040800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E9316F8.7040800@gmail.com>
References: <4E8F8C63.1080600@gmail.com>
 <4E9316F8.7040800@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice-

I am not an expert, but I have observed that initrd/initramfs/dracut is fairly stupid, and can't handle what would seem like benign changes to the operating evironment. For example, if you install a linux kernel on a system where the / filesystem is on an LVM volume, then you move the / filesystem to a raw partition, change the grub boot commands and /etc/fstab appropriately, initrd/initramfs still fails with an "/bin/lvm exited abnormally with error 5" message. It does not seem to me that there is any reason that initrd/initramfs should care what return code lvm returns as long as it can mount the / filesystem. It also messes about with raids, generally unnecessarily. 

Again, initrd /initramfsdoes not allow for many changes in the system configurated from the state when the initrd/initramfs was created. My guess is that you are going to have to create a new initrd/initramfs. Here is the procedure at a high level, as best I can recall from the last time I had to do it

1) Boot the computer with some recent linux kernel. For example, use Knoppix or Fedora live.

2) Mount your target root filesystem and mount the target boot filesystem under it, if you use a separate filesystem for boot.

3) chroot to the target root filesystem.

4) Run mkinitrd to create a new initrd/initramfs.  mkinitrd has a zillion options that I do not pretend to understand. I generally find that it works well enough with default options.

5) If needed, update your grub.conf to point to the new initrd/initramfs.

Good luck!

Jim



At 10:02 AM 10/10/2011, maurice wrote:
>Good morning,
>
>I am top and bottom posting this reply to myself, so as to satisfy the tastes of each camp:
>
>I just tried using only one of the disks, and NOT as md RAID devices.
>This works perfectly.
>Which, at least to my eyes, implies there is some interaction with mdadm that is causing the
>failure of dracut and of booting.
>
>Is there anyone here interested in helping me with this?
>
>
>
>
>>
>>An odd problem, and hopefully someone reading this can tell me what to do differently:
>>
>>I am converting a machine from a single disk to one with 2 disks and 4 md RAIDs.
>>
>>I do not know how much detail people might like, so I will keep it as terse as possible to start:
>>Original install CentOS 6.0, with all updates.
>>XC86_64 kernel
>>
>>mdadm v3.2.2
>>
>>I have added the second physical disk, and duplicated the partition table from the existing system disk
>>created 4 md RAID1s, to be used for /boot, /, /var, and /home
>>All were created with the second part missing:
>>mdadm --create /dev/md0 --metadata=0.90 --level=1 --raid-disks=2 /dev/sda1 missing
>>mdadm --create /dev/md1 --level=1 --raid-disks=2 /dev/sda2 missing
>>mdadm --create /dev/md2 --level=1 --raid-disks=2 /dev/sda5 missing
>>mdadm --create /dev/md3 --level=1 --raid-disks=2 /dev/sda6 missing
>>
>>System is booting on GRUB 0.97.
>>Therefore I made the md0 ( /boot) with 0.90
>>And then made md1, md2 and md3 with 1.2
>>
>>Everything looks good in /proc/mdstat
>>I made file systems ( ext for boot and ext for others) , then copied over all data from original disk.
>>
>>Created the mdadm.conf file:
>>mdadm --detail --scan > /etc/mdadm.conf
>>
>>I used dracut to rebuild the initramfs with the new mdadm.conf:
>>
>>dracut --mdadmconf --force /boot/initramfs-$(uname -r).img $(uname -r)
>>This completed uneventfully.
>>
>>Edited /etc/fstab and rebooted.
>>Now I have all my filesystems on the md devices with no complaints.
>>
>>Ran grub and installed on the new disk :
>>root (hd0,0)
>>setup (hd0)
>>Completed successfully
>>
>>Next, rebooted again, and this time manually edited the grub command line to change
>>from root=/dev/sdb2  to root=/dev/md1
>>
>>And here it gets funny:
>>
>>Boots a bit, then I see:
>>
>>dracut Warning: No root device "block: /dev/md1" found.
>>
>>And a few seconds later we get a kernel panic.
>Good morning,
>
>I am top and bottom posting this reply to myself, so as to satisfy the tastes of each camp:
>
>I just tried using only one of the disks, and NOT as md RAID devices.
>This works perfectly.
>Which, at least to my eyes, implies there is some interaction with mdadm that is causing the
>failure of dracut and of booting.
>
>Is there anyone here interested in helping me with this?
>
>
>-- 
>Cheers,
>Maurice Hilarius
>eMail: /mhilarius@gmail.com/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

