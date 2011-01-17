From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/4] raid0->raid10 takeover- create metadata update
Date: Mon, 17 Jan 2011 16:42:52 +0100
Message-ID: <20110117154252.25096.22110.stgit@gklab-128-111.igk.intel.com>
References: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Create metadata update for raid0 -> raid10 takeover.
Because we have no mdmon running for raid0 we have to
update metadata using local update mechanism

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 86b365d..3ba9962 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6774,6 +6774,10 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 	if (geo->level == 0)
 		u->direction = R10_TO_R0;
 
+	/* 0->10 transition */
+	if (geo->level == 10)
+		u->direction = R0_TO_R10;
+
 	/* update metadata locally */
 	imsm_update_metadata_locally(st, u,
 					sizeof(struct imsm_update_takeover));

