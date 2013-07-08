From: mwilck@arcor.de
Subject: [PATCH 31/39] DDF: implement kill_subarray
Date: Mon,  8 Jul 2013 23:50:40 +0200
Message-ID: <1373320248-7520-5-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Implement kill_subarray, for mdmon running and not running.

The way Kill_subarray() is implemented, this requires that the
DDF layer uses "currentconf" to remember the last subarray
queried with container_content(), and use it as the one to kill.
I don't like this much but IMSM does it the same way.
---
 super-ddf.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 87584fa..ee4652a 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3616,7 +3616,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 
 		ddf->currentconf = vc;
 		uuid_from_super_ddf(st, this->uuid);
-		ddf->currentconf = NULL;
+		if (!subarray)
+			ddf->currentconf = NULL;
 
 		sprintf(this->text_version, "/%s/%d",
 			st->container_devnm, this->container_member);
@@ -4160,6 +4161,88 @@ static void ddf_sync_metadata(struct supertype *st)
 	dprintf("ddf: sync_metadata\n");
 }
 
+static int del_from_conflist(struct vcl **list, const char *guid)
+{
+	struct vcl **p;
+	int found = 0;
+	for (p = list; p && *p; p = &((*p)->next))
+		if (!memcmp((*p)->conf.guid, guid, DDF_GUID_LEN)) {
+			found = 1;
+			*p = (*p)->next;
+		}
+	return found;
+}
+
+static int _kill_subarray_ddf(struct ddf_super *ddf, const char *guid)
+{
+	struct dl *dl;
+	unsigned int vdnum, i;
+	vdnum = find_vde_by_guid(ddf, guid);
+	if (vdnum == DDF_NOTFOUND) {
+		pr_err("%s: could not find VD %s\n", __func__,
+		       guid_str(guid));
+		return -1;
+	}
+	if (del_from_conflist(&ddf->conflist, guid) == 0) {
+		pr_err("%s: could not find conf %s\n", __func__,
+		       guid_str(guid));
+		return -1;
+	}
+	for (dl = ddf->dlist; dl; dl = dl->next)
+		for (i = 0; i < ddf->max_part; i++)
+			if (dl->vlist[i] != NULL &&
+			    !memcmp(dl->vlist[i]->conf.guid, guid,
+				    DDF_GUID_LEN))
+				dl->vlist[i] = NULL;
+	memset(ddf->virt->entries[vdnum].guid, 0xff, DDF_GUID_LEN);
+	dprintf("%s: deleted %s\n", __func__, guid_str(guid));
+	return 0;
+}
+
+static int kill_subarray_ddf(struct supertype *st)
+{
+	struct ddf_super *ddf = st->sb;
+	/*
+	 *  currentconf is set in container_content_ddf,
+	 *  called with subarray arg
+	 */
+	struct vcl *victim = ddf->currentconf;
+	struct vd_config *conf;
+	ddf->currentconf = NULL;
+	unsigned int vdnum;
+	if (!victim) {
+		pr_err("%s: nothing to kill\n", __func__);
+		return -1;
+	}
+	conf = &victim->conf;
+	vdnum = find_vde_by_guid(ddf, conf->guid);
+	if (vdnum == DDF_NOTFOUND) {
+		pr_err("%s: could not find VD %s\n", __func__,
+		       guid_str(conf->guid));
+		return -1;
+	}
+	if (st->update_tail) {
+		struct virtual_disk *vd;
+		int len = sizeof(struct virtual_disk)
+			+ sizeof(struct virtual_entry);
+		vd = xmalloc(len);
+		if (vd == NULL) {
+			pr_err("%s: failed to allocate %d bytes\n", __func__,
+			       len);
+			return -1;
+		}
+		memset(vd, 0 , len);
+		vd->magic = DDF_VIRT_RECORDS_MAGIC;
+		vd->populated_vdes = 0;
+		memcpy(vd->entries[0].guid, conf->guid, DDF_GUID_LEN);
+		/* we use DDF_state_deleted as marker */
+		vd->entries[0].state = DDF_state_deleted;
+		append_metadata_update(st, vd, len);
+	} else
+		_kill_subarray_ddf(ddf, conf->guid);
+	return 0;
+}
+
 static void ddf_process_update(struct supertype *st,
 			       struct metadata_update *update)
 {
@@ -4262,12 +4345,20 @@ static void ddf_process_update(struct supertype *st,
 			return;
 		vd = (struct virtual_disk*)update->buf;
 
-		ent = find_unused_vde(ddf);
-		if (ent == DDF_NOTFOUND)
-			return;
-		ddf->virt->entries[ent] = vd->entries[0];
-		ddf->virt->populated_vdes = __cpu_to_be16(1 +
-							  __be16_to_cpu(ddf->virt->populated_vdes));
+		if (vd->entries[0].state == DDF_state_deleted) {
+			if (_kill_subarray_ddf(ddf, vd->entries[0].guid))
+				return;
+		} else {
+
+			ent = find_unused_vde(ddf);
+			if (ent == DDF_NOTFOUND)
+				return;
+			ddf->virt->entries[ent] = vd->entries[0];
+			ddf->virt->populated_vdes =
+				__cpu_to_be16(
+					1 + __be16_to_cpu(
+						ddf->virt->populated_vdes));
+		}
 		ddf_set_updates_pending(ddf);
 		break;
 
@@ -4700,6 +4791,7 @@ struct superswitch super_ddf = {
 	.match_metadata_desc = match_metadata_desc_ddf,
 	.container_content = container_content_ddf,
 	.default_geometry = default_geometry_ddf,
+	.kill_subarray  = kill_subarray_ddf,
 
 	.external	= 1,
 
-- 
1.7.1
