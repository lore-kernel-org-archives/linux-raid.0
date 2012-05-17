From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix a typo in fprintf message
Date: Thu, 17 May 2012 15:37:24 +0200
Message-ID: <20120517133724.19669.66945.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e2ed95a..733bb38 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10051,7 +10051,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				geo->size );
 			if (current_size >= geo->size) {
 				fprintf(stderr,
-					Name " Error. Size expanssion is "
+					Name " Error. Size expansion is "
 					"supported only (current size is %llu, "
 					"requested size /rounded/ is %llu).\n",
 					current_size, geo->size);

