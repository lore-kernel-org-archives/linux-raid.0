From: Shaohua Li <shli@kernel.org>
Subject: [PATCH 3/3] dm-raid: fix a race condition in request handling
Date: Thu, 21 Sep 2017 10:42:59 -0700
Message-ID: <a81489293df2788dd664cce1746b9aac3cd0d4a6.1506015297.git.shli@fb.com>
References: <cover.1506015297.git.shli@fb.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1506015297.git.shli@fb.com>
In-Reply-To: <cover.1506015297.git.shli@fb.com>
References: <cover.1506015297.git.shli@fb.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

raid_map calls pers->make_request, which missed the suspend check. Fix it with
the new md_handle_request API.

Fix: cc27b0c78c79(md: fix deadlock between mddev_suspend() and md_write_start())
Cc: NeilBrown <neilb@suse.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5bfe285ea9d1..1ac58c5651b7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3238,7 +3238,7 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 	if (unlikely(bio_end_sector(bio) > mddev->array_sectors))
 		return DM_MAPIO_REQUEUE;
 
-	mddev->pers->make_request(mddev, bio);
+	md_handle_request(mddev, bio);
 
 	return DM_MAPIO_SUBMITTED;
 }
-- 
2.11.0
