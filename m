From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 5] Introduction
Date: Fri, 02 Sep 2005 16:12:52 +1000
Message-ID: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


5 patches for md in 2.5.13-mm1.
The first you may already have of linux-kernel.

The remainder are little bug fixes and some enhancments to the content
of /proc/mdstat.  All are suitable for early dispatch to Linus.

Thanks,
NeilBrown

 [PATCH md 001 of 5] drivers/md/raid1.c: make a function static
 [PATCH md 002 of 5] Choose better default offset for bitmap.
 [PATCH md 003 of 5] Use queue_hardsect_size instead of block_size for md superblock size calc.
 [PATCH md 004 of 5] Add information about superblock version to /proc/mdstat
 [PATCH md 005 of 5] Report spare drives in /proc/mdstat
