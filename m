From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: Raid1 and mdadm
Date: Mon, 31 Mar 2003 13:34:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8827D4.2060600@fl.priv.at>
References: <005e01c2f631$c5de3620$6b7ba8c0@max>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005e01c2f631$c5de3620$6b7ba8c0@max>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
> I can create the (degraded) array on hdd1, mkfs on /dev/md0, mount /dev/md0
> as /mnt, copy / to /mnt, and edit /mnt/etc/fstab.
> 
> Everything works well up to the point where I reboot, with kernel parameters
> (md=0,/dev/hdd1 root=/dev/md0). This is where the kernel panics.
> 
> I think that I have not edited fstab properly, or GRUB is getting in the
> way, or maybe it is not possible to add hda2 to the array because it already
> has a filesystem on it.... How do I get hda2 to be part of the Raid array?
> Nothing attempted so far has made any impression on the fact that mdadm
> insists that /dev/hda2 is not an md component.
> 

As far as I know you have to use LILO instead of GRUB to boot
from a root raid. Take care that raid1 is compiled into the kernel.

-- 
MfG / Regards
Friedrich Lobenstock

