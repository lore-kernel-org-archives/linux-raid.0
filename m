From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Issues with Raid1 on a SS20 running 2.4.20
Date: Mon, 09 Jun 2003 23:36:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE55254.AE887892@SteelEye.com>
References: <1055208821.22414.3.camel@ninja.crib.unspeakable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Scott Walker <crimson@unspeakable.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scott Walker wrote:
 
> Below is what happens when I fsck a raid device, Either on start or from
> cli.
> 
> (none):~# fsck /tmp
> fsck 1.33 (21-Apr-2003)
> e2fsck 1.33 (21-Apr-2003)
> The filesystem size (according to the superblock) is 255626 blocks
> The physical size of the device is 255600 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort<y>?

> I'm at a loss. Does anyone have some info?

I'm guessing that you created the filesystem on one of the component
devices (sda6, sdb6) before raiding them together. That doesn't always
work. The resulting md device can be up to 4K (your chunk size is 4k) or
64k (if you have a persistent superblock) smaller than the component
devices.

You can try to resize2fs the filesystem to the proper size or recreate
the filesystem by doing mkfs /dev/md2.

You will eventually get filesystem errors when the filesystem approaches
full capacity if you continue to use it as-is.

--
Paul
