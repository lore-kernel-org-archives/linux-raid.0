From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 12/12] md/raid5: reallocate page array after setting new stripe_size
Date: Wed, 12 Aug 2020 08:49:31 -0400
Message-ID: <20200812124931.2584743-13-yuyufen@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

When try to resize stripe_size, we also need to free old
shared page array and allocate new.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 265d1c22309b..7770b2e1248b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6680,6 +6680,7 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	struct r5conf *conf;
 	unsigned long new;
 	int err;
+	int size;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
@@ -6709,10 +6710,29 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	pr_debug("md/raid: change stripe_size from %lu to %lu\n",
 			conf->stripe_size, new);
 
+	if (mddev->sync_thread ||
+		test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		mddev->reshape_position != MaxSector ||
+		mddev->sysfs_active) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	mddev_suspend(mddev);
+	mutex_lock(&conf->cache_size_mutex);
+	size = conf->max_nr_stripes;
+
+	shrink_stripes(conf);
+
 	conf->stripe_size = new;
 	conf->stripe_shift = ilog2(new) - 9;
 	conf->stripe_sectors = new >> 9;
+	if (grow_stripes(conf, size)) {
+		pr_warn("md/raid:%s: couldn't allocate buffers\n",
+				mdname(mddev));
+		err = -ENOMEM;
+	}
+	mutex_unlock(&conf->cache_size_mutex);
 	mddev_resume(mddev);
 
 out_unlock:
-- 
2.25.4
