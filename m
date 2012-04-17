From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/24] md/bitmap: remove single-bit manipulation on
 sb->state
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.2399.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just do single-bit manipulations on bitmap->flags and copy whole
value between that and sb->state.

This will allow next patch which changes how bit manipulations are
performed on bitmap->flags.

This does result in BITMAP_STALE not being set in sb by
bitmap_read_sb, however as the setting is determined by other
information in the 'sb' we do not lose information this way.
Normally, bitmap_load will be called shortly which will clear
BITMAP_STALE anyway.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f5f0ec5..1fd07c5 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -520,7 +520,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	memcpy(sb->uuid, bitmap->mddev->uuid, 16);
 
 	bitmap->flags |= BITMAP_STALE;
-	sb->state |= cpu_to_le32(BITMAP_STALE);
+	sb->state = cpu_to_le32(bitmap->flags);
 	bitmap->events_cleared = bitmap->mddev->events;
 	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 
@@ -615,7 +615,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 			       "-- forcing full recovery\n",
 			       bmname(bitmap), events,
 			       (unsigned long long) bitmap->mddev->events);
-			sb->state |= cpu_to_le32(BITMAP_STALE);
+			bitmap->flags |= BITMAP_STALE;
 		}
 	}
 


