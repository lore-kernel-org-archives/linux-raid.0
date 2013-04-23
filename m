From: mwilck@arcor.de
Subject: [PATCH] DDF: fix bug in compare_super_ddf
Date: Tue, 23 Apr 2013 20:10:16 +0200
Message-ID: <1366740616-7803-1-git-send-email-mwilck@arcor.de>
References: <20130423171548.3d438b79@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130423171548.3d438b79@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Fix bug in previous patch
"DDF: compare_super_ddf: merge local info of other superblock"

Just discovered this bug in my last patch set - unfortunately, just after
you committed it.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 455f0f8..ea8439b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3514,7 +3514,7 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 
 		vl1->next = first->conflist;
 		vl1->block_sizes = NULL;
-		if (vl1->conf.sec_elmnt_count > 1) {
+		if (vl2->conf.sec_elmnt_count > 1) {
 			vl1->other_bvds = xcalloc(vl2->conf.sec_elmnt_count - 1,
 						  sizeof(struct vd_config *));
 		} else
-- 
1.7.3.4
