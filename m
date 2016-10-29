From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 30/60] bcache: set flag of QUEUE_FLAG_SPLIT_MP
Date: Sat, 29 Oct 2016 16:08:29 +0800
Message-ID: <1477728600-12938-31-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, Yijing Wang <wangyijing@huawei.com>, Zheng Liu <wenqing.lz@taobao.com>, Mike Christie <mchristi@redhat.com>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It isn't safe(such as bch_data_verify()) to let bcache deal with
more than 1M bio from multipage bvec, so set this flag and size of
incoming bio won't be bigger than BIO_SP_MAX_SECTORS.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 52876fcf2b36..fca023a1a026 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -821,6 +821,12 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 
 	blk_queue_write_cache(q, true, true);
 
+	/*
+	 * Once bcache is audited that it is ready to deal with big
+	 * incoming bio with multipage bvecs, we can remove the flag.
+	 */
+	set_bit(QUEUE_FLAG_SPLIT_MP,	&d->disk->queue->queue_flags);
+
 	return 0;
 }
 
-- 
2.7.4
