From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] bcache: Update continue_at() documentation
Date: Wed, 28 Jun 2017 14:48:18 +0300
Message-ID: <20170628114818.c7avv5773pa4gb37@mwanda>
References: <20170628114707.5oy4wmslmrethlzn@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170628114707.5oy4wmslmrethlzn@mwanda>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Ingo Molnar <mingo@kernel.org>, Coly Li <colyli@suse.de>, Yijing Wang <wangyijing@huawei.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

continue_at() doesn't have a return statement anymore.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 1ec84ca81146..295b7e43f92c 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -312,8 +312,6 @@ static inline void closure_wake_up(struct closure_waitlist *list)
  * been dropped with closure_put()), it will resume execution at @fn running out
  * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
  *
- * NOTE: This macro expands to a return in the calling function!
- *
  * This is because after calling continue_at() you no longer have a ref on @cl,
  * and whatever @cl owns may be freed out from under you - a running closure fn
  * has a ref on its own closure which continue_at() drops.
@@ -340,8 +338,6 @@ do {									\
  * Causes @fn to be executed out of @cl, in @wq context (or called directly if
  * @wq is NULL).
  *
- * NOTE: like continue_at(), this macro expands to a return in the caller!
- *
  * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
  * thus it's not safe to touch anything protected by @cl after a
  * continue_at_nobarrier().
