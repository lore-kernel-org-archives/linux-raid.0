From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Remove unnecessary printk when raid5 gets an unaligned read.
Date: Thu, 25 Jan 2007 16:06:16 +1100
Message-ID: <1070125050616.21497@suse.de>
References: <20070125160528.21465.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

One more... (sorry about the dribs-and-drabs approach)
NeilBrown


### Comments for Changeset

raid5_mergeable_bvec tries to ensure that raid5 never sees a read
request that does not fit within just one chunk.  However as we
must always accept a single-page read, that is not always possible.

So when "in_chunk_boundary" fails, it might be unusual, but it is not
a problem and printing a message every time is a bad idea.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-01-25 15:57:56.000000000 +1100
+++ ./drivers/md/raid5.c	2007-01-25 15:55:43.000000000 +1100
@@ -2630,7 +2630,7 @@ static int chunk_aligned_read(request_qu
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
-		printk("chunk_aligned_read : non aligned\n");
+		PRINTK("chunk_aligned_read : non aligned\n");
 		return 0;
 	}
 	/*
