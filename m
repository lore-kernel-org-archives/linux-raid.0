From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Raid1 and mdadm
Date: Mon, 31 Mar 2003 09:22:08 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D71F@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


You can use grub for root mirroring (software raid-1), but grub currently
does not write the Master Boot Record to the 2nd disk, so you have to do
that manually the first time.  Sample script below:
# 
tmpa=/tmp/a
tmpg=/tmp/grub.out
cat - <<%%% >$tmpa
install (hd0,0)/grub/stage1 (hd1) (hd1,0)/grub/stage2 (hd0,0)/grub/grub.conf
quit
%%%
grub <$tmpa  >$tmpg 2>&1
# 

However, you MUST link the md driver into the kernel.  It doesn't work right
as a module, even in initrd.
That's probably why it panic'd.

Andy

-----Original Message-----
From: Friedrich Lobenstock [mailto:fl@fl.priv.at] 
Sent: Monday, March 31, 2003 6:35 AM
To: Linux RAID Mailing Liste
Subject: Re: Raid1 and mdadm


Max Booker wrote:
> 
> GRUB boot loader
> 
>     hda1    /boot
>     hda2    /
>     hda3    swap
> 
>     hdd1    (intended) mirror partition of  /
> 
> I can create the (degraded) array on hdd1, mkfs on /dev/md0, mount
/dev/md0
> as /mnt, copy / to /mnt, and edit /mnt/etc/fstab.
> 
> Everything works well up to the point where I reboot, with kernel
parameters
> (md=0,/dev/hdd1 root=/dev/md0). This is where the kernel panics.
> 
> I think that I have not edited fstab properly, or GRUB is getting in the
> way, or maybe it is not possible to add hda2 to the array because it
already
> has a filesystem on it.... How do I get hda2 to be part of the Raid array?
> Nothing attempted so far has made any impression on the fact that mdadm
> insists that /dev/hda2 is not an md component.
> 

As far as I know you have to use LILO instead of GRUB to boot
from a root raid. Take care that raid1 is compiled into the kernel.

-- 
MfG / Regards
Friedrich Lobenstock

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
