From: Neil Brown <neilb@suse.de>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active devices)
Date: Fri, 27 Jun 2008 20:40:14 +1000
Message-ID: <18532.50062.63173.620773@notabene.brown>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>
	<20080625161357.GH23944@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Wednesday June 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Dave Moon <p.b.w.tortilla@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 25, maan@systemlinux.org wrote:
> On 15:37, Dave Moon wrote:
> 
> > 1. If mdadm encounters a bit error during a RAID 6 rebuild, will it  
> > just give up on that particular file and move on to recover other data  
> > on the array? Or will it trash the entire array?
> 
> The kernel will stop the array and give up.

Not quite.  It will stop the recovery.  It won't stop the whole array
though (I think...).

> 
> > 2. Is it possible to cheat mdadm by somehow replacing the new "raid  
> > metadata" on the 6 drives with the old data on the 2 drives? Will it  
> > make mdadm think the array is clean, consistent and nothing ever  
> > happened?
> 
> > Please do note that I did not write ANY new data onto the RAID 6 array  
> > from the time it was degraded until the time I brought it down with (-- 
> > stop).
> 
> Use --force, Luke. Man mdadm(8):
> 
> 	-f, --force Assemble the array even if some superblocks
> 	appear out-of-date

--force only updates enough superblocks to assemble a working array.
For raid6, that mean n-2 drives.  As there are n-2 drive, it won't try
any harder.

You best bet is to recreate the array with --assume-clean.
Providing you have the chunksize, order of devices, etc the same, you
should get your array back.

NeilBrown
