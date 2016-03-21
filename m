From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] md:raid1: fix a dead loop when read from a WriteMostly disk
Date: Mon, 21 Mar 2016 19:18:32 +0800
Message-ID: <1458559112-27683-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-raid.ids

If first_bad == this_sector when we get the WriteMostly disk
in read_balance(), valid disk will be returned with zero
max_sectors. It'll lead to a dead loop in make_request(), and
OOM will happen because of endless allocation of struct bio.

Since we can't get data from this disk in this case, so
continue for another disk.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4e3843f..74d42c0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -570,7 +570,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 			if (best_dist_disk < 0) {
 				if (is_badblock(rdev, this_sector, sectors,
 						&first_bad, &bad_sectors)) {
-					if (first_bad < this_sector)
+					if (first_bad <= this_sector)
 						/* Cannot use this */
 						continue;
 					best_good_sectors = first_bad - this_sector;
-- 
1.7.1

