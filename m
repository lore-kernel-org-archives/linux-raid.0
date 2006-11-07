From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 9] md: Change ONLINE/OFFLINE events to a single CHANGE event
Date: Wed, 8 Nov 2006 09:09:26 +1100
Message-ID: <1061107220926.12477@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753521AbWKGWJa@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


It turns out that CHANGE is preferred to ONLINE/OFFLINE for various reasons
(not least of which being that udev understands it already).

So remove the recently added KOBJ_OFFLINE (no-one is likely to care
anyway) and change the ONLINE to a CHANGE event

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-11-06 11:21:25.000000000 +1100
+++ ./drivers/md/md.c	2006-11-06 11:22:14.000000000 +1100
@@ -3200,7 +3200,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
-	kobject_uevent(&mddev->gendisk->kobj, KOBJ_ONLINE);
+	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
@@ -3314,7 +3314,6 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
-			kobject_uevent(&mddev->gendisk->kobj, KOBJ_OFFLINE);
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
