From: mwilck@arcor.de
Subject: [PATCH 4/5] DDF: get_extents: don't allocate space on failed disks
Date: Mon,  5 Aug 2013 22:37:50 +0200
Message-ID: <1375735071-9160-4-git-send-email-mwilck@arcor.de>
References: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

We should skip known failed disks when allocating space for
new arrays. This fixes the problem with 10ddf-fail-spare.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index b352a52..23438b7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2390,7 +2390,10 @@ static struct extent *get_extents(struct ddf_super *ddf, struct dl *dl)
 	struct extent *rv;
 	int n = 0;
 	unsigned int i;
-
+	__u16 state = be16_to_cpu(ddf->phys->entries[dl->pdnum].state);
+	if ((state & (DDF_Online|DDF_Failed|DDF_Missing)) != DDF_Online)
+		return NULL;
+	
 	rv = xmalloc(sizeof(struct extent) * (ddf->max_part + 2));
 
 	for (i = 0; i < ddf->max_part; i++) {
-- 
1.7.1
