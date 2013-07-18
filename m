From: mwilck@arcor.de
Subject: [PATCH 1/3] DDF: increase seq number in ddf_set_updates_pending
Date: Thu, 18 Jul 2013 20:48:59 +0200
Message-ID: <1374173341-9264-1-git-send-email-mwilck@arcor.de>
References: <20130715153141.4ac1cef9@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130715153141.4ac1cef9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Increase seq number only when there's actually a metadata change.
This is better then increasing it at every write.

This also fixes another endianness bug.
---
 super-ddf.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index a3799b8..e5007b9 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -464,8 +464,14 @@ static void pr_state(struct ddf_super *ddf, const char *msg)
 static void pr_state(const struct ddf_super *ddf, const char *msg) {}
 #endif
 
-#define ddf_set_updates_pending(x) \
-	do { (x)->updates_pending = 1; pr_state(x, __func__); } while (0)
+static void _ddf_set_updates_pending(struct ddf_super *ddf, const char *func)
+{
+	ddf->updates_pending = 1;
+	ddf->active->seq = __cpu_to_be32((__be32_to_cpu(ddf->active->seq)+1));
+	pr_state(ddf, func);
+}
+
+#define ddf_set_updates_pending(x) _ddf_set_updates_pending((x), __func__)
 
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 					     __u32 refnum, unsigned int nmax,
@@ -2867,7 +2873,7 @@ static int __write_init_super_ddf(struct supertype *st)
 	}
 	memset(null_aligned, 0xff, NULL_CONF_SZ);
 
-	seq = ddf->active->seq + 1;
+	seq = ddf->active->seq;
 
 	/* try to write updated metadata,
 	 * if we catch a failure move on to the next disk
-- 
1.7.1
