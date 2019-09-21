From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] md/raid0: Fix an error message in raid0_make_request()
Date: Sat, 21 Sep 2019 09:00:31 +0300
Message-ID: <20190921060031.GB18726@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

The first argument to WARN() is supposed to be a condition.  The
original code will just print the mdname() instead of the full warning
message.

Fixes: c84a1372df92 ("md/raid0: avoid RAID0 data corruption due to layout confusion.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f61693e59684..3956ea502f97 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -615,7 +615,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		tmp_dev = map_sector(mddev, zone, sector, &sector);
 		break;
 	default:
-		WARN("md/raid0:%s: Invalid layout\n", mdname(mddev));
+		WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
 		bio_io_error(bio);
 		return true;
 	}
-- 
2.20.1
