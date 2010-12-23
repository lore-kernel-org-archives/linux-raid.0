From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 5/5] Consider target only for spare-same-domain
Date: Thu, 23 Dec 2010 17:04:45 +0100
Message-ID: <20101223160445.5562.41182.stgit@gklab-170-211.igk.intel.com>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

otherwise, matching target will force spare-same-domain regardless of
action that comes in domain.
---
 Incremental.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index e022506..24015ca 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -978,7 +978,8 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		 * array which matches 'target'.
 		 * target is considered only if we deal with degraded array
 		 */
-		if (target) {
+		if (target && policy_action_allows(pol, st2->ss->name,
+						   act_spare_same_slot)) {
 			if (strcmp(target->metadata, mp->metadata) == 0 &&
 			    memcmp(target->uuid, mp->uuid,
 				   sizeof(target->uuid)) == 0 && 

