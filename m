From: mwilck@arcor.de
Subject: [PATCH 3/8] DDF: brief_detail_super_ddf: print correct UUID for subarrays
Date: Mon, 25 Mar 2013 23:11:11 +0000 (UTC)
Message-ID: <1382695659-6231-4-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:34 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Commit c1ea5a98 caused brief_detail_super_ddf() to be called
for subarrays. But the UUID printed was always the one of the
container. This is wrong and actually worse than printing no UUID
at all, and causes the DDF test case (10ddf-create) to fail.

This patch adds code to determine the MD UUID of a subarray correctly.
The hard part is to figure out for which subarray the function is
called. Moved that to an extra function.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 85af345..bd08d85 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -44,6 +44,9 @@ unsigned long crc32(
 	const unsigned char *buf,
 	unsigned len);
 
+#define DDF_NOTFOUND (~0U)
+#define DDF_CONTAINER (DDF_NOTFOUND-1)
+
 /* The DDF metadata handling.
  * DDF metadata lives at the end of the device.
  * The last 512 byte block provides an 'anchor' which is used to locate
@@ -1219,8 +1222,40 @@ static void examine_super_ddf(struct supertype *st, char *homehost)
 
 static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *map);
 
+static void uuid_from_ddf_guid(const char *guid, int uuid[4]);
 static void uuid_from_super_ddf(struct supertype *st, int uuid[4]);
 
+static unsigned int get_vd_num_of_subarray(struct supertype *st)
+{
+	/*
+	 * Figure out the VD number for this supertype.
+	 * Returns DDF_CONTAINER for the container itself,
+	 * and DDF_NOTFOUND on error.
+	 */
+	struct ddf_super *ddf = st->sb;
+	struct mdinfo *sra;
+	char *sub, *end;
+	unsigned int vcnum;
+
+	if (*st->container_devnm == '\0')
+		return DDF_CONTAINER;
+
+	sra = sysfs_read(-1, st->devnm, GET_VERSION);
+	if (!sra || sra->array.major_version != -1 ||
+	    sra->array.minor_version != -2 ||
+	    !is_subarray(sra->text_version))
+		return DDF_NOTFOUND;
+
+	sub = strchr(sra->text_version + 1, '/');
+	if (sub != NULL)
+		vcnum = strtoul(sub + 1, &end, 10);
+	if (sub == NULL || *sub == '\0' || *end != '\0' ||
+	    vcnum >= __be16_to_cpu(ddf->active->max_vd_entries))
+		return DDF_NOTFOUND;
+
+	return vcnum;
+}
+
 static void brief_examine_super_ddf(struct supertype *st, int verbose)
 {
 	/* We just write a generic DDF ARRAY entry
@@ -1282,13 +1317,16 @@ static void detail_super_ddf(struct supertype *st, char *homehost)
 
 static void brief_detail_super_ddf(struct supertype *st)
 {
-	/* FIXME I really need to know which array we are detailing.
-	 * Can that be stored in ddf_super??
-	 */
-//	struct ddf_super *ddf = st->sb;
 	struct mdinfo info;
 	char nbuf[64];
-	getinfo_super_ddf(st, &info, NULL);
+	struct ddf_super *ddf = st->sb;
+	unsigned int vcnum = get_vd_num_of_subarray(st);
+	if (vcnum == DDF_CONTAINER)
+		uuid_from_super_ddf(st, info.uuid);
+	else if (vcnum == DDF_NOTFOUND)
+		return;
+	else
+		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, info.uuid);
 	fname_from_uuid(st, &info, nbuf,':');
 	printf(" UUID=%s", nbuf + 5);
 }
@@ -1337,6 +1375,16 @@ static int find_phys(struct ddf_super *ddf, __u32 phys_refnum)
 	return -1;
 }
 
+static void uuid_from_ddf_guid(const char *guid, int uuid[4])
+{
+	char buf[20];
+	struct sha1_ctx ctx;
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(guid, DDF_GUID_LEN, &ctx);
+	sha1_finish_ctx(&ctx, buf);
+	memcpy(uuid, buf, 4*4);
+}
+
 static void uuid_from_super_ddf(struct supertype *st, int uuid[4])
 {
 	/* The uuid returned here is used for:
@@ -1361,18 +1409,12 @@ static void uuid_from_super_ddf(struct supertype *st, int uuid[4])
 	struct ddf_super *ddf = st->sb;
 	struct vcl *vcl = ddf->currentconf;
 	char *guid;
-	char buf[20];
-	struct sha1_ctx ctx;
 
 	if (vcl)
 		guid = vcl->conf.guid;
 	else
 		guid = ddf->anchor.guid;
-
-	sha1_init_ctx(&ctx);
-	sha1_process_bytes(guid, DDF_GUID_LEN, &ctx);
-	sha1_finish_ctx(&ctx, buf);
-	memcpy(uuid, buf, 4*4);
+	uuid_from_ddf_guid(guid, uuid);
 }
 
 static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, char *map);
-- 
1.7.1
