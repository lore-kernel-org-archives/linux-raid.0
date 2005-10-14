From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 8] Fix ref-counting problems with kobjects in md
Date: Fri, 14 Oct 2005 12:26:01 +1000
Message-ID: <1051014022601.11773@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks Greg.

Cc:  Greg KH <greg@kroah.com>

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |    8 ++++++--
 ./drivers/md/raid5.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:15:05.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:15:42.000000000 +1000
@@ -805,7 +805,11 @@ static void super_90_sync(mddev_t *mddev
 			if (fixdesc & (1<<rdev2->desc_nr)) {
 				snprintf(rdev2->kobj.name, KOBJ_NAME_LEN, "dev%d",
 					 rdev2->desc_nr);
+				/* kobject_add gets a ref on the parent, so
+				 * we have to drop the one we already have
+				 */
 				kobject_add(&rdev2->kobj);
+				kobject_put(rdev->kobj.parent);
 				sysfs_create_link(&rdev2->kobj,
 						  &rdev2->bdev->bd_disk->kobj,
 						  "block");
@@ -1178,7 +1182,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 
 	rdev->kobj.k_name = NULL;
 	snprintf(rdev->kobj.name, KOBJ_NAME_LEN, "dev%d", rdev->desc_nr);
-	rdev->kobj.parent = kobject_get(&mddev->kobj);
+	rdev->kobj.parent = &mddev->kobj;
 	kobject_add(&rdev->kobj);
 
 	sysfs_create_link(&rdev->kobj, &rdev->bdev->bd_disk->kobj, "block");
@@ -1864,7 +1868,7 @@ static struct kobject *md_probe(dev_t de
 	add_disk(disk);
 	mddev->gendisk = disk;
 	up(&disks_sem);
-	mddev->kobj.parent = kobject_get(&disk->kobj);
+	mddev->kobj.parent = &disk->kobj;
 	mddev->kobj.k_name = NULL;
 	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-10-14 12:15:25.000000000 +1000
+++ ./drivers/md/raid5.c	2005-10-14 12:15:42.000000000 +1000
@@ -1979,7 +1979,7 @@ memory = conf->max_nr_stripes * (sizeof(
 	}
 
 	/* Ok, everything is just fine now */
-	conf->kobj.parent = kobject_get(&mddev->kobj);
+	conf->kobj.parent = &mddev->kobj;
 	strcpy(conf->kobj.name, "raid5");
 	conf->kobj.ktype = &raid5_ktype;
 	kobject_register(&conf->kobj);
