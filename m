From: mwilck@arcor.de
Subject: [PATCH 2/2] DDF: handle fake RAIDs with changing subarray UUIDs
Date: Mon,  9 Sep 2013 20:40:14 +0200
Message-ID: <1378752014-8366-1-git-send-email-mwilck@arcor.de>
References: <522E13EF.3080001@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522E13EF.3080001@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Some fake RAID BIOSes (in particular, LSI ones) change the
VD GUID at every boot. These GUIDs are not suitable for
identifying an array. Luckily the header GUID appears to
remain constant.

We construct a pseudo-UUID from the header GUID and those
properties of the subarray that we expect to remain constant.
This is only array name and index; all else might change e.g.
during grow.

Don't do this for all non-MD arrays, only for those known
to use varying volume GUIDs.

This patch obsoletes my previous patch "DDF: new algorithm
for subarray UUID"

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 72a8351..19d8494 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1583,6 +1583,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 			continue;
 		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
 		ddf->currentconf =&vcl;
+		vcl.vcnum = i;
 		uuid_from_super_ddf(st, info.uuid);
 		fname_from_uuid(st, &info, nbuf1, ':');
 		memcpy(namebuf, ve->name, sizeof(ve->name));
@@ -1682,6 +1683,52 @@ static void detail_super_ddf(struct supertype *st, char *homehost)
 	 */
 }
 
+static const char *vendors_with_variable_volume_UUID[] = {
+	"LSI      ",
+};
+
+static int volume_id_is_reliable(const struct ddf_super *ddf)
+{
+	int n = sizeof(vendors_with_variable_volume_UUID) / 
+		sizeof(vendors_with_variable_volume_UUID[0]);
+	int i;
+	for (i = 0; i < n; i++)
+		if (!memcmp(ddf->controller.guid,
+			vendors_with_variable_volume_UUID[i], 8))
+		return 0;
+	return 1;
+}
+
+static void uuid_of_ddf_subarray(const struct ddf_super *ddf,
+				 unsigned int vcnum, int uuid[4])
+{
+	char buf[DDF_GUID_LEN+18], sha[20], *p;
+	struct sha1_ctx ctx;
+	if (volume_id_is_reliable(ddf)) {
+		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, uuid);
+		return;
+	}
+	/*
+	 * Some fake RAID BIOSes (in particular, LSI ones) change the
+	 * VD GUID at every boot. These GUIDs are not suitable for
+	 * identifying an array. Luckily the header GUID appears to
+	 * remain constant.
+	 * We construct a pseudo-UUID from the header GUID and those
+	 * properties of the subarray that we expect to remain constant.
+	 */
+	memset(buf, 0, sizeof(buf));
+	p = buf;
+	memcpy(p, ddf->anchor.guid, DDF_GUID_LEN);
+	p += DDF_GUID_LEN;
+	memcpy(p, ddf->virt->entries[vcnum].name, 16);
+	p += 16;
+	*((__u16 *) p) = vcnum;
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(buf, sizeof(buf), &ctx);
+	sha1_finish_ctx(&ctx, sha);
+	memcpy(uuid, sha, 4*4);
+}
+
 static void brief_detail_super_ddf(struct supertype *st)
 {
 	struct mdinfo info;
@@ -1693,7 +1740,7 @@ static void brief_detail_super_ddf(struct supertype *st)
 	else if (vcnum == DDF_NOTFOUND)
 		return;
 	else
-		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, info.uuid);
+		uuid_of_ddf_subarray(ddf, vcnum, info.uuid);
 	fname_from_uuid(st, &info, nbuf,':');
 	printf(" UUID=%s", nbuf + 5);
 }
@@ -1836,13 +1883,11 @@ static void uuid_from_super_ddf(struct supertype *st, int uuid[4])
 	 */
 	struct ddf_super *ddf = st->sb;
 	struct vcl *vcl = ddf->currentconf;
-	char *guid;
 
 	if (vcl)
-		guid = vcl->conf.guid;
+		uuid_of_ddf_subarray(ddf, vcl->vcnum, uuid);
 	else
-		guid = ddf->anchor.guid;
-	uuid_from_ddf_guid(guid, uuid);
+		uuid_from_ddf_guid(ddf->anchor.guid, uuid);
 }
 
 static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, char *map);
-- 
1.7.3.4
