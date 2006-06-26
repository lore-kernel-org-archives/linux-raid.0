From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/md/raid5.c: remove an unused variable
Date: Mon, 26 Jun 2006 22:27:00 +0200
Message-ID: <20060626202700.GA23314@stusta.de>
References: <20060624061914.202fbfb5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060624061914.202fbfb5.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch removes an unused variable.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.17-mm2-full/drivers/md/raid5.c.old	2006-06-26 21:17:13.000000000 +0200
+++ linux-2.6.17-mm2-full/drivers/md/raid5.c	2006-06-26 21:17:20.000000000 +0200
@@ -2827,7 +2827,6 @@
 	struct stripe_head *sh;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
-	int data_disks = raid_disks - conf->max_degraded;
 	sector_t max_sector = mddev->size << 1;
 	int sync_blocks;
 	int still_degraded = 0;

