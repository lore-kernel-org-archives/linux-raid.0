From: Arne Redlich <agr@powerkom-dd.de>
Subject: [PATCH] md: handle writes to broken raid10 arrays gracefully
Date: Fri, 27 Jul 2007 16:44:35 +0200
Message-ID: <1185547475.25852.5.camel@confield.dd.xiranet.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

When writing to a broken array, raid10 currently happily emits empty bio
lists. IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ea1b3e3..957932e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -917,6 +917,13 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		bio_list_add(&bl, mbio);
 	}
 
+	if (unlikely(!atomic_read(&r10_bio->remaining))) {
+		/* the array is dead */
+		md_write_end(mddev);
+		raid_end_bio_io(r10_bio);
+		return 0;
+	}
+
 	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);


