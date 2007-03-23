From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: Allow raid4 arrays to be reshaped.
Date: Fri, 23 Mar 2007 12:10:10 +1100
Message-ID: <1070323011010.5928@suse.de>
References: <20070323120828.5793.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


All that is missing the the function pointers in raid4_pers.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++++
 1 file changed, 4 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-23 11:13:29.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-23 11:13:29.000000000 +1100
@@ -4727,6 +4727,10 @@ static struct mdk_personality raid4_pers
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+#ifdef CONFIG_MD_RAID5_RESHAPE
+	.check_reshape	= raid5_check_reshape,
+	.start_reshape  = raid5_start_reshape,
+#endif
 	.quiesce	= raid5_quiesce,
 };
 
