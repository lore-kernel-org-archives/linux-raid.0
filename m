From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 09/14] md: raid1: move 'offset' out of loop
Date: Fri, 17 Mar 2017 00:12:30 +0800
Message-ID: <20170316161235.27110-10-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

The 'offset' local variable can't be changed inside the loop, so
move it out.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4034a2963da8..2f3622c695ce 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1317,6 +1317,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 	int first_clone;
 	int sectors_handled;
 	int max_sectors;
+	sector_t offset;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -1481,13 +1482,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 	atomic_set(&r1_bio->behind_remaining, 0);
 
 	first_clone = 1;
+
+	offset = r1_bio->sector - bio->bi_iter.bi_sector;
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio = NULL;
-		sector_t offset;
 		if (!r1_bio->bios[i])
 			continue;
 
-		offset = r1_bio->sector - bio->bi_iter.bi_sector;
 
 		if (first_clone) {
 			/* do behind I/O ?
-- 
2.9.3

