From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 4] md: Fix innocuous bug in raid6 stripe_to_pdidx
Date: Tue, 14 Nov 2006 11:22:28 +1100
Message-ID: <1061114002228.31156@suse.de>
References: <20061114111600.31061.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


stripe_to_pdidx finds the index of the parity disk for a given
stripe.
It assumes raid5 in that it uses "disks-1" to determine the number
of data disks.

This is incorrect for raid6 but fortunately the two usages cancel each
other out.  The only way that 'data_disks' affects the calculation of
pd_idx in raid5_compute_sector is when it is divided into the
sector number.  But as that sector number is calculated by multiplying
in the wrong value of 'data_disks' the division produces the right
value.

So it is innocuous but needs to be fixed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-14 10:05:00.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-14 10:33:41.000000000 +1100
@@ -1355,8 +1355,10 @@ static int stripe_to_pdidx(sector_t stri
 	int pd_idx, dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
 
-	raid5_compute_sector(stripe*(disks-1)*sectors_per_chunk
-			     + chunk_offset, disks, disks-1, &dd_idx, &pd_idx, conf);
+	raid5_compute_sector(stripe * (disks - conf->max_degraded)
+			     *sectors_per_chunk + chunk_offset,
+			     disks, disks - conf->max_degraded,
+			     &dd_idx, &pd_idx, conf);
 	return pd_idx;
 }
 
