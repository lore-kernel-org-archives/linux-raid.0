From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH] md raid10: fix NULL deference in handle_write_completed()
Date: Tue, 6 Feb 2018 17:24:08 +0800
Message-ID: <20180206092408.2817-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, neilb@suse.com
Cc: linux-raid@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>
List-Id: linux-raid.ids

In the case of 'recover', an r10bio with R10BIO_WriteError &
R10BIO_IsRecover will be progressed by handle_write_completed().
This function traverses all r10bio->devs[copies]. 
If devs[m].repl_bio != NULL, it thinks conf->mirrors[dev].replacement
is also not NULL. However, this is not always true.

When there is an rdev of raid10 has replacement, then each r10bio
->devs[m].repl_bio != NULL in conf->r10buf_pool. However, in 'recover',
even if corresponded replacement is NULL, it doesn't clear r10bio
->devs[m].repl_bio, resulting in replacement NULL deference.

This bug was introduced when replacement support for raid10 was
added in Linux 3.3, 9ad1aefc8ae8 ("md/raid10:  Handle replacement
devices during resync.")

As NeilBrown suggested:
	Elsewhere the determination of "is this device part of the
	resync/recovery" is made by resting bio->bi_end_io.
	If this is end_sync_write, then we tried to write here.
	If it is NULL, then we didn't try to write.

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid10.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index abb539c47d3b..5e13df4caec2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2732,7 +2732,8 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
 			rdev = conf->mirrors[dev].rdev;
-			if (r10_bio->devs[m].bio == NULL)
+			if (r10_bio->devs[m].bio == NULL ||
+				r10_bio->devs[m].bio->bi_end_io == NULL)
 				continue;
 			if (test_bit(BIO_UPTODATE,
 				     &r10_bio->devs[m].bio->bi_flags)) {
@@ -2748,7 +2749,8 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					md_error(conf->mddev, rdev);
 			}
 			rdev = conf->mirrors[dev].replacement;
-			if (r10_bio->devs[m].repl_bio == NULL)
+			if (r10_bio->devs[m].repl_bio == NULL ||
+				r10_bio->devs[m].repl_bio->bi_end_io == NULL)
 				continue;
 			if (test_bit(BIO_UPTODATE,
 				     &r10_bio->devs[m].repl_bio->bi_flags)) {
-- 
2.13.6

