From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 13:59:31 -0500
Message-ID: <4DD41713.5070407@hardwarefreak.com>
References: <595104.28955.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <595104.28955.qm@web65106.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/16/2011 4:41 PM, Gavin Flower wrote:

> Motivation, existing RAID-6 swap partition failed.  I am thinking I should recreate it in a new format, as currently it is 'Version : 0.90', rather than simply rebuild it.
<snip>

Forget using a partition.  Simply use a swap file.  This example creates
a 1GB swap file in the / filesystem.  You can locate it on any
filesystem you wish.

# swappoff -a
# dd if=/dev/zero of=/swapfile1 bs=1024 count=1048576
# mkswap /swapfile1
# swapon /swapfile1
# vi /etc/fstab
Add:
/swapfile1 swap swap defaults 0 0

and remove your old entry for the failed swap partition.

There is little performance difference between swap files and swap
partitions with modern kernels.  The kernel will map the disk location
of the swap file and perform direct disk access, bypassing the
filesystem and buffer cache.

-- 
Stan
