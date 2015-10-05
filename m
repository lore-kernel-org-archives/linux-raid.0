From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH] bcache: Really show state of work pending bit
Date: Mon,  5 Oct 2015 14:39:52 +0200
Message-ID: <1444048792-22847-1-git-send-email-pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Neil Brown <neilb@suse.com>, Jiri Kosina <jkosina@suse.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-raid.ids

WORK_STRUCT_PENDING is a mask for testing the pending bit.
test_bit() expects the number of the bit and we need to
use WORK_STRUCT_PENDING_BIT there.

Also work_data_bits() is defined in workqueues.h now.

I have noticed this just by chance when looking how
WORK_STRUCT_PENDING_BIT is used. The change is compile
tested.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 drivers/md/bcache/closure.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 7a228de95fd7..9eaf1d6e8302 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -167,8 +167,6 @@ EXPORT_SYMBOL(closure_debug_destroy);
 
 static struct dentry *debug;
 
-#define work_data_bits(work) ((unsigned long *)(&(work)->data))
-
 static int debug_seq_show(struct seq_file *f, void *data)
 {
 	struct closure *cl;
@@ -182,7 +180,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 			   r & CLOSURE_REMAINING_MASK);
 
 		seq_printf(f, "%s%s%s%s\n",
-			   test_bit(WORK_STRUCT_PENDING,
+			   test_bit(WORK_STRUCT_PENDING_BIT,
 				    work_data_bits(&cl->work)) ? "Q" : "",
 			   r & CLOSURE_RUNNING	? "R" : "",
 			   r & CLOSURE_STACK	? "S" : "",
-- 
1.8.5.6
