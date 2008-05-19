From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 10] md: Fix possible oops when removing a bitmap from an active array
Date: Mon, 19 May 2008 11:10:11 +1000
Message-ID: <1080519011011.7627@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


It is possible to add a write-intent bitmap to an active array, or remove
the bitmap that is there.
When we do with the 'quiesce' the array, which causes make_request to
block in "wait_barrier()".
However we are sampling the value of "mddev->bitmap" before the
wait_barrier call, and using it afterwards.  This can result in
using a bitmap structure that has been freed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-05-19 11:02:04.000000000 +1000
+++ ./drivers/md/raid1.c	2008-05-19 11:02:15.000000000 +1000
@@ -773,7 +773,7 @@ static int make_request(struct request_q
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
 	int i, targets = 0, disks;
-	struct bitmap *bitmap = mddev->bitmap;
+	struct bitmap *bitmap;
 	unsigned long flags;
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
@@ -802,6 +802,8 @@ static int make_request(struct request_q
 
 	wait_barrier(conf);
 
+	bitmap = mddev->bitmap;
+
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 
