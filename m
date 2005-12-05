From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 2] Introduction
Date: Mon, 5 Dec 2005 14:17:00 +1100
Message-ID: <20051205141310.20937.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are two patches for md in 2.6.15-rc what should get into
2.6.15-final if possible.

The first refines a newly created interface (/sys/block/mdX/md/level).
I've decided that 'raid5' is better than 'RAID-5' after all.

The second removes some limits that shouldn't really be imposed in the kernel.

Thanks,
NeilBrown



 [PATCH md 001 of 2] Change case of raid level reported in sys/mdX/md/level
 [PATCH md 002 of 2] Remove inappropriate limits in md/bitmap configuration.
