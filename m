From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: Help Root Raid
Date: Wed, 18 Aug 2004 17:24:14 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0408181721580.23679@umi.cfht.hawaii.edu>
References: <00ea01c4859b$12cac440$9a59023d@dreammachine>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00ea01c4859b$12cac440$9a59023d@dreammachine>
To: Pankaj Agarwal <pankaj@pnpexports.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Panjak,

You mean:

mount -t ext2 /dev/hdc1 /mnt

replace /mnt with some unused, existing directory to mount your disk to.

-Kanoa

On Thu, 19 Aug 2004, Pankaj Agarwal wrote:

> Hi,
>
> I need your help regarding root raid. I have a root raid implemented server
> and it not booting anymore. I tried to use that harddisc as secondary hard
> disk to on of my other linux installation..so i can take a backup of files.
> The other installation has raid precompiled....as in booting process it
> checks for raid arays and at shutdown it gives messages regarding md
> devices. however it doesn't show any dev in lsdev or /proc/mdstat. My
> problem is when i try to mount it using "mount -t ext2 /dev/md0 /mnt/hdc1"
> it gives me error as "wronf fs, bad option, bad superblock on
> /dev/md0.........................(aren't you trying to mount a block device
> on a logical device)". Kindly show me the way to mount the filesystem.
>
> thanks and regards,
>
> Pankaj Agarwal
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
