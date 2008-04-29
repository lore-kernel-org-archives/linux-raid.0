From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 9] md: Fix up switching md arrays between read-only and read-write
Date: Tue, 29 Apr 2008 13:35:14 +1000
Message-ID: <1080429033514.20361@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When setting an array to 'readonly' or to 'active' via sysfs, we must
make the appropriate set_disk_ro call too.
Also when switching to "read_auto" (which is like readonly, but blocks on the
first write so that metadata can be marked 'dirty') we need to be more careful
about what state we are changing from.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
@@ -2593,15 +2593,20 @@ array_state_store(mddev_t *mddev, const 
 			err = do_md_stop(mddev, 1);
 		else {
 			mddev->ro = 1;
+			set_disk_ro(mddev->gendisk, 1);
 			err = do_md_run(mddev);
 		}
 		break;
 	case read_auto:
-		/* stopping an active array */
 		if (mddev->pers) {
-			err = do_md_stop(mddev, 1);
-			if (err == 0)
-				mddev->ro = 2; /* FIXME mark devices writable */
+			if (mddev->ro != 1)
+				err = do_md_stop(mddev, 1);
+			else
+				err = restart_array(mddev);
+			if (err == 0) {
+				mddev->ro = 2;
+				set_disk_ro(mddev->gendisk, 0);
+			}
 		} else {
 			mddev->ro = 2;
 			err = do_md_run(mddev);
@@ -2639,6 +2644,7 @@ array_state_store(mddev_t *mddev, const 
 			err = 0;
 		} else {
 			mddev->ro = 0;
+			set_disk_ro(mddev->gendisk, 0);
 			err = do_md_run(mddev);
 		}
 		break;
