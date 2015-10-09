From: Shaohua Li <shli@fb.com>
Subject: [PATCH 6/9] raid5-cache: start raid5 readonly if journal is missing
Date: Thu, 8 Oct 2015 21:54:10 -0700
Message-ID: <9525ea2b6865e77ce867539cde24f8f6cefc3655.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If raid array is expected to have journal (eg, journal is set in MD
superblock feature map) and the array is started without journal disk,
start the array readonly.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 3 ++-
 drivers/md/raid5.c       | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2cf6b72..e64684b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -806,8 +806,9 @@ void r5l_quiesce(struct r5l_log *log, int state)
 
 bool r5l_log_disk_error(struct r5conf *conf)
 {
+	/* don't allow write if journal disk is missing */
 	if (!conf->log)
-		return false;
+		return test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return test_bit(Faulty, &conf->log->rdev->flags);
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d1c6c4..8024cad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6810,6 +6810,14 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) && !journal_dev) {
+		printk(KERN_ERR"md/raid:%s: journal disk is missing, "
+			"force array readonly\n",
+			mdname(mddev));
+		mddev->ro = 1;
+		set_disk_ro(mddev->gendisk, 1);
+	}
+
 	conf->min_offset_diff = min_offset_diff;
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
-- 
2.4.6

