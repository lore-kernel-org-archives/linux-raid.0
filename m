From: Jeff Garzik <jgarzik@pobox.com>
Subject: [RFC] Hardware RAID offload
Date: Sun, 11 Jul 2004 16:17:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40F1A04E.8070105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Device mapper devel list <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-raid.ids


Food for comment, no specific issues or questions.

Some of the SATA controllers on the market are in a grey area between 
"completely non-RAID" and "completely hardware RAID".  These 
"in-between" SATA controllers provide some features which can be used to 
accelerate RAID in certain cases, and it would be nice to be able to 
make use of these features.  In one case, -not- making use of these 
"RAID offload" features causes a distinct performance loss.

Here's a rough description of the features provided.

1) Transaction sequencing.  Consider that N disk transactions comprise a 
single RAID1 write.  The hardware can be set up to wait until all N 
transactions are complete, before sending an interrupt.  This is 
applicable to Marvell and Promise SATA, among others.

Block layer comments:  Not really compatible with the way the Linux 
block layer works, but who knows, maybe some genius has ideas.


2) Copy elimination.  All disk transactions on the Promise SX4 go 
through an on-board DIMM (128M - 2G), before being sent to the attached 
controllers.  I would love to use this to eliminate data duplication on 
RAID1 and RAID5 writes.


3) RAID5 XOR offload.  Some Promise (and other) controllers support 
this.  Since modern CPUs are so fast, generally this isn't a useful 
feature by itself.  However, when combined with #2, you can offload 
quite a bit of RAID5 onto the hardware.


4) Off-board RAID balancing.  With disk transactions funnelled through 
the bottleneck of an on-board DIMM, the hardware is actually in a better 
position to decide how to balance raid 1/5 reads.  Only one case of that 
in hardware I know of, though.

There was a fifth feature, but I forget what it was.  :)

As some of you have no doubt already noted, these features are specific 
to a single controller, while a device-mapper or md RAID need not be. 
To facilitate this, I forsee needing to create a "hardware group" or 
"block device group", to which would allow the necessary associations to 
be utilized where available, while being 100% software in all other cases.

Or maybe, allow the user to set a flag that tells md to pass a request 
directly through to the low-level driver, in certain situations ("pass 
through all RAID1 writes, but handle everything else in software").  /me 
thinks out loud...

In general, storage hardware seems to be trending towards "put the fast 
path in hardware, let software handle the rest", which is OK with me...

	Jeff



