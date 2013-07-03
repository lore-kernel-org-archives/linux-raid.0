From: mwilck@arcor.de
Subject: [PATCH 24/27] DDF: ddf_set_array_state: more meaningful output
Date: Wed,  3 Jul 2013 22:28:04 +0200
Message-ID: <1372883287-8859-25-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Print the array GUID and the array state.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index bfb7f22..8e1d502 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3952,7 +3952,9 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 	if (old != ddf->virt->entries[inst].init_state)
 		ddf_set_updates_pending(ddf);
 
-	dprintf("ddf mark %d %s %llu\n", inst, consistent?"clean":"dirty",
+	dprintf("ddf mark %d/%s (%d) %s %llu\n", inst,
+		guid_str(ddf->virt->entries[inst].guid), a->curr_state,
+		consistent?"clean":"dirty",
 		a->info.resync_start);
 	return consistent;
 }
-- 
1.7.1
