From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 2 of 3 - Md sync: Remove compiler warning that revealed a bug.
Date: Thu, 20 Jun 2002 10:05:23 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15633.7235.452348.379978@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



When we abort a resync before we even started (because we were
interrupted while waiting for a conflicting resync to finish)
we should not wait or, particularly, do the closing sync_request
(as we haven't even calculated max_sectors yet).


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- ./drivers/md/md.c	2002/06/19 23:20:56	1.2
+++ ./drivers/md/md.c	2002/06/19 23:29:01	1.3
@@ -3230,7 +3230,7 @@
 					flush_curr_signals();
 					err = -EINTR;
 					mddev_put(mddev2);
-					goto out;
+					goto skip;
 				}
 			}
 		}
@@ -3331,11 +3331,11 @@
 	/*
 	 * this also signals 'finished resyncing' to md_stop
 	 */
-out:
+ out:
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, 1);
-
+ skip:
 	mddev->curr_resync = 0;
 	if (err)
 		mddev->recovery_running = err;
