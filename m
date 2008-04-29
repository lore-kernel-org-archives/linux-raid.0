From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 9] md: Skip all metadata update processing when using external metadata.
Date: Tue, 29 Apr 2008 13:34:54 +1000
Message-ID: <1080429033454.20325@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


All the metadata update processing for external metadata is on
in user-space or through the sysfs interfaces, so make "md_update_sb"
a no-op in that case.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:55.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
@@ -1651,6 +1651,8 @@ static void md_update_sb(mddev_t * mddev
 	int sync_req;
 	int nospares = 0;
 
+	if (mddev->external)
+		return;
 repeat:
 	spin_lock_irq(&mddev->write_lock);
 
