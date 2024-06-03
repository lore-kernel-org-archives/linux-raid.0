Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E17313C8EE
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451777; cv=none; b=UPDeqH2WJAjmNCRCYaWF3tpdoBeUzaSKlpqw17HbRK/ksglcCVlWr0DFL7M4pAzgrdtreEcQ7GiogZ3WIAxe8oF/pHGKt+0m/YwjSS6X6R46sTbczVNd8EoE/ngNbf1XTiHLJdzqt1KlafdnZDVQ2IkTdSOgsUlbvt/PIZPtXD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451777; c=relaxed/simple;
	bh=8VN8rHvNdibQZIlOzG5CL5fZogH1j8dlvBaucm86ZWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbpdO3lqI23l6yJms2Q6YjjNzsq0BRTi6sHyLOJ8JsTvHeJWLNQsOgj08ECkb4o9Ykwh73YBtszu+0g+gpCYAidJEYpG5QAyFHvfrSSpy8AChb1u4+70AmwMAyOqmM+lfLR8Sd5YY3jV5Aey0hDQu2X3fD0GRWgIJXSBpExRZlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjIWa+as; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjIWa+as"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD2QdUGRGy/WQ0xdwXtPyoZNp2ZFa9L95x9zV5tTgkk=;
	b=FjIWa+as9//ww+PTnzCZQ7P18xx9sqhFpK9iW7xqiRSLGfb3JOMDIDAwbWYTQXnPVDhNEN
	pexFBe7MvBVBtnpsCpRr34Io7PhaC8z/CEWxuDnVAGjytR1JrOqHXump/JiliQheNG8ouj
	2JFfIkBQi7ePM4mRijFv+I1/2v80E08=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-bdlEwSYLP9G0UB0WbC2qvQ-1; Mon,
 03 Jun 2024 17:56:09 -0400
X-MC-Unique: bdlEwSYLP9G0UB0WbC2qvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE7F71C0512B;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E6E7200E566;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 2/8] dlm: remove struct field with the same meaning
Date: Mon,  3 Jun 2024 17:55:52 -0400
Message-ID: <20240603215558.2722969-3-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-1-aahringo@redhat.com>
References: <20240603215558.2722969-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

There is currently "res_nodeid" and "res_master_nodeid" fields in
"struct dlm_rsb". At some point a developer does not know when to use
which one or forget to update one and they are out of sync. This patch
removes the "res_nodeid" and allows "res_master_nodeid" only. They have
different representation values about their invalid values, the
"res_master_nodeid" seems to be the modern way of represent the actual
master nodeid and actually use the nodeid value when the own nodeid is
the master (on res_nodeid the 0 represented this value). Also the modern
nodeid representation fits into a "unsigned" range as this avoids to
convert negative values over the network. The old value representation
is still part of the DLM networking protocol that's why the conversion
functions dlm_res_nodeid() and dlm_res_master_nodeid() are still
present. On a new major DLM version bump protocol the nodeid representation
should be updated to the modern value representation. These conversion
functions also applies for existing UAPI and the user space still
assumes the old "res_nodeid" value representation.

The same arguments applies to "lkb_nodeid" and "lkb_master_nodeid"
wheras this is also only a copied value from another lkb related field
"lkb_resource" and it's "res_master_nodeid" value. In this case it
requires more code review because "lkb_resource" is not set sometimes.

This patch so far makes the code easier to read and understandable
because we don't have several fields with the same meaning in some
structs. In case of the previously "res_nodeid" value, sometimes an
additional check on our_nodeid() is required to set the value to 0 that
represents in this value representation that we are the master node.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/debug_fs.c     |  33 +++++-----
 fs/dlm/dlm_internal.h |  33 ++++++++--
 fs/dlm/lock.c         | 144 ++++++++++++++++++------------------------
 fs/dlm/lock.h         |   5 +-
 fs/dlm/lockspace.c    |   2 +-
 fs/dlm/rcom.c         |   4 +-
 fs/dlm/recover.c      |  20 ++----
 fs/dlm/recoverd.c     |   2 +-
 8 files changed, 119 insertions(+), 124 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 6ab3ed4074c6..40eb1696f3b6 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -58,9 +58,10 @@ static void print_format1_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	    lkb->lkb_status == DLM_LKSTS_WAITING)
 		seq_printf(s, " (%s)", print_lockmode(lkb->lkb_rqmode));
 
-	if (lkb->lkb_nodeid) {
-		if (lkb->lkb_nodeid != res->res_nodeid)
-			seq_printf(s, " Remote: %3d %08x", lkb->lkb_nodeid,
+	if (lkb->lkb_master_nodeid != dlm_our_nodeid()) {
+		if (lkb->lkb_master_nodeid != res->res_master_nodeid)
+			seq_printf(s, " Remote: %3d %08x",
+				   dlm_res_nodeid(lkb->lkb_master_nodeid),
 				   lkb->lkb_remid);
 		else
 			seq_printf(s, " Master:     %08x", lkb->lkb_remid);
@@ -88,16 +89,15 @@ static void print_format1(struct dlm_rsb *res, struct seq_file *s)
 			seq_printf(s, "%c", '.');
 	}
 
-	if (res->res_nodeid > 0)
-		seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
-			   res->res_nodeid);
-	else if (res->res_nodeid == 0)
-		seq_puts(s, "\"\nMaster Copy\n");
-	else if (res->res_nodeid == -1)
+
+	if (res->res_master_nodeid == 0)
 		seq_printf(s, "\"\nLooking up master (lkid %x)\n",
 			   res->res_first_lkid);
+	else if (res->res_master_nodeid == dlm_our_nodeid())
+		seq_puts(s, "\"\nMaster Copy\n");
 	else
-		seq_printf(s, "\"\nInvalid master %d\n", res->res_nodeid);
+		seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
+			   res->res_master_nodeid);
 	if (seq_has_overflowed(s))
 		goto out;
 
@@ -184,7 +184,7 @@ static void print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
 
 	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
 		   lkb->lkb_id,
-		   lkb->lkb_nodeid,
+		   dlm_res_nodeid(lkb->lkb_master_nodeid),
 		   lkb->lkb_remid,
 		   lkb->lkb_ownpid,
 		   (unsigned long long)xid,
@@ -194,7 +194,7 @@ static void print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
 		   lkb->lkb_grmode,
 		   lkb->lkb_rqmode,
 		   (unsigned long long)us,
-		   r->res_nodeid,
+		   dlm_res_nodeid(r->res_master_nodeid),
 		   r->res_length,
 		   r->res_name);
 }
@@ -238,7 +238,7 @@ static void print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
 
 	seq_printf(s, "lkb %x %d %x %u %llu %x %x %d %d %d %d %d %d %u %llu %llu\n",
 		   lkb->lkb_id,
-		   lkb->lkb_nodeid,
+		   dlm_res_nodeid(lkb->lkb_master_nodeid),
 		   lkb->lkb_remid,
 		   lkb->lkb_ownpid,
 		   (unsigned long long)xid,
@@ -265,7 +265,7 @@ static void print_format3(struct dlm_rsb *r, struct seq_file *s)
 
 	seq_printf(s, "rsb %p %d %x %lx %d %d %u %d ",
 		   r,
-		   r->res_nodeid,
+		   dlm_res_nodeid(r->res_master_nodeid),
 		   r->res_first_lkid,
 		   r->res_flags,
 		   !list_empty(&r->res_root_list),
@@ -341,7 +341,7 @@ static void print_format4(struct dlm_rsb *r, struct seq_file *s)
 
 	seq_printf(s, "rsb %p %d %d %d %d %lu %lx %d ",
 		   r,
-		   r->res_nodeid,
+		   dlm_res_nodeid(r->res_master_nodeid),
 		   r->res_master_nodeid,
 		   r->res_dir_nodeid,
 		   our_nodeid,
@@ -611,7 +611,8 @@ static ssize_t waiters_read(struct file *file, char __user *userbuf,
 	list_for_each_entry(lkb, &ls->ls_waiters, lkb_wait_reply) {
 		ret = snprintf(debug_buf + pos, len - pos, "%x %d %d %s\n",
 			       lkb->lkb_id, lkb->lkb_wait_type,
-			       lkb->lkb_nodeid, lkb->lkb_resource->res_name);
+			       dlm_res_nodeid(lkb->lkb_master_nodeid),
+			       lkb->lkb_resource->res_name);
 		if (ret >= len - pos)
 			break;
 		pos += ret;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 6f578527c6d8..2c7ad3c5e893 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -253,7 +253,7 @@ struct dlm_callback {
 struct dlm_lkb {
 	struct dlm_rsb		*lkb_resource;	/* the rsb */
 	struct kref		lkb_ref;
-	int			lkb_nodeid;	/* copied from rsb */
+	unsigned int		lkb_master_nodeid;	/* copied from rsb */
 	int			lkb_ownpid;	/* pid of lock owner */
 	uint32_t		lkb_id;		/* our lock ID */
 	uint32_t		lkb_remid;	/* lock ID on remote partner */
@@ -303,18 +303,41 @@ struct dlm_lkb {
  *
  * res_nodeid is "odd": -1 is unset/invalid, zero means our_nodeid,
  * greater than zero when another nodeid.
- *
- * (TODO: remove res_nodeid and only use res_master_nodeid)
  */
 
+/* For backwards compatibility, see above.
+ * The protocol is still using res_nodeid.
+ */
+static inline int dlm_res_nodeid(unsigned int res_master_nodeid)
+{
+	if (res_master_nodeid == 0)
+		return -1;
+	else if (res_master_nodeid == dlm_our_nodeid())
+		return 0;
+	else
+		return res_master_nodeid;
+}
+
+/* For backwards compatibility, see above.
+ * The protocol is still using res_nodeid.
+ */
+static inline unsigned int dlm_res_master_nodeid(int res_nodeid)
+{
+	if (res_nodeid == -1)
+		return 0;
+	else if (res_nodeid == 0)
+		return dlm_our_nodeid();
+	else
+		return res_nodeid;
+}
+
 struct dlm_rsb {
 	struct dlm_ls		*res_ls;	/* the lockspace */
 	struct kref		res_ref;
 	spinlock_t		res_lock;
 	unsigned long		res_flags;
 	int			res_length;	/* length of rsb name */
-	int			res_nodeid;
-	int			res_master_nodeid;
+	unsigned int		res_master_nodeid;
 	int			res_dir_nodeid;
 	unsigned long		res_id;		/* for ls_recover_xa */
 	uint32_t                res_lvbseq;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index e1e990b09068..3195d0b96c74 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -160,21 +160,19 @@ static const int __quecvt_compat_matrix[8][8] = {
 
 void dlm_print_lkb(struct dlm_lkb *lkb)
 {
-	printk(KERN_ERR "lkb: nodeid %d id %x remid %x exflags %x flags %x "
+	pr_err("lkb: master_nodeid %d id %x remid %x exflags %x flags %x "
 	       "sts %d rq %d gr %d wait_type %d wait_nodeid %d seq %llu\n",
-	       lkb->lkb_nodeid, lkb->lkb_id, lkb->lkb_remid, lkb->lkb_exflags,
-	       dlm_iflags_val(lkb), lkb->lkb_status, lkb->lkb_rqmode,
-	       lkb->lkb_grmode, lkb->lkb_wait_type, lkb->lkb_wait_nodeid,
-	       (unsigned long long)lkb->lkb_recover_seq);
+	       lkb->lkb_master_nodeid, lkb->lkb_id, lkb->lkb_remid,
+	       lkb->lkb_exflags, dlm_iflags_val(lkb), lkb->lkb_status,
+	       lkb->lkb_rqmode, lkb->lkb_grmode, lkb->lkb_wait_type,
+	       lkb->lkb_wait_nodeid, (unsigned long long)lkb->lkb_recover_seq);
 }
 
 static void dlm_print_rsb(struct dlm_rsb *r)
 {
-	printk(KERN_ERR "rsb: nodeid %d master %d dir %d flags %lx first %x "
-	       "rlc %d name %s\n",
-	       r->res_nodeid, r->res_master_nodeid, r->res_dir_nodeid,
-	       r->res_flags, r->res_first_lkid, r->res_recover_locks_count,
-	       r->res_name);
+	pr_err("rsb: master %d dir %d flags %lx first %x rlc %d name %s\n",
+	       r->res_master_nodeid, r->res_dir_nodeid, r->res_flags,
+	       r->res_first_lkid, r->res_recover_locks_count, r->res_name);
 }
 
 void dlm_dump_rsb(struct dlm_rsb *r)
@@ -243,13 +241,13 @@ static inline int is_granted(struct dlm_lkb *lkb)
 
 static inline int is_remote(struct dlm_rsb *r)
 {
-	DLM_ASSERT(r->res_nodeid >= 0, dlm_print_rsb(r););
-	return !!r->res_nodeid;
+	DLM_ASSERT(r->res_master_nodeid != 0, dlm_print_rsb(r););
+	return r->res_master_nodeid != dlm_our_nodeid();
 }
 
 static inline int is_process_copy(struct dlm_lkb *lkb)
 {
-	return lkb->lkb_nodeid &&
+	return lkb->lkb_master_nodeid != dlm_our_nodeid() &&
 	       !test_bit(DLM_IFL_MSTCPY_BIT, &lkb->lkb_iflags);
 }
 
@@ -832,7 +830,6 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 		dlm_print_rsb(r);
 		/* fix it and go on */
 		r->res_master_nodeid = our_nodeid;
-		r->res_nodeid = 0;
 		rsb_clear_flag(r, RSB_MASTER_UNCERTAIN);
 		r->res_first_lkid = 0;
 	}
@@ -878,7 +875,6 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 		log_debug(ls, "find_rsb new from_dir %d recreate %s",
 			  from_nodeid, r->res_name);
 		r->res_master_nodeid = our_nodeid;
-		r->res_nodeid = 0;
 		goto out_add;
 	}
 
@@ -901,11 +897,9 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 		/* When we are the dir nodeid, we can set the master
 		   node immediately */
 		r->res_master_nodeid = our_nodeid;
-		r->res_nodeid = 0;
 	} else {
 		/* set_master will send_lookup to dir_nodeid */
 		r->res_master_nodeid = 0;
-		r->res_nodeid = -1;
 	}
 
  out_add:
@@ -1022,7 +1016,6 @@ static int find_rsb_nodir(struct dlm_ls *ls, const void *name, int len,
 			  our_nodeid, r->res_master_nodeid, dir_nodeid);
 		dlm_print_rsb(r);
 		r->res_master_nodeid = our_nodeid;
-		r->res_nodeid = 0;
 	}
 
 	list_move(&r->res_rsbs_list, &ls->ls_keep);
@@ -1050,7 +1043,6 @@ static int find_rsb_nodir(struct dlm_ls *ls, const void *name, int len,
 	r->res_hash = hash;
 	r->res_dir_nodeid = dir_nodeid;
 	r->res_master_nodeid = dir_nodeid;
-	r->res_nodeid = (dir_nodeid == our_nodeid) ? 0 : dir_nodeid;
 	kref_init(&r->res_ref);
 
 	write_lock_bh(&ls->ls_rsbtbl_lock);
@@ -1130,7 +1122,8 @@ static int validate_master_nodeid(struct dlm_ls *ls, struct dlm_rsb *r,
 		return -ENOTBLK;
 	} else {
 		/* our rsb is not master, but the dir nodeid has sent us a
-	   	   request; this could happen with master 0 / res_nodeid -1 */
+		 * request; this could happen with res_master_nodeid 0
+		 */
 
 		if (r->res_master_nodeid) {
 			log_error(ls, "validate master from_dir %d master %d "
@@ -1140,7 +1133,6 @@ static int validate_master_nodeid(struct dlm_ls *ls, struct dlm_rsb *r,
 		}
 
 		r->res_master_nodeid = dlm_our_nodeid();
-		r->res_nodeid = 0;
 		return 0;
 	}
 }
@@ -1163,11 +1155,10 @@ static void __dlm_master_lookup(struct dlm_ls *ls, struct dlm_rsb *r, int our_no
 		/* Recovery uses this function to set a new master when
 		 * the previous master failed.  Setting NEW_MASTER will
 		 * force dlm_recover_masters to call recover_master on this
-		 * rsb even though the res_nodeid is no longer removed.
+		 * rsb even though the res_master_nodeid is no longer removed.
 		 */
 
 		r->res_master_nodeid = from_nodeid;
-		r->res_nodeid = from_nodeid;
 		rsb_set_flag(r, RSB_NEW_MASTER);
 
 		if (toss_list) {
@@ -1183,9 +1174,9 @@ static void __dlm_master_lookup(struct dlm_ls *ls, struct dlm_rsb *r, int our_no
 		 * cycle before recovering this master value
 		 */
 
-		log_limit(ls, "%s from_master %d master_nodeid %d res_nodeid %d first %x %s",
+		log_limit(ls, "%s from_master %d master_nodeid %d first %x %s",
 			  __func__, from_nodeid, r->res_master_nodeid,
-			  r->res_nodeid, r->res_first_lkid, r->res_name);
+			  r->res_first_lkid, r->res_name);
 
 		if (r->res_master_nodeid == our_nodeid) {
 			log_error(ls, "from_master %d our_master", from_nodeid);
@@ -1194,7 +1185,6 @@ static void __dlm_master_lookup(struct dlm_ls *ls, struct dlm_rsb *r, int our_no
 		}
 
 		r->res_master_nodeid = from_nodeid;
-		r->res_nodeid = from_nodeid;
 		rsb_set_flag(r, RSB_NEW_MASTER);
 	}
 
@@ -1206,7 +1196,6 @@ static void __dlm_master_lookup(struct dlm_ls *ls, struct dlm_rsb *r, int our_no
 		log_debug(ls, "%s master 0 to %d first %x %s", __func__,
 			  from_nodeid, r->res_first_lkid, r->res_name);
 		r->res_master_nodeid = from_nodeid;
-		r->res_nodeid = from_nodeid;
 	}
 
 	if (!from_master && !fix_master &&
@@ -1371,7 +1360,7 @@ static int _dlm_master_lookup(struct dlm_ls *ls, int from_nodeid,
 	r->res_hash = hash;
 	r->res_dir_nodeid = our_nodeid;
 	r->res_master_nodeid = from_nodeid;
-	r->res_nodeid = from_nodeid;
+	kref_init(&r->res_ref);
 	rsb_set_flag(r, RSB_TOSS);
 
 	write_lock_bh(&ls->ls_rsbtbl_lock);
@@ -1523,7 +1512,6 @@ static int _create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret,
 	lkb->lkb_last_bast_cb_mode = DLM_LOCK_IV;
 	lkb->lkb_last_cast_cb_mode = DLM_LOCK_IV;
 	lkb->lkb_last_cb_mode = DLM_LOCK_IV;
-	lkb->lkb_nodeid = -1;
 	lkb->lkb_grmode = DLM_LOCK_IV;
 	kref_init(&lkb->lkb_ref);
 	INIT_LIST_HEAD(&lkb->lkb_ownqueue);
@@ -2485,8 +2473,9 @@ static int grant_pending_convert(struct dlm_rsb *r, int high, int *cw,
 		}
 
 		if (!demoted && is_demoted(lkb)) {
-			log_print("WARN: pending demoted %x node %d %s",
-				  lkb->lkb_id, lkb->lkb_nodeid, r->res_name);
+			log_print("WARN: pending demoted %x master_node %d %s",
+				  lkb->lkb_id, lkb->lkb_master_nodeid,
+				  r->res_name);
 			demote_restart = 1;
 			continue;
 		}
@@ -2504,7 +2493,7 @@ static int grant_pending_convert(struct dlm_rsb *r, int high, int *cw,
 				}
 			} else {
 				log_print("WARN: pending deadlock %x node %d %s",
-					  lkb->lkb_id, lkb->lkb_nodeid,
+					  lkb->lkb_id, lkb->lkb_master_nodeid,
 					  r->res_name);
 				dlm_dump_rsb(r);
 			}
@@ -2573,7 +2562,8 @@ static void grant_pending_locks(struct dlm_rsb *r, unsigned int *count)
 	int cw = 0;
 
 	if (!is_master(r)) {
-		log_print("grant_pending_locks r nodeid %d", r->res_nodeid);
+		log_print("%s r master_nodeid %d", __func__,
+			  r->res_master_nodeid);
 		dlm_dump_rsb(r);
 		return;
 	}
@@ -2669,7 +2659,7 @@ static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	if (rsb_flag(r, RSB_MASTER_UNCERTAIN)) {
 		rsb_clear_flag(r, RSB_MASTER_UNCERTAIN);
 		r->res_first_lkid = lkb->lkb_id;
-		lkb->lkb_nodeid = r->res_nodeid;
+		lkb->lkb_master_nodeid = r->res_master_nodeid;
 		return 0;
 	}
 
@@ -2678,13 +2668,8 @@ static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		return 1;
 	}
 
-	if (r->res_master_nodeid == our_nodeid) {
-		lkb->lkb_nodeid = 0;
-		return 0;
-	}
-
 	if (r->res_master_nodeid) {
-		lkb->lkb_nodeid = r->res_master_nodeid;
+		lkb->lkb_master_nodeid = r->res_master_nodeid;
 		return 0;
 	}
 
@@ -2699,8 +2684,7 @@ static int set_master(struct dlm_rsb *r, struct dlm_lkb *lkb)
 			  lkb->lkb_id, r->res_master_nodeid, r->res_dir_nodeid,
 			  r->res_name);
 		r->res_master_nodeid = our_nodeid;
-		r->res_nodeid = 0;
-		lkb->lkb_nodeid = 0;
+		lkb->lkb_master_nodeid = our_nodeid;
 		return 0;
 	}
 
@@ -2897,7 +2881,7 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 /* when dlm_unlock() sees -EBUSY with CANCEL/FORCEUNLOCK it returns 0
    for success */
 
-/* note: it's valid for lkb_nodeid/res_nodeid to be -1 when we get here
+/* note: it's valid for lkb_master_nodeid/res_master_nodeid to be 0 when we get here
    because there may be a lookup in progress and it's valid to do
    cancel/unlockf on it */
 
@@ -3578,7 +3562,7 @@ static int send_message(struct dlm_mhandle *mh, struct dlm_message *ms,
 static void send_args(struct dlm_rsb *r, struct dlm_lkb *lkb,
 		      struct dlm_message *ms)
 {
-	ms->m_nodeid   = cpu_to_le32(lkb->lkb_nodeid);
+	ms->m_nodeid   = cpu_to_le32(dlm_res_nodeid(lkb->lkb_master_nodeid));
 	ms->m_pid      = cpu_to_le32(lkb->lkb_ownpid);
 	ms->m_lkid     = cpu_to_le32(lkb->lkb_id);
 	ms->m_remid    = cpu_to_le32(lkb->lkb_remid);
@@ -3625,7 +3609,7 @@ static int send_common(struct dlm_rsb *r, struct dlm_lkb *lkb, int mstype)
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	to_nodeid = r->res_nodeid;
+	to_nodeid = r->res_master_nodeid;
 
 	error = add_to_waiters(lkb, mstype, to_nodeid);
 	if (error)
@@ -3689,7 +3673,7 @@ static int send_grant(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	to_nodeid = lkb->lkb_nodeid;
+	to_nodeid = lkb->lkb_master_nodeid;
 
 	error = create_message(r, lkb, to_nodeid, DLM_MSG_GRANT, &ms, &mh);
 	if (error)
@@ -3710,7 +3694,7 @@ static int send_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int mode)
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	to_nodeid = lkb->lkb_nodeid;
+	to_nodeid = lkb->lkb_master_nodeid;
 
 	error = create_message(r, NULL, to_nodeid, DLM_MSG_BAST, &ms, &mh);
 	if (error)
@@ -3780,7 +3764,7 @@ static int send_common_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	struct dlm_mhandle *mh;
 	int to_nodeid, error;
 
-	to_nodeid = lkb->lkb_nodeid;
+	to_nodeid = lkb->lkb_master_nodeid;
 
 	error = create_message(r, lkb, to_nodeid, mstype, &ms, &mh);
 	if (error)
@@ -3896,7 +3880,7 @@ static void fake_astfn(void *astparam)
 static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				const struct dlm_message *ms)
 {
-	lkb->lkb_nodeid = le32_to_cpu(ms->m_header.h_nodeid);
+	lkb->lkb_master_nodeid = dlm_res_master_nodeid(le32_to_cpu(ms->m_header.h_nodeid));
 	lkb->lkb_ownpid = le32_to_cpu(ms->m_pid);
 	lkb->lkb_remid = le32_to_cpu(ms->m_lkid);
 	lkb->lkb_grmode = DLM_LOCK_IV;
@@ -3944,7 +3928,7 @@ static int receive_unlock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 static void setup_local_lkb(struct dlm_ls *ls, const struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb = &ls->ls_local_lkb;
-	lkb->lkb_nodeid = le32_to_cpu(ms->m_header.h_nodeid);
+	lkb->lkb_master_nodeid = dlm_res_master_nodeid(le32_to_cpu(ms->m_header.h_nodeid));
 	lkb->lkb_remid = le32_to_cpu(ms->m_lkid);
 }
 
@@ -3969,7 +3953,7 @@ static int validate_message(struct dlm_lkb *lkb, const struct dlm_message *ms)
 	case cpu_to_le32(DLM_MSG_CONVERT):
 	case cpu_to_le32(DLM_MSG_UNLOCK):
 	case cpu_to_le32(DLM_MSG_CANCEL):
-		if (!is_master_copy(lkb) || lkb->lkb_nodeid != from)
+		if (!is_master_copy(lkb) || lkb->lkb_master_nodeid != from)
 			error = -EINVAL;
 		break;
 
@@ -3978,14 +3962,14 @@ static int validate_message(struct dlm_lkb *lkb, const struct dlm_message *ms)
 	case cpu_to_le32(DLM_MSG_CANCEL_REPLY):
 	case cpu_to_le32(DLM_MSG_GRANT):
 	case cpu_to_le32(DLM_MSG_BAST):
-		if (!is_process_copy(lkb) || lkb->lkb_nodeid != from)
+		if (!is_process_copy(lkb) || lkb->lkb_master_nodeid != from)
 			error = -EINVAL;
 		break;
 
 	case cpu_to_le32(DLM_MSG_REQUEST_REPLY):
 		if (!is_process_copy(lkb))
 			error = -EINVAL;
-		else if (lkb->lkb_nodeid != -1 && lkb->lkb_nodeid != from)
+		else if (lkb->lkb_master_nodeid != 0 && lkb->lkb_master_nodeid != from)
 			error = -EINVAL;
 		break;
 
@@ -3999,7 +3983,7 @@ static int validate_message(struct dlm_lkb *lkb, const struct dlm_message *ms)
 			  "ignore invalid message %d from %d %x %x %x %d",
 			  le32_to_cpu(ms->m_type), from, lkb->lkb_id,
 			  lkb->lkb_remid, dlm_iflags_val(lkb),
-			  lkb->lkb_nodeid);
+			  lkb->lkb_master_nodeid);
 	return error;
 }
 
@@ -4425,8 +4409,7 @@ static int receive_request_reply(struct dlm_ls *ls,
 	   lookup as a request and sent request reply instead of lookup reply */
 	if (mstype == DLM_MSG_LOOKUP) {
 		r->res_master_nodeid = from_nodeid;
-		r->res_nodeid = from_nodeid;
-		lkb->lkb_nodeid = from_nodeid;
+		lkb->lkb_master_nodeid = from_nodeid;
 	}
 
 	/* this is the value returned from do_request() on the master */
@@ -4468,8 +4451,7 @@ static int receive_request_reply(struct dlm_ls *ls,
 		    r->res_master_nodeid != dlm_our_nodeid()) {
 			/* cause _request_lock->set_master->send_lookup */
 			r->res_master_nodeid = 0;
-			r->res_nodeid = -1;
-			lkb->lkb_nodeid = -1;
+			lkb->lkb_master_nodeid = 0;
 		}
 
 		if (is_overlap(lkb)) {
@@ -4743,7 +4725,6 @@ static void receive_lookup_reply(struct dlm_ls *ls,
 
 	if (ret_nodeid == dlm_our_nodeid()) {
 		r->res_master_nodeid = ret_nodeid;
-		r->res_nodeid = 0;
 		do_lookup_list = 1;
 		r->res_first_lkid = 0;
 	} else if (ret_nodeid == -1) {
@@ -4751,12 +4732,10 @@ static void receive_lookup_reply(struct dlm_ls *ls,
 		log_error(ls, "receive_lookup_reply %x from %d bad ret_nodeid",
 			  lkb->lkb_id, le32_to_cpu(ms->m_header.h_nodeid));
 		r->res_master_nodeid = 0;
-		r->res_nodeid = -1;
-		lkb->lkb_nodeid = -1;
+		lkb->lkb_master_nodeid = 0;
 	} else {
-		/* set_master() will set lkb_nodeid from r */
+		/* set_master() will set lkb_master_nodeid from r */
 		r->res_master_nodeid = ret_nodeid;
-		r->res_nodeid = ret_nodeid;
 	}
 
 	if (is_overlap(lkb)) {
@@ -5023,7 +5002,7 @@ static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb,
 		memset(ms_local, 0, sizeof(struct dlm_message));
 		ms_local->m_type = cpu_to_le32(DLM_MSG_CONVERT_REPLY);
 		ms_local->m_result = cpu_to_le32(to_dlm_errno(-EINPROGRESS));
-		ms_local->m_header.h_nodeid = cpu_to_le32(lkb->lkb_nodeid);
+		ms_local->m_header.h_nodeid = cpu_to_le32(dlm_res_nodeid(lkb->lkb_master_nodeid));
 		_receive_convert_reply(lkb, ms_local, true);
 
 		/* Same special case as in receive_rcom_lock_args() */
@@ -5079,13 +5058,12 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 		   many and they aren't very interesting */
 
 		if (lkb->lkb_wait_type != DLM_MSG_UNLOCK) {
-			log_debug(ls, "waiter %x remote %x msg %d r_nodeid %d "
-				  "lkb_nodeid %d wait_nodeid %d dir_nodeid %d",
+			log_debug(ls, "waiter %x remote %x msg %d master_nodeid %d lkb_master_nodeid %d wait_nodeid %d dir_nodeid %d",
 				  lkb->lkb_id,
 				  lkb->lkb_remid,
 				  lkb->lkb_wait_type,
-				  lkb->lkb_resource->res_nodeid,
-				  lkb->lkb_nodeid,
+				  lkb->lkb_resource->res_master_nodeid,
+				  lkb->lkb_master_nodeid,
 				  lkb->lkb_wait_nodeid,
 				  dir_nodeid);
 		}
@@ -5142,7 +5120,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 			memset(ms_local, 0, sizeof(struct dlm_message));
 			ms_local->m_type = cpu_to_le32(DLM_MSG_UNLOCK_REPLY);
 			ms_local->m_result = cpu_to_le32(to_dlm_errno(local_unlock_result));
-			ms_local->m_header.h_nodeid = cpu_to_le32(lkb->lkb_nodeid);
+			ms_local->m_header.h_nodeid = cpu_to_le32(dlm_res_nodeid(lkb->lkb_master_nodeid));
 			_receive_unlock_reply(lkb, ms_local, true);
 			dlm_put_lkb(lkb);
 			break;
@@ -5152,7 +5130,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 			memset(ms_local, 0, sizeof(struct dlm_message));
 			ms_local->m_type = cpu_to_le32(DLM_MSG_CANCEL_REPLY);
 			ms_local->m_result = cpu_to_le32(to_dlm_errno(local_cancel_result));
-			ms_local->m_header.h_nodeid = cpu_to_le32(lkb->lkb_nodeid);
+			ms_local->m_header.h_nodeid = cpu_to_le32(dlm_res_nodeid(lkb->lkb_master_nodeid));
 			_receive_cancel_reply(lkb, ms_local, true);
 			dlm_put_lkb(lkb);
 			break;
@@ -5248,11 +5226,10 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 					&lkb->lkb_iflags);
 		err = 0;
 
-		log_debug(ls, "waiter %x remote %x msg %d r_nodeid %d "
-			  "lkb_nodeid %d wait_nodeid %d dir_nodeid %d "
-			  "overlap %d %d", lkb->lkb_id, lkb->lkb_remid, mstype,
-			  r->res_nodeid, lkb->lkb_nodeid, lkb->lkb_wait_nodeid,
-			  dlm_dir_nodeid(r), oc, ou);
+		log_debug(ls, "waiter %x remote %x msg %d master_nodeid %d lkb_master_nodeid %d wait_nodeid %d dir_nodeid %d overlap %d %d",
+			  lkb->lkb_id, lkb->lkb_remid, mstype,
+			  r->res_master_nodeid, lkb->lkb_master_nodeid,
+			  lkb->lkb_wait_nodeid, dlm_dir_nodeid(r), oc, ou);
 
 		/*
 		 * No reply to the pre-recovery operation will now be received,
@@ -5325,9 +5302,9 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 		}
 
 		if (err) {
-			log_error(ls, "waiter %x msg %d r_nodeid %d "
+			log_error(ls, "waiter %x msg %d master_nodeid %d "
 				  "dir_nodeid %d overlap %d %d",
-				  lkb->lkb_id, mstype, r->res_nodeid,
+				  lkb->lkb_id, mstype, r->res_master_nodeid,
 				  dlm_dir_nodeid(r), oc, ou);
 		}
 		unlock_rsb(r);
@@ -5380,8 +5357,8 @@ static void purge_dead_list(struct dlm_ls *ls, struct dlm_rsb *r,
 		if (!is_master_copy(lkb))
 			continue;
 
-		if ((lkb->lkb_nodeid == nodeid_gone) ||
-		    dlm_is_removed(ls, lkb->lkb_nodeid)) {
+		if ((lkb->lkb_master_nodeid == nodeid_gone) ||
+		    dlm_is_removed(ls, lkb->lkb_master_nodeid)) {
 
 			/* tell recover_lvb to invalidate the lvb
 			   because a node holding EX/PW failed */
@@ -5518,7 +5495,7 @@ static struct dlm_lkb *search_remid_list(struct list_head *head, int nodeid,
 	struct dlm_lkb *lkb;
 
 	list_for_each_entry(lkb, head, lkb_statequeue) {
-		if (lkb->lkb_nodeid == nodeid && lkb->lkb_remid == remid)
+		if (lkb->lkb_master_nodeid == nodeid && lkb->lkb_remid == remid)
 			return lkb;
 	}
 	return NULL;
@@ -5547,7 +5524,7 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 
-	lkb->lkb_nodeid = le32_to_cpu(rc->rc_header.h_nodeid);
+	lkb->lkb_master_nodeid = dlm_res_master_nodeid(le32_to_cpu(rc->rc_header.h_nodeid));
 	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
 	lkb->lkb_remid = le32_to_cpu(rl->rl_lkid);
 	lkb->lkb_exflags = le32_to_cpu(rl->rl_exflags);
@@ -6294,7 +6271,8 @@ int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
 
 /* debug functionality */
 int dlm_debug_add_lkb(struct dlm_ls *ls, uint32_t lkb_id, char *name, int len,
-		      int lkb_nodeid, unsigned int lkb_dflags, int lkb_status)
+		      int lkb_master_nodeid, unsigned int lkb_dflags,
+		      int lkb_status)
 {
 	struct dlm_lksb *lksb;
 	struct dlm_lkb *lkb;
@@ -6316,7 +6294,7 @@ int dlm_debug_add_lkb(struct dlm_ls *ls, uint32_t lkb_id, char *name, int len,
 	}
 
 	dlm_set_dflags_val(lkb, lkb_dflags);
-	lkb->lkb_nodeid = lkb_nodeid;
+	lkb->lkb_master_nodeid = lkb_master_nodeid;
 	lkb->lkb_lksb = lksb;
 	/* user specific pointer, just don't have it NULL for kernel locks */
 	if (~lkb_dflags & BIT(DLM_DFL_USER_BIT))
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 8de9dee4c058..e59161d2fe84 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -61,13 +61,14 @@ int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
 int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid);
 void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc);
 int dlm_debug_add_lkb(struct dlm_ls *ls, uint32_t lkb_id, char *name, int len,
-		      int lkb_nodeid, unsigned int lkb_flags, int lkb_status);
+		      int lkb_master_nodeid, unsigned int lkb_flags,
+		      int lkb_status);
 int dlm_debug_add_lkb_to_waiters(struct dlm_ls *ls, uint32_t lkb_id,
 				 int mstype, int to_nodeid);
 
 static inline int is_master(struct dlm_rsb *r)
 {
-	return !r->res_nodeid;
+	return r->res_master_nodeid == dlm_our_nodeid();
 }
 
 static inline void lock_rsb(struct dlm_rsb *r)
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 6f1078a1c715..f54f43dbe7b6 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -660,7 +660,7 @@ static int lockspace_busy(struct dlm_ls *ls, int force)
 		}
 	} else if (force == 1) {
 		xa_for_each(&ls->ls_lkbxa, id, lkb) {
-			if (lkb->lkb_nodeid == 0 &&
+			if (lkb->lkb_master_nodeid == dlm_our_nodeid() &&
 			    lkb->lkb_grmode != DLM_LOCK_IV) {
 				rv = 1;
 				break;
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index be1a71a6303a..b545cd7a23cd 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -455,8 +455,8 @@ int dlm_send_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb, uint64_t seq)
 	if (lkb->lkb_lvbptr)
 		len += ls->ls_lvblen;
 
-	error = create_rcom(ls, r->res_nodeid, DLM_RCOM_LOCK, len, &rc, &mh,
-			    seq);
+	error = create_rcom(ls, r->res_master_nodeid, DLM_RCOM_LOCK, len, &rc,
+			    &mh, seq);
 	if (error)
 		goto out;
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index d156196b9e69..d948d28d8f92 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -408,7 +408,7 @@ static void set_lock_master(struct list_head *queue, int nodeid)
 
 	list_for_each_entry(lkb, queue, lkb_statequeue) {
 		if (!test_bit(DLM_IFL_MSTCPY_BIT, &lkb->lkb_iflags)) {
-			lkb->lkb_nodeid = nodeid;
+			lkb->lkb_master_nodeid = nodeid;
 			lkb->lkb_remid = 0;
 		}
 	}
@@ -416,9 +416,9 @@ static void set_lock_master(struct list_head *queue, int nodeid)
 
 static void set_master_lkbs(struct dlm_rsb *r)
 {
-	set_lock_master(&r->res_grantqueue, r->res_nodeid);
-	set_lock_master(&r->res_convertqueue, r->res_nodeid);
-	set_lock_master(&r->res_waitqueue, r->res_nodeid);
+	set_lock_master(&r->res_grantqueue, r->res_master_nodeid);
+	set_lock_master(&r->res_convertqueue, r->res_master_nodeid);
+	set_lock_master(&r->res_waitqueue, r->res_master_nodeid);
 }
 
 /*
@@ -455,7 +455,7 @@ static int recover_master(struct dlm_rsb *r, unsigned int *count, uint64_t seq)
 	if (is_master(r))
 		return 0;
 
-	is_removed = dlm_is_removed(ls, r->res_nodeid);
+	is_removed = dlm_is_removed(ls, r->res_master_nodeid);
 
 	if (!is_removed && !rsb_flag(r, RSB_NEW_MASTER))
 		return 0;
@@ -464,10 +464,8 @@ static int recover_master(struct dlm_rsb *r, unsigned int *count, uint64_t seq)
 	dir_nodeid = dlm_dir_nodeid(r);
 
 	if (dir_nodeid == our_nodeid) {
-		if (is_removed) {
+		if (is_removed)
 			r->res_master_nodeid = our_nodeid;
-			r->res_nodeid = 0;
-		}
 
 		/* set master of lkbs to ourself when is_removed, or to
 		   another new master which we set along with NEW_MASTER
@@ -501,14 +499,9 @@ static int recover_master(struct dlm_rsb *r, unsigned int *count, uint64_t seq)
 static int recover_master_static(struct dlm_rsb *r, unsigned int *count)
 {
 	int dir_nodeid = dlm_dir_nodeid(r);
-	int new_master = dir_nodeid;
-
-	if (dir_nodeid == dlm_our_nodeid())
-		new_master = 0;
 
 	dlm_purge_mstcpy_locks(r);
 	r->res_master_nodeid = dir_nodeid;
-	r->res_nodeid = new_master;
 	set_new_master(r);
 	(*count)++;
 	return 0;
@@ -584,7 +577,6 @@ int dlm_recover_master_reply(struct dlm_ls *ls, const struct dlm_rcom *rc)
 
 	lock_rsb(r);
 	r->res_master_nodeid = ret_nodeid;
-	r->res_nodeid = new_master;
 	set_new_master(r);
 	unlock_rsb(r);
 	recover_xa_del(r);
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 17a40d1e6036..06959b128bd0 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -34,7 +34,7 @@ static int dlm_create_masters_list(struct dlm_ls *ls)
 
 	read_lock_bh(&ls->ls_rsbtbl_lock);
 	list_for_each_entry(r, &ls->ls_keep, res_rsbs_list) {
-		if (r->res_nodeid)
+		if (r->res_master_nodeid != dlm_our_nodeid())
 			continue;
 
 		list_add(&r->res_masters_list, &ls->ls_masters_list);
-- 
2.43.0

