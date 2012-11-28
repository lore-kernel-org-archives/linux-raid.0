From: Chris Friesen <chris.friesen@genband.com>
Subject: getting I/O errors in super_written()...any ideas what would cause
 this?
Date: Wed, 28 Nov 2012 11:52:17 -0600
Message-ID: <50B64F51.6000402@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids


Hi,

I'm running 2.6.27 with LVM over software RAID 1 over a pair of SAS disks.

Recently we started seeing messages of the following pattern:

Nov 28 08:57:10 kernel: end_request: I/O error, dev sda, sector 1758169523
Nov 28 08:57:10 kernel: md: super_written gets error=-5, uptodate=0
Nov 28 08:57:10 kernel: raid1: Disk failure on sda2, disabling device.
Nov 28 08:57:10 kernel: raid1: Operation continuing on 1 devices.

We're working through our changes to figure out what might have 
triggered it, but it seems likely the root cause lies in the core code.

We're assuming it's a software issue since it's reproducible on multiple 
new-ish systems, although so far we've only tried it on systems with one 
particular configuration--we're planning on trying it with different 
disks just to be sure.

For what it's worth, we've seen the problems with disk write cache 
enabled and disabled.

Anyone have any ideas, or pointers as to what I should look at?

Thanks,
Chris


-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com
