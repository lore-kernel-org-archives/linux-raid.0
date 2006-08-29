From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: Introduction
Date: Tue, 29 Aug 2006 15:39:11 +1000
Message-ID: <20060829153414.6475.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 4 patches for md, suitable for 2.6.19.

The first three define "congested_fn" functions for various raid level -
I all just found out about the need for these.  These could address 
responsiveness problems that some people have reported, particularly
while resync is running.

The last improves some messages when resync happens so e.g. it doesn't
like your array is being resynced when you only asked for it to be checked.

Thanks,
NeilBrown


 [PATCH 001 of 4] md: Define backing_dev_info.congested_fn for raid0 and linear
 [PATCH 002 of 4] md: Define ->congested_fn for raid1, raid10, and multipath
 [PATCH 003 of 4] md: Add a ->congested_fn function for raid5/6
 [PATCH 004 of 4] md: Make messages about resync/recovery etc more specific.
