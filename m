From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 05/14] md/raid6: release spare page at ->stop()
Date: Sat, 29 Aug 2009 19:30:26 -0700
Message-ID: <20090830023026.5934.76997.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Add missing call to safe_put_page from stop() by unifying open coded
raid5_conf_t de-allocation under free_conf().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e1920f2..9411466 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4309,6 +4309,15 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
+static void free_conf(raid5_conf_t *conf)
+{
+	shrink_stripes(conf);
+	safe_put_page(conf->spare_page);
+	kfree(conf->disks);
+	kfree(conf->stripe_hashtbl);
+	kfree(conf);
+}
+
 static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -4438,11 +4447,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 
  abort:
 	if (conf) {
-		shrink_stripes(conf);
-		safe_put_page(conf->spare_page);
-		kfree(conf->disks);
-		kfree(conf->stripe_hashtbl);
-		kfree(conf);
+		free_conf(conf);
 		return ERR_PTR(-EIO);
 	} else
 		return ERR_PTR(-ENOMEM);
@@ -4608,12 +4613,8 @@ abort:
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
 	if (conf) {
-		shrink_stripes(conf);
 		print_raid5_conf(conf);
-		safe_put_page(conf->spare_page);
-		kfree(conf->disks);
-		kfree(conf->stripe_hashtbl);
-		kfree(conf);
+		free_conf(conf);
 	}
 	mddev->private = NULL;
 	printk(KERN_ALERT "raid5: failed to run raid set %s\n", mdname(mddev));
@@ -4628,13 +4629,10 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
-	shrink_stripes(conf);
-	kfree(conf->stripe_hashtbl);
 	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
-	kfree(conf->disks);
-	kfree(conf);
+	free_conf(conf);
 	mddev->private = NULL;
 	return 0;
 }

