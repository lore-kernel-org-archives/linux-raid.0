From: NeilBrown <neilb@suse.de>
Subject: [PATCH 008 of 29] md: Close race in md_probe
Date: Fri, 27 Jun 2008 16:50:10 +1000
Message-ID: <1080627065010.10418@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


There is a possible race in md_probe.  If two threads call md_probe
for the same device, then one could exit (having checked that
->gendisk exists) before the other has called kobject_init_and_add,
thus returning an incomplete kobj which will cause problems when
we try to add children to it.

So extend the range of protection of disks_mutex slightly to
avoid this possibility.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:31:27.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:31:35.000000000 +1000
@@ -3359,9 +3359,9 @@ static struct kobject *md_probe(dev_t de
 	disk->queue = mddev->queue;
 	add_disk(disk);
 	mddev->gendisk = disk;
-	mutex_unlock(&disks_mutex);
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->dev.kobj,
 				     "%s", "md");
+	mutex_unlock(&disks_mutex);
 	if (error)
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);
