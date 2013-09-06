From: mwilck@arcor.de
Subject: [PATCH 2/2] DDF: new algorithm for subarray UUID
Date: Fri,  6 Sep 2013 23:26:21 +0200
Message-ID: <1378502781-849-2-git-send-email-mwilck@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378502781-849-1-git-send-email-mwilck@arcor.de>
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

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   50 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 72a8351..f2b8497 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1682,6 +1682,48 @@ static void detail_super_ddf(struct supertype *st, char *homehost)
 	 */
 }
 
+static void uuid_of_ddf_subarray(const struct ddf_super *ddf,
+				 unsigned int vcnum, int uuid[4])
+{
+	char buf[DDF_GUID_LEN+34], sha[20], *p;
+	struct sha1_ctx ctx;
+	struct vcl *vc;
+	if (memcmp(ddf->controller.guid, T10, 8) == 0) {
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
+	for (vc = ddf->conflist; vc; vc = vc->next)
+		if (memcmp(vc->conf.guid, ddf->virt->entries[vcnum].guid,
+			   DDF_GUID_LEN) == 0)
+			break;
+	if (vc) {
+		memcpy(p, &vc->conf.prim_elmnt_count, 8);
+		*(p+6) = '+'; /* ignore sec_elemnt_seq */
+		p += 8;
+		memcpy(p, &vc->conf.array_blocks, 8);
+		p += 8;
+		*((__u16 *) p) = vcnum;
+	}
+	sha1_init_ctx(&ctx);
+	sha1_process_bytes(buf, sizeof(buf), &ctx);
+	sha1_finish_ctx(&ctx, sha);
+	memcpy(uuid, sha, 4*4);
+}
+
 static void brief_detail_super_ddf(struct supertype *st)
 {
 	struct mdinfo info;
@@ -1693,7 +1735,7 @@ static void brief_detail_super_ddf(struct supertype *st)
 	else if (vcnum == DDF_NOTFOUND)
 		return;
 	else
-		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, info.uuid);
+		uuid_of_ddf_subarray(ddf, vcnum, info.uuid);
 	fname_from_uuid(st, &info, nbuf,':');
 	printf(" UUID=%s", nbuf + 5);
 }
@@ -1836,13 +1878,11 @@ static void uuid_from_super_ddf(struct supertype *st, int uuid[4])
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
