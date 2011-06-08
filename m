From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/21] imsm: FIX: Check layout for level migration
Date: Wed, 08 Jun 2011 18:10:22 +0200
Message-ID: <20110608161022.24327.5745.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When user doesn't specify raid 5 layout for raid0->rai5 migration,
layout structure member is uninitialized. Earlier it cannot be determined
if it is correct or not.
In metadata handle proper verification is placed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2468968..3baea6a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8278,7 +8278,6 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int chunk;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
-
 	if ((geo->level != info.array.level) &&
 	    (geo->level >= 0) &&
 	    (geo->level != UnSet)) {
@@ -8286,6 +8285,14 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		case 0:
 			if (geo->level == 5) {
 				change = CH_MIGRATION;
+				if (geo->layout != ALGORITHM_LEFT_ASYMMETRIC) {
+					fprintf(stderr,
+					Name " Error. Requested Layout "
+					"not supported (left-asymmetric layout "
+					"is supported only)!\n");
+					change = -1;
+					goto analyse_change_exit;
+				}
 				check_devs = 1;
 			}
 			if (geo->level == 10) {

