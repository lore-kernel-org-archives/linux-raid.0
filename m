From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 3] md: fix uninitialized use of mddev->recovery_wait
Date: Tue, 27 May 2008 16:32:10 +1000
Message-ID: <1080527063210.16432@suse.de>
References: <20080527162558.16305.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

If an array was created with --assume-clean we will oops when trying to set
->resync_max.

Fix this by initializing ->recovery_wait in mddev_find.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-27 16:24:02.000000000 +1000
+++ ./drivers/md/md.c	2008-05-27 16:24:34.000000000 +1000
@@ -276,6 +276,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
@@ -5665,7 +5666,6 @@ void md_do_sync(mddev_t *mddev)
 		window/2,(unsigned long long) max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
-	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
 	if (j>2) {
