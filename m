From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix segfaults in Detail()
Date: Thu, 06 Sep 2012 17:41:19 +0200
Message-ID: <20120906154119.754.88103.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

If disk has been removed, 'st' and 'info' can be NULL. It causes segfault.
'st' and 'info' should be checked against being NULL before being used.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Detail.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Detail.c b/Detail.c
index 17aa516..79b1047 100644
--- a/Detail.c
+++ b/Detail.c
@@ -430,7 +430,7 @@ int Detail(char *dev, struct context *c)
 		}
 		free_mdstat(ms);
 
-		if (st->sb && info->reshape_active) {
+		if ((st && st->sb) && (info && info->reshape_active)) {
 #if 0
 This is pretty boring
 			printf("  Reshape pos'n : %llu%s\n", (unsigned long long) info->reshape_progress<<9,
@@ -596,7 +596,8 @@ This is pretty boring
 	if (spares && c->brief && array.raid_disks) printf(" spares=%d", spares);
 	if (c->brief && st && st->sb)
 		st->ss->brief_detail_super(st);
-	st->ss->free_super(st);
+	if (st && st->ss)
+		st->ss->free_super(st);
 
 	if (c->brief > 1 && devices) printf("\n   devices=%s", devices);
 	if (c->brief)

