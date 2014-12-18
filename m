From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 23/24] Read from the first device when an area is resyncing
Date: Thu, 18 Dec 2014 10:19:04 -0600
Message-ID: <20141218161904.GA29671@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

set choose_first true for cluster read in read balance when the area
is resyncing.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/raid1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index eb8fd2e..4dcbaae 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -540,7 +540,13 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
 
-	choose_first = (conf->mddev->recovery_cp < this_sector + sectors);
+	if ((conf->mddev->recovery_cp < this_sector + sectors) ||
+	    (mddev_is_clustered(conf->mddev) &&
+	    md_cluster_ops->area_resyncing(conf->mddev, this_sector,
+		    this_sector + sectors)))
+		choose_first = 1;
+	else
+		choose_first = 0;
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		sector_t dist;
-- 
2.1.2

