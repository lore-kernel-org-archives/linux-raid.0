From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 14 - Export bio_split_pool for md to use.
Date: Tue, 27 May 2003 13:01:11 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUi7-0003GY-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

These 14 patches to 2.5.70 make assorted updates to the md drivers.

- use new bio_split for raid0/linear requests that cross drives.
- Fix somebugs in r5, r1 ...
- tidy raid0's device selection
- remove dependance on MD_SB_DISKS constant when allocating structures.
- remove bdev_partition_name in favour of bdevname

NeilBrown

### Comments for ChangeSet

 ----------- Diffstat output ------------
 ./fs/bio.c            |    3 ++-
 ./include/linux/bio.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff ./fs/bio.c~current~ ./fs/bio.c
--- ./fs/bio.c~current~	2003-05-27 11:51:04.000000000 +1000
+++ ./fs/bio.c	2003-05-27 11:53:39.000000000 +1000
@@ -38,7 +38,7 @@ static kmem_cache_t *bio_slab;
  * basically we just need to survive
  */
 #define BIO_SPLIT_ENTRIES 8	
-static mempool_t *bio_split_pool;
+mempool_t *bio_split_pool;
 
 struct biovec_pool {
 	int nr_vecs;
@@ -916,3 +916,4 @@ EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
+EXPORT_SYMBOL(bio_split_pool);

diff ./include/linux/bio.h~current~ ./include/linux/bio.h
--- ./include/linux/bio.h~current~	2003-05-27 11:51:04.000000000 +1000
+++ ./include/linux/bio.h	2003-05-27 11:53:44.000000000 +1000
@@ -222,6 +222,7 @@ struct bio_pair {
 };
 extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
 				  int first_sectors);
+extern mempool_t *bio_split_pool;
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio *bio_alloc(int, int);
