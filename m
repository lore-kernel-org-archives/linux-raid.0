From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date: Thu, 23 May 2019 10:23:44 -0700
Message-ID: <20190523172345.1861077-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, stable@vger.kernel.org
Cc: axboe@kernel.dk, "Guilherme G. Piccoli" <gpiccoli@canonical.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>

Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
with device removal triggers a crash") introduced a NULL pointer
dereference in generic_make_request(). The patch sets q to NULL and
enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
which is not taken, and then the 'else' will dereference q in
blk_queue_dying(q).

This patch just moves the 'q = NULL' to a point in which it won't trigger
the oops, although the semantics of this NULLification remains untouched.

A simple test case/reproducer is as follows:
a) Build kernel v5.2-rc1 with CONFIG_BLK_CGROUP=n.

b) Create a raid0 md array with 2 NVMe devices as members, and mount it
with an ext4 filesystem.

c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
(dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
echo 1 > /sys/block/nvme0n1/device/device/remove
(whereas nvme0n1 is the 2nd array member)

This will trigger the following oops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
RIP: 0010:generic_make_request+0x32b/0x400
Call Trace:
 submit_bio+0x73/0x140
 ext4_io_submit+0x4d/0x60
 ext4_writepages+0x626/0xe90
 do_writepages+0x4b/0xe0
[...]

This patch has no functional changes and preserves the md/raid0 behavior
when a member is removed before kernel v4.17.

Cc: stable@vger.kernel.org # v4.17
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Eric Ren <renzhengeek@gmail.com>
Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 block/blk-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a55389ba8779..d24a29244cb8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1074,10 +1074,8 @@ blk_qc_t generic_make_request(struct bio *bio)
 			flags = 0;
 			if (bio->bi_opf & REQ_NOWAIT)
 				flags = BLK_MQ_REQ_NOWAIT;
-			if (blk_queue_enter(q, flags) < 0) {
+			if (blk_queue_enter(q, flags) < 0)
 				enter_succeeded = false;
-				q = NULL;
-			}
 		}
 
 		if (enter_succeeded) {
@@ -1108,6 +1106,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 				bio_wouldblock_error(bio);
 			else
 				bio_io_error(bio);
+			q = NULL;
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
-- 
2.17.1
