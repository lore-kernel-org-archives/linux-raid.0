From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 04/18] md/raid10: add rcu protection in raid10_status.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.29546.stgit@noble>
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

mirrors[].rdev can become NULL at any point unless:
 - a counted reference is held
 - ->reconfig_mutex is held, or
 - rcu_read_lock() is held

raid10_status holds none of these.  So add rcu_read_lock()
protection.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f371d45f786a..e6f3a11f8f70 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1495,10 +1495,12 @@ static void raid10_status(struct seq_file *seq, struct mddev *mddev)
 	}
 	seq_printf(seq, " [%d/%d] [", conf->geo.raid_disks,
 					conf->geo.raid_disks - mddev->degraded);
-	for (i = 0; i < conf->geo.raid_disks; i++)
-		seq_printf(seq, "%s",
-			      conf->mirrors[i].rdev &&
-			      test_bit(In_sync, &conf->mirrors[i].rdev->flags) ? "U" : "_");
+	rcu_read_lock();
+	for (i = 0; i < conf->geo.raid_disks; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+	}
+	rcu_read_unlock();
 	seq_printf(seq, "]");
 }
 


