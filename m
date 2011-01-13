From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 5/6] raid0->raid10 takeover- create metadata update
Date: Thu, 13 Jan 2011 16:33:00 +0100
Message-ID: <20110113153300.20266.45884.stgit@gklab-128-111.igk.intel.com>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Create metadata update for raid0 -> raid10 takeover.
Because we have no mdmon running for raid0 we have to
update metadata using local update mechanism

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7d2d777..63bd2d2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6802,7 +6802,19 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 		}
 	}
 
-	append_metadata_update(st, u, sizeof(struct imsm_update_takeover));
+	/* 0->10 transition- nothing to do here
+	 * all work will be done in prepare_update, process_update */
+	if (geo->level == 10)
+		u->direction = R0_TO_R10;
+
+	/* update metadata locally */
+	imsm_update_metadata_locally(st, u, sizeof(struct imsm_update_takeover));
+	/* and possibly remotely */
+	if (st->update_tail)
+		append_metadata_update(st, u, sizeof(struct imsm_update_takeover));
+	else
+		free(u);
+
 	return 0;
 }
 

