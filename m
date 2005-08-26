From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 2] Introduction
Date: Fri, 26 Aug 2005 17:25:19 +1000
Message-ID: <20050826172148.16280.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are two very trivial patches against 2.6.13-rc6.
If 2.6.13 is still open for such trivial fixes, it would be good for
them to go in, but if not, I won't loose any sleep over it.

The first arranges that the first open of /dev/mdX will auto-load the
md modules (I don't know when that functionality disappeared).
The second fixes a possibly problem where-by if you stop an array and
create a new one on the same md device, it might not start any resync
that might be needed.

Thanks,
NeilBrown


 [PATCH md 001 of 2] Create a MODULE_ALIAS for md corresponding to it's block major number.
 [PATCH md 002 of 2] Clear the 'recovery' flags when starting an md array.
