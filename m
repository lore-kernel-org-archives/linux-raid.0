From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/8] md/raid6: release spare page at ->stop()
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215817.4198.8439.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org, Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Add missing call to safe_put_page from stop() by unifying open coded
raid5_conf_t de-allocation under free_conf().

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3783553..3937423 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4316,6 +4316,15 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
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
@@ -4447,11 +4456,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 
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
@@ -4629,12 +4634,8 @@ abort:
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
@@ -4649,13 +4650,10 @@ static int stop(mddev_t *mddev)
 
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


