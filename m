From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/17] md/raid10: allow removal of failed replacement
 devices.
Date: Wed, 02 Nov 2011 16:25:43 +1100
Message-ID: <20111102052543.17566.64373.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Enhance raid10_remove_disk to be able to remove ->replacement
as well as ->rdev

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   57 +++++++++++++++++++++++++++++----------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fffdc43..698696b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1431,34 +1431,41 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct r10conf *conf = mddev->private;
 	int err = 0;
 	int number = rdev->raid_disk;
-	struct mirror_info *p = conf->mirrors+ number;
+	struct md_rdev **rdevp;
+	struct mirror_info *p = conf->mirrors + number;
 
 	print_conf(conf);
-	if (rdev == p->rdev) {
-		if (test_bit(In_sync, &rdev->flags) ||
-		    atomic_read(&rdev->nr_pending)) {
-			err = -EBUSY;
-			goto abort;
-		}
-		/* Only remove faulty devices in recovery
-		 * is not possible.
-		 */
-		if (!test_bit(Faulty, &rdev->flags) &&
-		    mddev->recovery_disabled != p->recovery_disabled &&
-		    enough(conf, -1)) {
-			err = -EBUSY;
-			goto abort;
-		}
-		p->rdev = NULL;
-		synchronize_rcu();
-		if (atomic_read(&rdev->nr_pending)) {
-			/* lost the race, try later */
-			err = -EBUSY;
-			p->rdev = rdev;
-			goto abort;
-		}
-		err = md_integrity_register(mddev);
+	if (rdev == p->rdev)
+		rdevp = &p->rdev;
+	else if (rdev == p->replacement)
+		rdevp = &p->replacement;
+	else
+		return 0;
+
+	if (test_bit(In_sync, &rdev->flags) ||
+	    atomic_read(&rdev->nr_pending)) {
+		err = -EBUSY;
+		goto abort;
+	}
+	/* Only remove faulty devices if recovery
+	 * is not possible.
+	 */
+	if (!test_bit(Faulty, &rdev->flags) &&
+	    mddev->recovery_disabled != p->recovery_disabled &&
+	    enough(conf, -1)) {
+		err = -EBUSY;
+		goto abort;
 	}
+	*rdevp = NULL;
+	synchronize_rcu();
+	if (atomic_read(&rdev->nr_pending)) {
+		/* lost the race, try later */
+		err = -EBUSY;
+		*rdevp = rdev;
+		goto abort;
+	}
+	err = md_integrity_register(mddev);
+
 abort:
 
 	print_conf(conf);


