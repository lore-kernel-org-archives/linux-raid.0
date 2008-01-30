From: maximilian attems <max@stro.at>
Subject: Re: Documentation? failure to update-initramfs causes Infinite md loop on boot
Date: Wed, 30 Jan 2008 23:42:00 +0100
Message-ID: <20080130224200.GF1446@baikonur.stro.at>
References: <47A0FB0E.5020202@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A0FB0E.5020202@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 30, 2008 at 04:32:46PM -0600, Moshe Yudkowsky wrote:
> I reformatted the disks in preparation to my move to a RAID1/RAID5 
> combination. I couldn't --stop the array (that should have told me 
> something), so I removed ARRAY from mdadm.conf and restarted. I ran 
> fdisk to create the proper partitions, and then I removed the /dev/md* 
> and /dev/md/* entries in anticipation of creating the new ones. I then 
> rebooted to pick up the new partitions I'd created.

pretty simple, you change mdadm.conf put it also on initramfs:
update-initramfs -u -k all
