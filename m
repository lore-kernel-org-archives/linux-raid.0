From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 4] Fix problem with md/linear for devices larger than 2 terabytes
Date: Tue, 02 Nov 2004 14:37:45 +1100
Message-ID: <E1COpUP-00038u-6u@notabene.cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Some size fields were "int" instead of "sector_t".

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c         |    8 +++++---
 ./include/linux/raid/linear.h |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-11-02 14:20:12.000000000 +1100
+++ ./drivers/md/linear.c	2004-11-02 14:20:12.000000000 +1100
@@ -116,7 +116,8 @@ static int linear_run (mddev_t *mddev)
 	linear_conf_t *conf;
 	struct linear_hash *table;
 	mdk_rdev_t *rdev;
-	int size, i, nb_zone, cnt;
+	int i, nb_zone, cnt;
+	sector_t size;
 	unsigned int curr_offset;
 	struct list_head *tmp;
 
@@ -265,10 +266,11 @@ static int linear_make_request (request_
 		char b[BDEVNAME_SIZE];
 
 		printk("linear_make_request: Block %llu out of bounds on "
-			"dev %s size %ld offset %ld\n",
+			"dev %s size %llu offset %llu\n",
 			(unsigned long long)block,
 			bdevname(tmp_dev->rdev->bdev, b),
-			tmp_dev->size, tmp_dev->offset);
+			(unsigned long long)tmp_dev->size,
+		        (unsigned long long)tmp_dev->offset);
 		bio_io_error(bio, bio->bi_size);
 		return 0;
 	}

diff ./include/linux/raid/linear.h~current~ ./include/linux/raid/linear.h
--- ./include/linux/raid/linear.h~current~	2004-11-02 14:20:12.000000000 +1100
+++ ./include/linux/raid/linear.h	2004-11-02 14:20:12.000000000 +1100
@@ -5,8 +5,8 @@
 
 struct dev_info {
 	mdk_rdev_t	*rdev;
-	unsigned long	size;
-	unsigned long	offset;
+	sector_t	size;
+	sector_t	offset;
 };
 
 typedef struct dev_info dev_info_t;
