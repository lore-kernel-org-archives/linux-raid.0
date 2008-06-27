From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 29] md: Fix error paths if md_probe fails.
Date: Fri, 27 Jun 2008 16:49:36 +1000
Message-ID: <1080627064936.10320@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
List-Id: linux-raid.ids


md_probe can fail (e.g. alloc_disk could fail) without
returning an error (as it alway returns NULL).
So when we call mddev_find immediately afterwards, we need
to check that md_probe actually succeeded.  This means checking
that mdev->gendisk is non-NULL.

cc: <stable@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:14:04.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:31:08.000000000 +1000
@@ -3897,8 +3897,10 @@ static void autorun_devices(int part)
 
 		md_probe(dev, NULL, NULL);
 		mddev = mddev_find(dev);
-		if (!mddev) {
-			printk(KERN_ERR 
+		if (!mddev || !mddev->gendisk) {
+			if (mddev)
+				mddev_put(mddev);
+			printk(KERN_ERR
 				"md: cannot allocate memory for md drive.\n");
 			break;
 		}
