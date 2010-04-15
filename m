From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/28] md: remove some dead fields from mddev_s
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.44654.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These fields have never been used.
commit 4b6d287f627b5fb6a49f78f9e81649ff98c62bb7
added them, but also added identical files to bitmap_super_s,
and only used the latter.

So remove these unused fields.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8e4c75c..4dc6252 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -279,9 +279,6 @@ struct mddev_s
 	atomic_t			writes_pending; 
 	struct request_queue		*queue;	/* for plugging ... */
 
-	atomic_t                        write_behind; /* outstanding async IO */
-	unsigned int                    max_write_behind; /* 0 = sync */
-
 	struct bitmap                   *bitmap; /* the bitmap for the device */
 	struct {
 		struct file		*file; /* the bitmap file */


