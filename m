From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 3] Introduction
Date: Tue, 6 Sep 2005 13:52:56 +1000
Message-ID: <20050906134923.19249.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are three patches for md in 2.6.13-mm1

The first (embarassment) gets sb_size initialisation REALLY right.
 I did more testing with mdadm-v1 and found hot-add wasn't working
 either.  This patch definitely covers all cases.

The other two fix problems with raid10 when enough drives fails that
not all block are available.  It was particularly a problem as recovery
would BUG-out, but other issues are fixed to.

These patches are tested and suitable for early release to Linus.

Thanks,
NeilBrown


 [PATCH md 001 of 3] Really get sb_size setting right in all cases.	
 [PATCH md 002 of 3] Fix raid10 assembly when too many devices are missing.
 [PATCH md 003 of 3] Fix BUG when raid10 rebuilds without enough drives.
