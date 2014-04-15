From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] Create: don't default to bitmap=internal when it is not supported
Date: Tue, 15 Apr 2014 10:01:44 +0200
Message-ID: <1397548904-31199-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

For large arrays (component size > 100GB) if write-intent bitmap is not
enabled, then it is set by default to "internal", even if the metadata
format does support internal bitmaps, which causes Create to fail.

This patch adds checking if add_internal_bitmap is set in the
superswitch before setting bitmap_file to "internal".

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Create.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Create.c b/Create.c
index e42627c..602f79c 100644
--- a/Create.c
+++ b/Create.c
@@ -509,6 +509,7 @@ int Create(struct supertype *st, char *mddev,
 
 	if (!s->bitmap_file &&
 	    s->level >= 1 &&
+	    st->ss->add_internal_bitmap &&
 	    (s->write_behind || s->size > 100*1024*1024ULL)) {
 		if (c->verbose > 0)
 			pr_err("automatically enabling write-intent bitmap on large array\n");
-- 
1.8.4.5

