From: Yijing Wang <wangyijing@huawei.com>
Subject: [RESEND PATCH 3/3] bcache: Remove redundant block_size assignment
Date: Wed, 22 Jun 2016 10:12:24 +0800
Message-ID: <1466561544-19155-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-raid.ids

We have assigned sb->block_size before the switch,
so remove the redundant one.

Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Acked-by: Eric Wheeler <bcache@lists.ewheeler.net>
---
 drivers/md/bcache/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index aecaace..bf4b100 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -134,7 +134,6 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	case BCACHE_SB_VERSION_CDEV:
 	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
 		sb->nbuckets	= le64_to_cpu(s->nbuckets);
-		sb->block_size	= le16_to_cpu(s->block_size);
 		sb->bucket_size	= le16_to_cpu(s->bucket_size);
 
 		sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
-- 
1.7.1
