From: mwilck@arcor.de
Subject: [PATCH 3/3] DDF: compare_super_ddf: fix sequence number check
Date: Sat, 14 Sep 2013 22:47:12 +0200
Message-ID: <1379191632-32719-3-git-send-email-mwilck@arcor.de>
References: <1379191632-32719-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1379191632-32719-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The sequence number check in compare_super_ddf was broken,
anchor sequence number is always -1.

With this patch, mdadm will refuse to add a disk with non-matching
sequence number.

This fixes Francis Moreau's problem reported with subject
"mdadm 3.3 fails to kick out non fresh disk".

FIXME: More work is needed here. Currently mdadm won't even add the
disk to the container, that's wrong. It should be added as a spare.
---
 super-ddf.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 3673cb3..002b271 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3892,10 +3892,10 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	if (memcmp(first->anchor.guid, second->anchor.guid, DDF_GUID_LEN) != 0)
 		return 2;
 
-	if (!be32_eq(first->anchor.seq, second->anchor.seq)) {
-		dprintf("%s: sequence number mismatch %u/%u\n", __func__,
-			be32_to_cpu(first->anchor.seq),
-			be32_to_cpu(second->anchor.seq));
+	if (!be32_eq(first->active->seq, second->active->seq)) {
+		dprintf("%s: sequence number mismatch %u<->%u\n", __func__,
+			be32_to_cpu(first->active->seq),
+			be32_to_cpu(second->active->seq));
 		return 3;
 	}
 	if (first->max_part != second->max_part ||
-- 
1.7.3.4
