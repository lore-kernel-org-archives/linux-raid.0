From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: Monitor sometimes crashes
Date: Wed, 11 Jan 2012 11:04:08 +0100
Message-ID: <20120111100408.686.15194.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The "char cnt [40]" buffer is sometimes too small to hold all message
- in such case monitor crashes.
The buffer must be larger to be able to hold all message.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Monitor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 8bc8824..4352a0d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -563,7 +563,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		struct mdinfo *sra =
 			sysfs_read(-1, st->devnum, GET_MISMATCH);
 		if (sra && sra->mismatch_cnt > 0) {
-			char cnt[40];
+			char cnt[44];
 			sprintf(cnt, " mismatches found: %d (on raid level %d)",
 				sra->mismatch_cnt, array.level);
 			alert("RebuildFinished", dev, cnt, ainfo);

