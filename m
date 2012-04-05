From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Fix two typos in fprintf messages
Date: Thu, 05 Apr 2012 12:26:41 +0200
Message-ID: <20120405102641.14638.79381.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a351b60..8ee9b61 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5981,7 +5981,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 		int count = count_volumes(super->hba->path,
 				      super->orom->dpa, verbose);
 		if (super->orom->vphba <= count) {
-			pr_vrb(": platform does not support more then %d raid volumes.\n",
+			pr_vrb(": platform does not support more than %d raid volumes.\n",
 			       super->orom->vphba);
 			return 0;
 		}
@@ -6115,7 +6115,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 						      super->orom->dpa, verbose);
 				if (super->orom->vphba <= count) {
 					pr_vrb(": platform does not support more"
-					       "then %d raid volumes.\n",
+					       " than %d raid volumes.\n",
 					       super->orom->vphba);
 					return 0;
 				}

