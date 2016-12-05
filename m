From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 5/7] imsm: allow to assemble with PPL even if dirty degraded
Date: Mon,  5 Dec 2016 16:32:02 +0100
Message-ID: <20161205153204.7343-6-artur.paszkiewicz@intel.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Pawel Baldysiak <pawel.baldysiak@intel.com>

This is necessary to allow PPL recovery in the kernel driver. If the
recovery succeeds, the array is no longer in dirty state and can be
started normally as degraded.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Assemble.c    | 4 +++-
 super-intel.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index 3da0903..022d826 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1943,7 +1943,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		   content->uuid, chosen_name);
 
 	if (enough(content->array.level, content->array.raid_disks,
-		   content->array.layout, content->array.state & 1, avail) == 0) {
+		   content->array.layout,
+		   (content->array.state & 1) || content->journal_clean,
+		   avail) == 0) {
 		if (c->export && result)
 			*result |= INCR_NO;
 		else if (c->verbose >= 0) {
diff --git a/super-intel.c b/super-intel.c
index eb6b543..e524ef0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3175,6 +3175,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
+	info->journal_clean = dev->rwh_policy;
 
 	if (is_gen_migration(dev)) {
 		info->reshape_active = 1;
-- 
2.10.1

