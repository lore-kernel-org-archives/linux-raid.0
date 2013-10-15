From: Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] drivers: md: bcache: Fix wrong check on can_attach_cache
Date: Tue, 15 Oct 2013 20:37:22 -0300
Message-ID: <1381880242-3858-1-git-send-email-felipensp@gmail.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-raid.ids

There is a wrong check on can_attach_cache() function which
bucket_size is compared to block_size value.

Signed-off-by: Felipe Pena <felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 547c4c5..d5bc1eb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1650,7 +1650,7 @@ err:
 static bool can_attach_cache(struct cache *ca, struct cache_set *c)
 {
 	return ca->sb.block_size	== c->sb.block_size &&
-		ca->sb.bucket_size	== c->sb.block_size &&
+		ca->sb.bucket_size	== c->sb.bucket_size &&
 		ca->sb.nr_in_set	== c->sb.nr_in_set;
 }

--
1.7.10.4
