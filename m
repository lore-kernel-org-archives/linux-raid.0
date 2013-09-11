From: mwilck@arcor.de
Subject: [PATCH 1/2] DDF: factor out array name generation
Date: Wed, 11 Sep 2013 21:55:34 +0200
Message-ID: <1378929335-12606-1-git-send-email-mwilck@arcor.de>
References: <5230C98B.7030902@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230C98B.7030902@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The same algorithm was used in getinfo_super_ddf_bvd and
container_content_ddf. Put it in a common function.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 636d7b4..c2ac88b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1949,6 +1949,17 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	}
 }
 
+/* size of name must be at least 17 bytes! */
+static void _ddf_array_name(char *name, const struct ddf_super *ddf, int i)
+{
+	int j;
+	memcpy(name, ddf->virt->entries[i].name, 16);
+	name[16] = 0;
+	for(j = 0; j < 16; j++)
+		if (name[j] == ' ')
+			name[j] = 0;
+}
+
 static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, char *map)
 {
 	struct ddf_super *ddf = st->sb;
@@ -2026,11 +2037,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 		info->container_member);
 	info->safe_mode_delay = DDF_SAFE_MODE_DELAY;
 
-	memcpy(info->name, ddf->virt->entries[info->container_member].name, 16);
-	info->name[16]=0;
-	for(j=0; j<16; j++)
-		if (info->name[j] == ' ')
-			info->name[j] = 0;
+	_ddf_array_name(info->name, ddf, info->container_member);
 
 	if (map)
 		for (j = 0; j < map_disks; j++) {
@@ -3691,7 +3698,6 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 	for (vc = ddf->conflist ; vc ; vc=vc->next)
 	{
 		unsigned int i;
-		unsigned int j;
 		struct mdinfo *this;
 		char *ep;
 		__u32 *cptr;
@@ -3733,12 +3739,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			this->array.state = 1;
 			this->resync_start = MaxSector;
 		}
-		memcpy(this->name, ddf->virt->entries[i].name, 16);
-		this->name[16]=0;
-		for(j=0; j<16; j++)
-			if (this->name[j] == ' ')
-				this->name[j] = 0;
-
+		_ddf_array_name(this->name, ddf, i);
 		memset(this->uuid, 0, sizeof(this->uuid));
 		this->component_size = be64_to_cpu(vc->conf.blocks);
 		this->array.size = this->component_size / 2;
-- 
1.7.3.4
