From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 6] md: Send online/offline uevents when an md array starts/stops.
Date: Tue, 31 Oct 2006 17:00:46 +1100
Message-ID: <1061031060046.5034@suse.de>
References: <20061031164814.4884.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422768AbWJaGAy@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de
List-Id: linux-raid.ids


This allows udev to do something intelligent when an
array becomes available.

cc: gregkh@suse.de
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-31 16:40:52.000000000 +1100
+++ ./drivers/md/md.c	2006-10-31 16:41:02.000000000 +1100
@@ -3200,6 +3200,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
+	kobject_uevent(&mddev->gendisk->kobj, KOBJ_ONLINE);
 	return 0;
 }
 
@@ -3313,6 +3314,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+			kobject_uevent(&mddev->gendisk->kobj, KOBJ_OFFLINE);
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
