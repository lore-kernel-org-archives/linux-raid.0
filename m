From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 15/18] md/raid5: add rcu protection to rdev accesses in
 raid5_status.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.22246.stgit@noble>
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
 drivers/md/raid5.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7da89ee22a31..e9beba258f4f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7069,10 +7069,12 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
 		conf->chunk_sectors / 2, mddev->layout);
 	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
-	for (i = 0; i < conf->raid_disks; i++)
-		seq_printf (seq, "%s",
-			       conf->disks[i].rdev &&
-			       test_bit(In_sync, &conf->disks[i].rdev->flags) ? "U" : "_");
+	rcu_read_lock();
+	for (i = 0; i < conf->raid_disks; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+	}
+	rcu_read_unlock();
 	seq_printf (seq, "]");
 }
 


