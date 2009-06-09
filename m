From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 3/3] md/raid5: fix bug in reshape code when chunk_size
	decreases.
Date: Tue, 09 Jun 2009 16:39:57 +1000
Message-ID: <20090609063957.11737.62151.stgit@notabene.brown>
References: <20090609063828.11737.65814.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090609063828.11737.65814.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Now that we support changing the chunksize, we calculate
"reshape_sectors" to be the max of number of sectors in old
and new chunk size.
However there is one please where we still use 'chunksize'
rather than 'reshape_sectors'.
This causes a reshape that reduces the size of chunks to freeze.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 59f2ec0..bb37fb1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3916,7 +3916,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		raid5_compute_sector(conf, stripe_addr*(new_data_disks),
 				     1, &dd_idx, NULL);
 	last_sector =
-		raid5_compute_sector(conf, ((stripe_addr+conf->chunk_size/512)
+		raid5_compute_sector(conf, ((stripe_addr+reshape_sectors)
 					    *(new_data_disks) - 1),
 				     1, &dd_idx, NULL);
 	if (last_sector >= mddev->dev_sectors)


