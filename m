From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/8] raid5-cache: Need to do start() part job after adding journal device
Date: Fri, 14 Jun 2019 15:41:05 -0700
Message-ID: <20190614224111.3485077-3-songliubraving@fb.com>
References: <20190614224111.3485077-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190614224111.3485077-1-songliubraving@fb.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: axboe@kernel.dk, kernel-team@fb.com, Xiao Ni <xni@redhat.com>, stable@vger.kernel.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Xiao Ni <xni@redhat.com>

commit d5d885fd514f ("md: introduce new personality funciton start()")
splits the init job to two parts. The first part run() does the jobs that
do not require the md threads. The second part start() does the jobs that
require the md threads.

Now it just does run() in adding new journal device. It needs to do the
second part start() too.

Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Cc: stable@vger.kernel.org #v4.9+
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b83bce2beb66..da94cbaa1a9e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7672,7 +7672,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	int err = -EEXIST;
+	int ret, err = -EEXIST;
 	int disk;
 	struct disk_info *p;
 	int first = 0;
@@ -7687,7 +7687,14 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		log_init(conf, rdev, false);
+		ret = log_init(conf, rdev, false);
+		if (ret)
+			return ret;
+
+		ret = r5l_start(conf->log);
+		if (ret)
+			return ret;
+
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
-- 
2.17.1
