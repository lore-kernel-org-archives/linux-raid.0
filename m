From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Do not update metadata if not able to migrate
Date: Fri, 21 Oct 2016 11:37:49 +0200
Message-ID: <1477042671-12934-2-git-send-email-pawel.baldysiak@intel.com>
References: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch prevents mdadm from updating metadata if migration is
not possible. The same check is done in analyse_change(),
but in that place - metadata is already modified.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 6fc9cb1..5c6ab05 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10067,6 +10067,11 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			pr_err("Error. Chunk size change for RAID 10 is not supported.\n");
 			change = -1;
 			goto analyse_change_exit;
+		} else if (info.component_size % (geo->chunksize/512)) {
+			pr_err("New chunk size (%dK) does not evenly divide device size (%lluk). Aborting...\n",
+			       geo->chunksize/1024, info.component_size/2);
+			change = -1;
+			goto analyse_change_exit;
 		}
 		change = CH_MIGRATION;
 	} else {
-- 
2.7.4

