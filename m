From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Two disk RAID10 inactive on boot if partition is missing
Date: Tue, 17 May 2016 10:40:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1605171038490.28372@uplift.swm.pp.se>
References: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kay <syllopsium@syllopsium.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 May 2016, Peter Kay wrote:

> If the entire SSD device is missing on boot, the mdraid fails to exist 
> (/dev/md/mdcache is not present), saying it's inactive and the partition 
> device is a spare, thus causing the bcache to fail to exist also.

I didn't see this in your email, does this help?

https://help.ubuntu.com/community/Installation/SoftwareRAID#Boot_from_Degraded_Disk

Boot from Degraded Disk
If the default HDD fails then RAID will ask you to boot from a degraded 
disk. If your server is located in a remote area, the best practice may be 
to configure this to occur automatically:

edit /etc/initramfs-tools/conf.d/mdadm
change "BOOT_DEGRADED=false" to "BOOT_DEGRADED=true"
# Please provide URL to support claim: (this option is not supported from 
mdadm-3.2.5-5ubuntu3 / Ubuntu 14.04 onwards)

Additionally, this can be specified on the kernel boot line with the 
bootdegraded=[true|false]
You also can use #dpkg-reconfigure mdadm rather than CLI!

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
