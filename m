From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] isofs: remove a stale comment
Date: Wed,  8 Jul 2020 14:25:44 +0200
Message-ID: <20200708122546.214579-5-hch@lst.de>
References: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

check_disk_change isn't for consumers of the block layer, so remove
the comment mentioning it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/isofs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index d634561f871a56..78f5c96c76f31e 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -612,9 +612,6 @@ static bool rootdir_empty(struct super_block *sb, unsigned long block)
 
 /*
  * Initialize the superblock and read the root inode.
- *
- * Note: a check_disk_change() has been done immediately prior
- * to this call, so we don't need to check again.
  */
 static int isofs_fill_super(struct super_block *s, void *data, int silent)
 {
-- 
2.26.2
