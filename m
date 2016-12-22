From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH RESEND] IMSM: Do not update metadata if not able to migrate
Date: Thu, 22 Dec 2016 13:10:47 +0100
Message-ID: <20161222121047.32469-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
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
index 0407d43..5e58672 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10808,6 +10808,11 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
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
2.9.3

