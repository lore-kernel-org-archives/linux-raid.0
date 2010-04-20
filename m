From: Neil Brown <neilb@suse.de>
Subject: Re: compute_blocknr: map not correct error during RAID6 reshape 6
 ->  7 disks, mdadm 3.1.2 / kernel 2.6.34-rc3
Date: Tue, 20 Apr 2010 14:14:42 +1000
Message-ID: <20100420141442.2ca76b48@notabene.brown>
References: <u2j8cf253381004151856l76b4e227mc6327534e0e304ad@mail.gmail.com>
	<z2q8cf253381004192043haf99536cvfb2bf6fcfb40fa4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2q8cf253381004192043haf99536cvfb2bf6fcfb40fa4d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brett King <king.br@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 20 Apr 2010 13:43:08 +1000
Brett King <king.br@gmail.com> wrote:

> Hello,
> It's been quiet on this issue to date and I assume everyone's working
> on important fixes and features etc - my apologies for the annoyance
> however at this point I'm looking for some collective guidance on my
> next move as I can't leave things in this state.
> 
> To summarize, I am attempting to grow a RAID6 array from 6 to 7x 2TB
> disks however the reshape is stalling at 87.9% and throwing
> 'compute_blocknr: map not correct' errors. The system still responds
> but needs a hard reset to do anything MD related.

Thanks for the reminder.

Please try the following patch.

NeilBrown

From 45b14940d3fbf1891d5c2f99f334cc4f7d9e36d3 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 20 Apr 2010 14:13:34 +1000
Subject: [PATCH] md/raid5: allow for more than 2^31 chunks.

With many large drives and small chunk sizes it is possible
to create a RAID5 with more than 2^31 chunks.  Make sure this
works.

Reported-by: Brett King <king.br@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e3e9a36..20e4840 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1650,8 +1650,8 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 				     int previous, int *dd_idx,
 				     struct stripe_head *sh)
 {
-	long stripe;
-	unsigned long chunk_number;
+	sector_t stripe;
+	sector_t chunk_number;
 	unsigned int chunk_offset;
 	int pd_idx, qd_idx;
 	int ddf_layout = 0;
@@ -1671,17 +1671,12 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	 */
 	chunk_offset = sector_div(r_sector, sectors_per_chunk);
 	chunk_number = r_sector;
-	BUG_ON(r_sector != chunk_number);
 
 	/*
 	 * Compute the stripe number
 	 */
-	stripe = chunk_number / data_disks;
-
-	/*
-	 * Compute the data disk and parity disk indexes inside the stripe
-	 */
-	*dd_idx = chunk_number % data_disks;
+	stripe = chunk_number;
+	*dd_idx = sector_div(stripe, data_disks);
 
 	/*
 	 * Select the parity disk based on the user selected algorithm.
@@ -1870,14 +1865,14 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 				 : conf->algorithm;
 	sector_t stripe;
 	int chunk_offset;
-	int chunk_number, dummy1, dd_idx = i;
+	sector_t chunk_number;
+	int dummy1, dd_idx = i;
 	sector_t r_sector;
 	struct stripe_head sh2;
 
 
 	chunk_offset = sector_div(new_sector, sectors_per_chunk);
 	stripe = new_sector;
-	BUG_ON(new_sector != stripe);
 
 	if (i == sh->pd_idx)
 		return 0;
@@ -1970,7 +1965,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 	}
 
 	chunk_number = stripe * data_disks + i;
-	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
+	r_sector = chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector(conf, r_sector,
 				     previous, &dummy1, &sh2);
