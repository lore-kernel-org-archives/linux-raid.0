From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/6] md: linear.c: Remove pointless initialization of curr_offset.
Date: Thu, 21 Aug 2008 15:35:31 +0200
Message-ID: <1219325735-4111-3-git-send-email-maan@systemlinux.org>
References: <1219325735-4111-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1219325735-4111-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5f64435..b5e5e11 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -218,7 +218,6 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 			conf->disks[i-1].size;
 
 	table = conf->hash_table;
-	curr_offset = 0;
 	i = 0;
 	for (curr_offset = 0;
 	     curr_offset < conf->array_sectors / 2;
-- 
1.5.3.8

