From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 8 - Allow an md personality to refuse a hot-remove request.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002Tk-C3@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This isn't really needed at the moment, but it is more consistant
with the interface and may be needed later.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-05-28 15:48:47.000000000 +1000
+++ ./drivers/md/md.c	2004-05-28 15:48:47.000000000 +1000
@@ -3478,8 +3478,8 @@ void md_check_recovery(mddev_t *mddev)
 			if (rdev->raid_disk >= 0 &&
 			    rdev->faulty &&
 			    atomic_read(&rdev->nr_pending)==0) {
-				mddev->pers->hot_remove_disk(mddev, rdev->raid_disk);
-				rdev->raid_disk = -1;
+				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0)
+					rdev->raid_disk = -1;
 			}
 			if (!rdev->faulty && rdev->raid_disk >= 0 && !rdev->in_sync)
 				spares++;
