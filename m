From: mwilck@arcor.de
Subject: [PATCH 01/27] DDF (cleanup): use a common macro for failed searches
Date: Wed,  3 Jul 2013 22:27:41 +0200
Message-ID: <1372883287-8859-2-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Use DDF_NOTFOUND instead of NO_SUCH_REFNUM.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 56aad68..91feb87 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3257,7 +3257,6 @@ static int check_secondary(const struct vcl *vc)
 	return 0;
 }
 
-#define NO_SUCH_REFNUM (0xFFFFFFFF)
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 					     __u32 refnum, unsigned int nmax,
 					     const struct vd_config **bvd,
@@ -3298,7 +3297,7 @@ static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 	}
 bad:
 	*bvd = NULL;
-	return NO_SUCH_REFNUM;
+	return DDF_NOTFOUND;
 }
 
 static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray)
@@ -3414,7 +3413,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			i = get_pd_index_from_refnum(
 				vc, ddf->phys->entries[pd].refnum,
 				ddf->mppe, &bvd, &iphys);
-			if (i == NO_SUCH_REFNUM)
+			if (i == DDF_NOTFOUND)
 				continue;
 
 			this->array.working_disks++;
-- 
1.7.1
