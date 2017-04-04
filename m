From: Michael Wang <yun.wang@profitbricks.com>
Subject: [RFC PATCH] raid1: reset 'bi_next' before reuse the bio
Date: Tue, 4 Apr 2017 15:50:56 +0200
Message-ID: <dcd33b53-5c6f-3ebc-8c07-04f0c0372796@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids


During the testing we found the sync read bio can go through
path:

  md_do_sync()
    sync_request()
      generic_make_request()
        blk_queue_bio()
          blk_attempt_plug_merge()
            bio->bi_next CHAINED HERE

  ...

  raid1d()
    sync_request_write()
      fix_sync_read_error()
        if FailFast && Faulty
          bio->bi_end_io = end_sync_write
      generic_make_request()
        BUG_ON(bio->bi_next)

This need to meet the conditions:
  * bio once merged
  * read disk have FailFast enabled
  * read disk is Faulty

And since the block layer won't reset the 'bi_next' after bio
is done inside request, we hit the BUG like that.

This patch simply reset the bi_next before we reuse it.

Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7d67235..0554110 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1986,11 +1986,13 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		/* Don't try recovering from here - just fail it
 		 * ... unless it is the last working device of course */
 		md_error(mddev, rdev);
-		if (test_bit(Faulty, &rdev->flags))
+		if (test_bit(Faulty, &rdev->flags)) {
 			/* Don't try to read from here, but make sure
 			 * put_buf does it's thing
 			 */
 			bio->bi_end_io = end_sync_write;
+			bio->bi_next = NULL;
+		}
 	}
 
 	while(sectors) {
-- 
2.5.0
