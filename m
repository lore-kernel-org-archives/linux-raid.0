From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: overwrote boot sector, advice requested!
Date: Tue, 30 Nov 2004 11:43:35 +1100
Message-ID: <16811.49719.784814.375392@cse.unsw.edu.au>
References: <CC40D80C-4235-11D9-8E13-003065F94C4C@static.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Armen Babikyan on Monday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Armen Babikyan <armenb@static.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 29, armenb@static.net wrote:
> However, my attempts at trying to determine the exact location of the 
> physical partition from the location of the raid superblock and the 
> size of the "enclosed partition" (sb->size) has not given me much luck 
> (I probably am making erroneous assumptions about where exactly the 
> raid superblocks are located).

The raid superblock are located at the start of the last complete 64K
aligned 64K chunk of the device. i.e. round down the size to a
multiple of 64K, and subtract 64K.

If all your raid5 partitions were (exactly) the same size, then
sb->size will be the location of the raid superblock in the partition,
so subtracting one from the other should give you the start of the
device.

> 
> Is there any kind of software setting or tool that those in-the-know 
> can recommend that I use for determining the locations of the physical 
> partitions based on the location of the RAID superblock? (or anything 
> else for that matter!)

I recommend you look at mdadm
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
(use 1.8.0, not 1.8.1).

It won't do exactly what you want, but you may still find it helpful.

Good luck.

NeilBrown
