From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Desperate: mdadm fails to assemble raid saying devices are busy.
Date: Sat, 21 Sep 2013 12:44:42 -0500
Message-ID: <CAAMCDed1UffC4yj9DvKSu_9HhrJo6XLh4tHqkU9ymhP19AD1Ag@mail.gmail.com>
References: <523DADE5.8050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523DADE5.8050604@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Garg <sgarg.bugreporter@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

cat /proc/mdstat

It is probably already partially assembled (and since no force not
active--note there is a kernel optionmd_mod.start_dirty_degraded=1
that will enable if the array can at least work ) so not operational,
typically you can stop it and it will no longer show up in mdstat then
you can do what you are trying to do.

lsof will not show things that are being held open/busy in the kernel,
lsof only shows userspace useage.

On Sat, Sep 21, 2013 at 9:32 AM, Sachin Garg
<sgarg.bugreporter@gmail.com> wrote:
> Hi,
>
> I am on Arch Linux. I have a 4 device RAID 5 of which 1 device is no longer
> working. I am unable to assemble the raid.
>
> The active devices are:/dev/sda2, /dev/sdb1, /dev/sdc2
>
> The errors I get are like:
>
> # mdadm -Avf /dev/md127
> mdadm: looking for devices for /dev/md127
> mdadm: no RAID superblock on /dev/dm-6
> mdadm: no RAID superblock on /dev/dm-5
> mdadm: no RAID superblock on /dev/dm-4
> mdadm: no RAID superblock on /dev/dm-3
> mdadm: no RAID superblock on /dev/dm-2
> mdadm: no RAID superblock on /dev/dm-1
> mdadm: no RAID superblock on /dev/dm-0
> mdadm: /dev/sdc2 is busy - skipping
> mdadm: no RAID superblock on /dev/sdc1
> mdadm: no RAID superblock on /dev/sdc
> mdadm: /dev/sdb1 is busy - skipping
> mdadm: no RAID superblock on /dev/sdb
> mdadm: no RAID superblock on /dev/sda3
> mdadm: /dev/sda2 is busy - skipping
> mdadm: no RAID superblock on /dev/sda1
> mdadm: no RAID superblock on /dev/sda
>
> I would like to know what is making these devices busy. I do not see any
> indication from lsof or from the device mapper that these devices are being
> used. I have even changed the  initramfs and the fstab etc. to prevent this
> array from being started at boot time - still unable to assemble it.
>
> This array contains my /home and I do not know how to recover it.
>
> Help please ...
>
> Thanks,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
