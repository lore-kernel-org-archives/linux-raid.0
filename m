From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v5 02/16] md/raid5: add sysfs entry to set and show stripe_size
Date: Thu, 2 Jul 2020 08:06:14 -0400
Message-ID: <20200702120628.777303-3-yuyufen@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

Here, we don't support setting stripe_size by sysfs.
Following patches will do that.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2981b853c388..51bc39dab57b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6518,6 +6518,27 @@ raid5_rmw_level = __ATTR(rmw_level, S_IRUGO | S_IWUSR,
 			 raid5_show_rmw_level,
 			 raid5_store_rmw_level);
 
+static ssize_t
+raid5_show_stripe_size(struct mddev  *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (conf)
+		return sprintf(page, "%d\n", conf->stripe_size);
+	else
+		return 0;
+}
+
+static ssize_t
+raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
+{
+	return -EINVAL;
+}
+
+static struct md_sysfs_entry
+raid5_stripe_size = __ATTR(stripe_size, 0644,
+			 raid5_show_stripe_size,
+			 raid5_store_stripe_size);
 
 static ssize_t
 raid5_show_preread_threshold(struct mddev *mddev, char *page)
@@ -6706,6 +6727,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
+	&raid5_stripe_size.attr,
 	&r5c_journal_mode.attr,
 	&ppl_write_hint.attr,
 	NULL,
-- 
2.25.4
