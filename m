From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: To more bugfixes for 2.6.25
Date: Fri, 7 Mar 2008 16:00:40 +1100
Message-ID: <20080307155754.25976.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Two more little bug fixes for md in 2.6.25.

One fixes a formatting error in /proc/mdstat.  Technically this is a
user-interface change for an interface that has been around since
2.6.15.  However the only program known to parse this file trips over
the error.  So I think it is safe to fix it.

The second fixes a small bug in a recent patch.

 [PATCH 001 of 2] md: Fix formatting error in /proc/mdstat.
 [PATCH 002 of 2] md: Reduce CPU wastage on idle md array with a write-intent bitmap. fix
