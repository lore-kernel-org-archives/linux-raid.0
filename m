From: Yijing Wang <wangyijing@huawei.com>
Subject: [RESEND PATCH 2/3] bcache: update document info
Date: Wed, 22 Jun 2016 10:12:14 +0800
Message-ID: <1466561534-17595-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-raid.ids

There is no return in continue_at(), update the documentation.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/md/bcache/closure.c |    2 +-
 drivers/md/bcache/closure.h |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 9eaf1d6..864e673 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -112,7 +112,7 @@ bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
 EXPORT_SYMBOL(closure_wait);
 
 /**
- * closure_sync - sleep until a closure a closure has nothing left to wait on
+ * closure_sync - sleep until a closure has nothing left to wait on
  *
  * Sleeps until the refcount hits 1 - the thread that's running the closure owns
  * the last refcount.
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 782cc2c..f51188d 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -31,9 +31,6 @@
  * passing it, as you might expect, the function to run when nothing is pending
  * and the workqueue to run that function out of.
  *
- * continue_at() also, critically, is a macro that returns the calling function.
- * There's good reason for this.
- *
  * To use safely closures asynchronously, they must always have a refcount while
  * they are running owned by the thread that is running them. Otherwise, suppose
  * you submit some bios and wish to have a function run when they all complete:
-- 
1.7.1
