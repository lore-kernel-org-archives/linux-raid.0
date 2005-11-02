From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 10] Split off some md attributes in sysfs to a separate group.
Date: Wed, 2 Nov 2005 21:15:16 +1100
Message-ID: <1051102101516.23901@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids


Some, but not all, md array support data redundancy and hence
support checking and restoring that redundancy (resync, rebuild).

Some attributes apply specifically to functions involving this
redundancy, and so should only appear for md arrays for which they
are meaningful.  i.e. they should not appear for raid0, linear, multpath,
faulty.

This patch separates these into a distinct group and creates
the group only if the personality supports sync_request.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:16.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:22.000000000 +1100
@@ -1807,10 +1807,19 @@ md_mismatches = __ATTR_RO(mismatch_cnt);
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
+	NULL,
+};
+
+static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_mismatches.attr,
 	NULL,
 };
+static struct attribute_group md_redundancy_group = {
+	.name = NULL,
+	.attrs = md_redundancy_attrs,
+};
+
 
 static ssize_t
 md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
@@ -2047,6 +2056,8 @@ static int do_md_run(mddev_t * mddev)
 		bitmap_destroy(mddev);
 		return err;
 	}
+	if (mddev->pers->sync_request)
+		sysfs_create_group(&mddev->kobj, &md_redundancy_group);
  	atomic_set(&mddev->writes_pending,0);
 	mddev->safemode = 0;
 	mddev->safemode_timer.function = md_safemode_timeout;
@@ -2155,6 +2166,9 @@ static int do_md_stop(mddev_t * mddev, i
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
 			mddev->pers->stop(mddev);
+			if (mddev->pers->sync_request)
+				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
 			if (mddev->ro)
