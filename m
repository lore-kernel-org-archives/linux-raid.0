From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] bcache: defensively handle format strings
Date: Tue, 10 Sep 2013 21:41:34 -0700
Message-ID: <20130911044134.GA17310@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just to be safe, call the error reporting function with "%s" to avoid
any possible future format string leak.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 547c4c5..5be1de4 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1644,7 +1644,7 @@ err_unlock_gc:
 err:
 	closure_sync(&op.cl);
 	/* XXX: test this, it's broken */
-	bch_cache_set_error(c, err);
+	bch_cache_set_error(c, "%s", err);
 }
 
 static bool can_attach_cache(struct cache *ca, struct cache_set *c)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
