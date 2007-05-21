From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 7] md: Improve message about invalid superblock during autodetect.
Date: Mon, 21 May 2007 11:33:21 +1000
Message-ID: <1070521013321.6740@suse.de>
References: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


People try to use raid auto-detect with version-1 superblocks (which
is not supported) and get confused when they are told they have an
invalid superblock.
So be more explicit, and say it it is not a valid v0.90 superblock.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-21 11:14:54.000000000 +1000
+++ ./drivers/md/md.c	2007-05-21 11:16:16.000000000 +1000
@@ -2073,9 +2073,11 @@ static mdk_rdev_t *md_import_device(dev_
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			printk(KERN_WARNING 
-				"md: %s has invalid sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+			printk(KERN_WARNING
+				"md: %s does not have a valid v%d.%d "
+			       "superblock, not importing!\n",
+				bdevname(rdev->bdev,b),
+			       super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
@@ -5772,7 +5774,7 @@ static void autostart_arrays(int part)
 	for (i = 0; i < dev_cnt; i++) {
 		dev_t dev = detected_devices[i];
 
-		rdev = md_import_device(dev,0, 0);
+		rdev = md_import_device(dev,0, 90);
 		if (IS_ERR(rdev))
 			continue;
 
