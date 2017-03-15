From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: improve add-journal
Date: Wed, 15 Mar 2017 11:28:15 -0700
Message-ID: <20170315182816.3627123-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

1. suspend the array before adding journal, so that we can add journal
   when the array is not read-only;
2. allow recreate journal when existing journal is Faulty. So that we can
   add-journal before removing failed journal.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c    | 5 +++--
 drivers/md/raid5.c | 6 ++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 42e68b2..ac3bd15 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6230,9 +6230,10 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			struct md_rdev *rdev2;
 			bool has_journal = false;
 
-			/* make sure no existing journal disk */
+			/* make sure no active journal disk */
 			rdev_for_each(rdev2, mddev) {
-				if (test_bit(Journal, &rdev2->flags)) {
+				if (test_bit(Journal, &rdev2->flags) &&
+				    !test_bit(Faulty, &rdev2->flags)) {
 					has_journal = true;
 					break;
 				}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 447d9dd..ee8648b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7758,11 +7758,9 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			return -EBUSY;
 
 		rdev->raid_disk = 0;
-		/*
-		 * The array is in readonly mode if journal is missing, so no
-		 * write requests running. We should be safe
-		 */
+		mddev_suspend(mddev);
 		log_init(conf, rdev);
+		mddev_resume(mddev);
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
-- 
2.9.3

