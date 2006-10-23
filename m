From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 4] md: Fix bug where spares don't always get rebuilt properly when they become live.
Date: Mon, 23 Oct 2006 17:07:48 +1000
Message-ID: <1061023070748.29223@suse.de>
References: <20061023170347.29132.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


If save_raid_disk is >= 0, then the device could be a device that is 
already in sync that is being re-added.  So we need to default this
value to -1.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-23 16:34:55.000000000 +1000
+++ ./drivers/md/md.c	2006-10-23 16:35:05.000000000 +1000
@@ -2003,6 +2003,7 @@ static mdk_rdev_t *md_import_device(dev_
 	kobject_init(&rdev->kobj);
 
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
