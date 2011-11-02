From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/17] md/raid1: handle activation of replacement device
 when recovery completes.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.55646.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When recovery completes ->spare_active is called.
This checks if the replacement is ready and if so it fails
the original.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index eac9a1d..5307e73 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1265,6 +1265,25 @@ static int raid1_spare_active(struct mddev *mddev)
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
+		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
+		if (repl
+		    && repl->recovery_offset == MaxSector
+		    && !test_bit(Faulty, &repl->flags)
+		    && !test_and_set_bit(In_sync, &repl->flags)) {
+			/* replacement has just become active */
+			if (!rdev ||
+			    !test_and_clear_bit(In_sync, &rdev->flags))
+				count++;
+			if (rdev) {
+				/* Replaced device not technically
+				 * faulty, but we need to be sure
+				 * it gets removed and never re-added
+				 */
+				set_bit(Faulty, &rdev->flags);
+				sysfs_notify_dirent_safe(
+					rdev->sysfs_state);
+			}
+		}
 		if (rdev
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
@@ -1362,10 +1381,21 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			err = -EBUSY;
 			p->rdev = rdev;
 			goto abort;
-		} else {
-			clear_bit(Replacement, &rdev->flags);
+		} else if (conf->mirrors[conf->raid_disks + number].rdev) {
+			/* We just removed a device that is being replaced.
+			 * Move down the replacement.  We drain all IO before
+			 * doing this to avoid confusion.
+			 */
+			struct md_rdev *repl =
+				conf->mirrors[conf->raid_disks + number].rdev;
+			raise_barrier(conf);
+			clear_bit(Replacement, &repl->flags);
+			p->rdev = repl;
+			conf->mirrors[conf->raid_disks + number].rdev = NULL;
+			lower_barrier(conf);
+			clear_bit(Replaceable, &rdev->flags);
+		} else
 			clear_bit(Replaceable, &rdev->flags);
-		}
 		err = md_integrity_register(mddev);
 	}
 abort:


