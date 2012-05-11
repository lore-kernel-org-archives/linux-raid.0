From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 4/7] bcache: fix symlink removal
Date: Fri, 11 May 2012 12:46:31 -0700
Message-ID: <20120511194631.25770.87184.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

symlinks need to be removed prior to the kobject being deleted,
otherwise we get:

 WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa9/0xb0()
 Hardware name: Bochs
 sysfs: can not remove 'cache', no directory

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/block/bcache/super.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/block/bcache/super.c b/drivers/block/bcache/super.c
index 70d7bcd..3289db9 100644
--- a/drivers/block/bcache/super.c
+++ b/drivers/block/bcache/super.c
@@ -747,9 +747,6 @@ static void bcache_device_detach(struct bcache_device *d)
 		atomic_set(&d->detaching, 0);
 	}
 
-	sysfs_remove_link(&d->c->kobj, d->name);
-	sysfs_remove_link(&d->kobj, "cache");
-
 	d->c->devices[d->id] = NULL;
 	closure_put(&d->c->caching);
 	d->c = NULL;
@@ -1049,10 +1046,13 @@ static void cached_dev_free(struct closure *cl)
 
 static void cached_dev_flush(struct closure *cl)
 {
-	struct cached_dev *d = container_of(cl, struct cached_dev, disk.cl);
+	struct cached_dev *cd = container_of(cl, struct cached_dev, disk.cl);
+	struct bcache_device *d = &cd->disk;
 
-	destroy_cache_accounting(&d->accounting);
-	kobject_del(&d->disk.kobj);
+	destroy_cache_accounting(&cd->accounting);
+	sysfs_remove_link(&d->kobj, d->name);
+	sysfs_remove_link(&d->kobj, "cache");
+	kobject_del(&d->kobj);
 
 	continue_at(cl, cached_dev_free, system_wq);
 }
@@ -1175,6 +1175,9 @@ static void flash_dev_free(struct closure *cl)
 static void flash_dev_flush(struct closure *cl)
 {
 	struct bcache_device *d = container_of(cl, struct bcache_device, cl);
+
+	sysfs_remove_link(&d->c->kobj, d->name);
+	sysfs_remove_link(&d->kobj, "cache");
 	kobject_del(&d->kobj);
 	continue_at(cl, flash_dev_free, system_wq);
 }
