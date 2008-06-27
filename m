From: NeilBrown <neilb@suse.de>
Subject: [PATCH 010 of 29] md: Enable setting of 'offset' and 'size' of a hot-added spare.
Date: Fri, 27 Jun 2008 16:50:23 +1000
Message-ID: <1080627065023.10455@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


offset_store and rdev_size_store allow control of the region of a
device which is to be using in an md/raid array.
They only allow these values to be set when an array is being assembled,
as changing them on an active array could be dangerous.
However when adding a spare device to an array, we might need to
set the offset and size before starting recovery.  So allow
these values to be set also if "->raid_disk < 0" which indicates that
the device is still a spare.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:33:00.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:33:01.000000000 +1000
@@ -1984,7 +1984,7 @@ offset_store(mdk_rdev_t *rdev, const cha
 	unsigned long long offset = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
+	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
 	if (rdev->size && rdev->mddev->external)
 		/* Must set offset before size, so overlap checks
@@ -2023,7 +2023,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (my_mddev->pers)
+	if (my_mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
