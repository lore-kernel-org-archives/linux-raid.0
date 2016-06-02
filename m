From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 08/18] md/raid10: simplify print_conf a little.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.46370.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

'tmp' is only ever used to extract 'tmp->rdev', so just use 'rdev' directly.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 819c6d5767a4..61091ab02a4b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1598,7 +1598,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 static void print_conf(struct r10conf *conf)
 {
 	int i;
-	struct raid10_info *tmp;
+	struct md_rdev *rdev;
 
 	printk(KERN_DEBUG "RAID10 conf printout:\n");
 	if (!conf) {
@@ -1608,14 +1608,16 @@ static void print_conf(struct r10conf *conf)
 	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->geo.raid_disks - conf->mddev->degraded,
 		conf->geo.raid_disks);
 
+	/* This is only called with ->reconfix_mutex held, so
+	 * rcu protection of rdev is not needed */
 	for (i = 0; i < conf->geo.raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
-		tmp = conf->mirrors + i;
-		if (tmp->rdev)
+		rdev = conf->mirrors[i].rdev;
+		if (rdev)
 			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !test_bit(In_sync, &tmp->rdev->flags),
-			        !test_bit(Faulty, &tmp->rdev->flags),
-				bdevname(tmp->rdev->bdev,b));
+				i, !test_bit(In_sync, &rdev->flags),
+			        !test_bit(Faulty, &rdev->flags),
+				bdevname(rdev->bdev,b));
 	}
 }
 


