From: <gregkh@suse.de>
Subject: Patch "md/raid5: fix bug that could result in reads from a failed device." has been added to the 3.0-stable tree
Date: Wed, 14 Dec 2011 16:03:11 -0800
Message-ID: <13239073913956@kroah.org>
References: <20111215105439.628fe074@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215105439.628fe074@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, alex.bolshoy@gmail.com, gregkh@suse.de, linux-raid@vger.kernel.org
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-raid.ids


This is a note to let you know that I've just added the patch titled

    md/raid5: fix bug that could result in reads from a failed device.

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     md-raid5-fix-bug-that-could-result-in-reads-from-a-failed-device.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From neilb@suse.de  Wed Dec 14 16:01:18 2011
From: NeilBrown <neilb@suse.de>
Date: Thu, 15 Dec 2011 10:54:39 +1100
Subject: md/raid5: fix bug that could result in reads from a failed device.
To: stable@vger.kernel.org
Cc: linux RAID <linux-raid@vger.kernel.org>, Alexander Lyakas <alex.bolshoy@gmail.com>, tim.gardner@canonical.com
Message-ID: <20111215105439.628fe074@notabene.brown>


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


Patches currently in stable-queue which might be from neilb@suse.de are

queue-3.0/md-raid5-fix-bug-that-could-result-in-reads-from-a-failed-device.patch
