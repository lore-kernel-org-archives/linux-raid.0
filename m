From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 011 of 14] Convert recently exported symbol to GPL
Date: Thu, 1 Dec 2005 14:23:44 +1100
Message-ID: <1051201032344.29684@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


...because that seems to be the preferred practice these days.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/md.c	2005-12-01 14:03:07.000000000 +1100
@@ -478,7 +478,7 @@ int sync_page_io(struct block_device *bd
 	bio_put(bio);
 	return ret;
 }
-EXPORT_SYMBOL(sync_page_io);
+EXPORT_SYMBOL_GPL(sync_page_io);
 
 static int read_disk_sb(mdk_rdev_t * rdev, int size)
 {
