From: mwilck@arcor.de
Subject: [PATCH 2/6] DDF: kill_subarray_ddf: fix case without mdmon running
Date: Fri, 19 Jul 2013 21:04:11 +0200
Message-ID: <1374260655-5788-3-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When mdmon wasn't runnning, meta data wasn't committed to disk.
Fixed.
---
 super-ddf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index e23291f..dc3f69b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4253,8 +4253,11 @@ static int kill_subarray_ddf(struct supertype *st)
 		/* we use DDF_state_deleted as marker */
 		vd->entries[0].state = DDF_state_deleted;
 		append_metadata_update(st, vd, len);
-	} else
+	} else {
 		_kill_subarray_ddf(ddf, conf->guid);
+		ddf_set_updates_pending(ddf);
+		ddf_sync_metadata(st);
+	}
 	return 0;
 }
 
-- 
1.7.1
