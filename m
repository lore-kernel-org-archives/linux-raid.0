From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: assorted bugfixes - one serious.
Date: Mon, 23 Oct 2006 17:07:42 +1000
Message-ID: <20061023170347.29132.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

I rang my regression test suite on md for the first time in a 
while (obviously too long :-().
Found two bugs resulting in patches 1 and 3.
Others are fixes for more subtle issues.

All patches are suitable for 2.6.19, patch 1 is quite serious and should go in 2.6.18.2.

Thanks,
NeilBrown


 [PATCH 001 of 4] md: Fix bug where spares don't always get rebuilt properly when they become live.
 [PATCH 002 of 4] md: Simplify checking of available size when resizing an array
 [PATCH 003 of 4] md: Fix up maintenance of ->degraded in multipath.
 [PATCH 004 of 4] md: Fix printk format warnings, seen on powerpc64:
