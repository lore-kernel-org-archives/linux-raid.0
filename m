From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1:!conf->r1buf_pool is unlikely in function   sync_request.
Date: Wed, 28 Mar 2012 19:24:29 +0800
Message-ID: <201203281924252189178@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 7f9446682f64e28106dd52cd12bdf74a19fb4015 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 28 Mar 2012 19:20:07 +0800
Subject: [PATCH] md/raid1:!conf->r1buf_pool is unlikely in function
 sync_request.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..943b3b3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2246,7 +2246,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	int good_sectors = RESYNC_SECTORS;
 	int min_bad = 0; /* number of sectors that are bad in all devices */
 
-	if (!conf->r1buf_pool)
+	if (unlikely(!conf->r1buf_pool))
 		if (init_resync(conf))
 			return 0;
 
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-28

