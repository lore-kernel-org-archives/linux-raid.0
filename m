From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 3] Fix raid10 assembly when too many devices are missing.
Date: Tue, 6 Sep 2005 13:53:07 +1000
Message-ID: <1050906035307.19321@suse.de>
References: <20050906134923.19249.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


if you try to assemble an array with too many missing devices,
raid10 will now reject the attempt, instead of allowing it.

Also check when hot-adding a drive and refuse the hot-add if 
the array is beyond hope.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-09-06 13:05:59.000000000 +1000
+++ ./drivers/md/raid10.c	2005-09-06 13:09:22.000000000 +1000
@@ -906,6 +906,27 @@ static void close_sync(conf_t *conf)
 	conf->r10buf_pool = NULL;
 }
 
+/* check if there are enough drives for
+ * every block to appear on atleast one
+ */
+static int enough(conf_t *conf)
+{
+	int first = 0;
+
+	do {
+		int n = conf->copies;
+		int cnt = 0;
+		while (n--) {
+			if (conf->mirrors[first].rdev)
+				cnt++;
+			first = (first+1) % conf->raid_disks;
+		}
+		if (cnt == 0)
+			return 0;
+	} while (first != 0);
+	return 1;
+}
+
 static int raid10_spare_active(mddev_t *mddev)
 {
 	int i;
@@ -944,6 +965,8 @@ static int raid10_add_disk(mddev_t *mdde
 		 * very different from resync
 		 */
 		return 0;
+	if (!enough(conf))
+		return 0;
 
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
@@ -1684,9 +1707,10 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_idle);
 	init_waitqueue_head(&conf->wait_resume);
 
-	if (!conf->working_disks) {
-		printk(KERN_ERR "raid10: no operational mirrors for %s\n",
-			mdname(mddev));
+	/* need to check that every block has at least one working mirror */
+	if (!enough(conf)) {
+		printk(KERN_ERR "raid10: not enough operational mirrors for %s\n",
+		       mdname(mddev));
 		goto out_free_conf;
 	}
 
