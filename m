From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 06/12] imsm: switch to multiple ppls automatically during assemble
Date: Thu, 28 Sep 2017 14:41:12 +0200
Message-ID: <20170928124118.23361-7-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

If user has array with single ppl -
update the metadata to use multiple ppls.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index e1862d4a..6c48725d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6184,6 +6184,36 @@ static int validate_ppl_imsm(struct supertype *st, struct mdinfo *info,
 out:
 	free(buf);
 
+	/*
+	 * Update metadata to use mutliple PPLs area (1MB).
+	 * This is done once for all RAID members
+	 */
+	if (info->consistency_policy == CONSISTENCY_POLICY_PPL &&
+	    info->ppl_size != (MULTIPLE_PPL_AREA_SIZE_IMSM >> 9)) {
+		char subarray[20];
+		struct mdinfo *member_dev;
+
+		sprintf(subarray, "%d", info->container_member);
+
+		if (mdmon_running(st->container_devnm))
+			st->update_tail = &st->updates;
+
+		if (st->ss->update_subarray(st, subarray, "ppl", NULL)) {
+			pr_err("Failed to update subarray %s\n",
+			      subarray);
+		} else {
+			if (st->update_tail)
+				flush_metadata_updates(st);
+			else
+				st->ss->sync_metadata(st);
+			info->ppl_size = (MULTIPLE_PPL_AREA_SIZE_IMSM >> 9);
+			for (member_dev = info->devs; member_dev;
+			     member_dev = member_dev->next)
+				member_dev->ppl_size =
+				    (MULTIPLE_PPL_AREA_SIZE_IMSM >> 9);
+		}
+	}
+
 	if (ret == 1 && map->map_state == IMSM_T_STATE_UNINITIALIZED)
 		return st->ss->write_init_ppl(st, info, d->fd);
 
-- 
2.13.5

