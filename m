From: Greg KH <gregkh@suse.de>
Subject: [33/45] md/raid5: fix bug that could result in reads from a failed device.
Date: Fri, 16 Dec 2011 11:40:40 -0800
Message-ID: <20111216194212.142775381@clark.kroah.org>
References: <20111216194603.GA15028@kroah.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux RAID <linux-raid@vger.kernel.org>, Alexander Lyakas <alex.bolshoy@gmail.com>, tim.gardner@canonical.com, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: NeilBrown <neilb@suse.de>

commit 355840e7a7e56bb2834fd3b0da64da5465f8aeaa upstream.

commit a847627709b3402163d99f7c6fda4a77bcd6b51b in linux-3.0.9
attempted to backport this to 3.0 but only made one change were two
were necessary.  This add the second change.

This bug was introduced in 415e72d034c50520ddb7ff79e7d1792c1306f0c9
which was in 2.6.36.

There is a small window of time between when a device fails and when
it is removed from the array.  During this time we might still read
from it, but we won't write to it - so it is possible that we could
read stale data.

We didn't need the test of 'Faulty' before because the test on
In_sync is sufficient.  Since we started allowing reads from the early
part of non-In_sync devices we need a test on Faulty too.

This is suitable for any kernel from 2.6.36 onwards, though the patch
might need a bit of tweaking in 3.0 and earlier.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3078,7 +3078,7 @@ static void handle_stripe5(struct stripe
 			/* Not in-sync */;
 		else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else {
+		else if (!test_bit(Faulty, &rdev->flags)) {
 			/* could be in-sync depending on recovery/reshape status */
 			if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);
