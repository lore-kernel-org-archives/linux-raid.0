From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 16/18] md/multipath: add rcu protection to rdev access in
 multipath_status.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.42056.stgit@noble>
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

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/multipath.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index dd483bb2e111..69244de2036b 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -141,17 +141,19 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	return;
 }
 
-static void multipath_status (struct seq_file *seq, struct mddev *mddev)
+static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 {
 	struct mpconf *conf = mddev->private;
 	int i;
 
 	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
 		    conf->raid_disks - mddev->degraded);
-	for (i = 0; i < conf->raid_disks; i++)
-		seq_printf (seq, "%s",
-			       conf->multipaths[i].rdev &&
-			       test_bit(In_sync, &conf->multipaths[i].rdev->flags) ? "U" : "_");
+	rcu_read_lock();
+	for (i = 0; i < conf->raid_disks; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
+		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+	}
+	rcu_read_unlock();
 	seq_printf (seq, "]");
 }
 


