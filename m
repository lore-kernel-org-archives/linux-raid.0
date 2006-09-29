From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 6] md: Use ffz instead of find_first_set to convert multiplier to shift.
Date: Fri, 29 Sep 2006 12:53:16 +1000
Message-ID: <1060929025316.15249@suse.de>
References: <20060929125047.14064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


From: Paul Clements <paul.clements@steeleye.com>

find_first_set doesn't find the least-significant bit on bigendian
machines, so it is really wrong to use it.

ffs is closer, but takes an 'int' and we have a 'unsigned long'.
So use ffz(~X) to convert a chunksize into a chunkshift.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2006-09-29 11:44:38.000000000 +1000
+++ ./drivers/md/bitmap.c	2006-09-29 11:49:40.000000000 +1000
@@ -1444,8 +1444,7 @@ int bitmap_create(mddev_t *mddev)
 	if (err)
 		goto error;
 
-	bitmap->chunkshift = find_first_bit(&bitmap->chunksize,
-					sizeof(bitmap->chunksize));
+	bitmap->chunkshift = ffz(~bitmap->chunksize);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
  	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) /
