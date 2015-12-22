From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH v2 1/2] md: bcache: Replace get_seconds with ktime_get_seconds
Date: Tue, 22 Dec 2015 19:23:30 +0530
Message-ID: <1450792410-32613-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Shraddha Barke <shraddha.6596@gmail.com>
List-Id: linux-raid.ids

32-bit systems using function get_seconds will break in the year 2038,
in order to avoid that replace the code with more appropriate
function ktime_get_seconds which is y2038 safe.
Function ktime_get_seconds is used since it uses monotonic instead of
real time and thus will not cause overflow.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
Changes in v2-
 Drop use of ktime_get_seconds for last_mount since it is not appropriate. 

 drivers/md/bcache/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 679a093..f7500cd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -696,7 +696,7 @@ static void bcache_device_detach(struct bcache_device *d)
 
 		SET_UUID_FLASH_ONLY(u, 0);
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32(ktime_get_seconds());
 		bch_uuid_write(d->c);
 	}
 
@@ -927,7 +927,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
 
 int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 {
-	uint32_t rtime = cpu_to_le32(get_seconds());
+	uint32_t rtime = cpu_to_le32(ktime_get_seconds());
 	struct uuid_entry *u;
 	char buf[BDEVNAME_SIZE];
 
@@ -959,7 +959,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
 	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32(ktime_get_seconds());
 		u = NULL;
 	}
 
@@ -1261,7 +1261,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	get_random_bytes(u->uuid, 16);
 	memset(u->label, 0, 32);
-	u->first_reg = u->last_reg = cpu_to_le32(get_seconds());
+	u->first_reg = u->last_reg = cpu_to_le32(ktime_get_seconds());
 
 	SET_UUID_FLASH_ONLY(u, 1);
 	u->sectors = size >> 9;
-- 
2.1.4

