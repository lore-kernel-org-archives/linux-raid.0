From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] bcache: cleanup indenting in
 bch_btree_insert_check_key()
Date: Tue, 5 Jan 2016 12:55:14 +0300
Message-ID: <20160105095514.GD23619@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Neil Brown <neilb@suse.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

This was causing a static checker complaint because the indenting wasn't
consistent.  Also it used spaces instead of tabs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 22b9e34..d493913 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2163,8 +2163,8 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 		rw_lock(true, b, b->level);
 
 		if (b->key.ptr[0] != btree_ptr ||
-                   b->seq != seq + 1) {
-                       op->lock = b->level;
+		    b->seq != seq + 1) {
+			op->lock = b->level;
 			goto out;
                }
 	}
