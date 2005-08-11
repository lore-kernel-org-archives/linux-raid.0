From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 6] Don't allow new md/bitmap file to be set if one already exists
Date: Thu, 11 Aug 2005 17:22:26 +1000
Message-ID: <E1E37OU-0002jD-PH@notabene.cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


... otherwise we loose a reference and can never free the file.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-09 10:22:01.000000000 +1000
+++ ./drivers/md/md.c	2005-08-09 10:25:22.000000000 +1000
@@ -2430,7 +2430,7 @@ static int set_bitmap_file(mddev_t *mdde
 {
 	int err;
 
-	if (mddev->pers)
+	if (mddev->pers || mddev->bitmap_file)
 		return -EBUSY;
 
 	mddev->bitmap_file = fget(fd);
