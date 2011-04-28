From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/5] imsm: fix: disable migration from raid5->raid0
Date: Fri, 29 Apr 2011 00:00:38 +0200
Message-ID: <20110428220038.19632.64037.stgit@gklab-128-081.igk.intel.com>
References: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

it is not supported yet, so start such transition is improper.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9bf4714..c02c5c8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7247,10 +7247,6 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				check_devs = 1;
 			}
 			break;
-		case 5:
-			if (geo->level == 0)
-				change = CH_MIGRATION;
-			break;
 		case 10:
 			if (geo->level == 0) {
 				change = CH_TAKEOVER;

