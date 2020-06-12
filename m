From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v4 12/15] md/raid5: support config stripe_size by sysfs entry
Date: Fri, 12 Jun 2020 19:42:17 +0800
Message-ID: <20200612114220.13126-13-yuyufen@huawei.com>
References: <20200612114220.13126-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200612114220.13126-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

After this patch, we can adjust stripe_size by writing value into sysfs
entry, likely, set stripe_size as 16KB:

  echo 16384 > /sys/block/md1/md/stripe_size

stripe_size should not be bigger than PAGE_SIZE, and it requires to be
multiple of 4096.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 66 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 455a22c22b5d..8d940c1c12de 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6709,7 +6709,71 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
 static ssize_t
 raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 {
-	return -EINVAL;
+	struct r5conf *conf = mddev->private;
+	unsigned int new;
+	int err;
+	int nr;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtouint(page, 10, &new))
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+	if (new == conf->stripe_size)
+		return len;
+
+	/*
+	 * When PAGE_SZIE is 4096, we don't need to modify stripe_size.
+	 * And the value should not be bigger than PAGE_SIZE.
+	 * It requires to be multiple of 4096.
+	 */
+	if (PAGE_SIZE == 4096 || new % 4096 != 0 ||
+			new > PAGE_SIZE || new == 0)
+		return -EINVAL;
+
+	pr_debug("md/raid: change stripe_size from %u to %u\n",
+			conf->stripe_size, new);
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	if (mddev->sync_thread ||
+	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    mddev->reshape_position != MaxSector ||
+	    mddev->sysfs_active) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
+	nr = conf->max_nr_stripes;
+
+	/* 1. suspend raid array */
+	mddev_suspend(mddev);
+
+	/* 2. free all old stripe_head */
+	mutex_lock(&conf->cache_size_mutex);
+	shrink_stripes(conf);
+	BUG_ON(conf->max_nr_stripes != 0);
+
+	/* 3. set new stripe_size */
+	conf->stripe_size = new;
+	conf->stripe_shift = ilog2(new) - 9;
+	conf->stripe_sectors = new >> 9;
+
+	/* 4. allocate new stripe_head */
+	if (grow_stripes(conf, nr))
+		pr_warn("md/raid:%s: couldn't allocate buffers\n",
+				mdname(mddev));
+	mutex_unlock(&conf->cache_size_mutex);
+
+	/* 5. resume raid array */
+	mddev_resume(mddev);
+
+out_unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
 }
 
 static struct md_sysfs_entry
-- 
2.21.3
