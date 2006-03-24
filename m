From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: Remove bi_end_io call out from under a spinlock.
Date: Fri, 24 Mar 2006 16:59:28 +1100
Message-ID: <1060324055928.2444@suse.de>
References: <20060324165531.2372.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


raid5 overloads bi_phys_segments to count the number of blocks that
the request was broken in to so that it knows when the bio is completely handled. 

Accessing this must  always be done under a spinlock.   In one case we
also call bi_end_io under that spinlock, which probably isn't ideal as
bi_end_io could be expensive (even though it isn't allowed to sleep).

So we reducde the range of the spinlock to just accessing bi_phys_segments.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-24 14:01:30.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-24 14:06:47.000000000 +1100
@@ -1743,6 +1743,7 @@ static int make_request(request_queue_t 
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
+	int remaining;
 
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
@@ -1852,7 +1853,9 @@ static int make_request(request_queue_t 
 			
 	}
 	spin_lock_irq(&conf->device_lock);
-	if (--bi->bi_phys_segments == 0) {
+	remaining = --bi->bi_phys_segments;
+	spin_unlock_irq(&conf->device_lock);
+	if (remaining == 0) {
 		int bytes = bi->bi_size;
 
 		if ( bio_data_dir(bi) == WRITE )
@@ -1860,7 +1863,6 @@ static int make_request(request_queue_t 
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes, 0);
 	}
-	spin_unlock_irq(&conf->device_lock);
 	return 0;
 }
 
