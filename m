Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAD913C832
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451775; cv=none; b=teSwyCYbUbHpaoTHBVUb+Q5TGxvUxhMrGqo2syJPCoNmCRIEVfaVog1HudPDEu4ZZNg37RFiVmzdA0AQmxbumjwyVB1kVFDpvUK+AHF9egtlgm6/Z/qrvVasfmKxpuWmL5CXYc0orDCFbySluJDvSRRlh5uHdtiMF0O0vcFrIRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451775; c=relaxed/simple;
	bh=jAg3g7WXPhka/UJ1hgP99EEAFvo9iDzS4jRgVu4kFJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTW945qkMSzit7b/0BNxdcuXjcT3rRkLgyAblUV5UZMkhecl9FYrHk+THyfDZn0gqHoBbkkLonbnPmi6eyvMC8S7ufGAbtXsrIYXThl8SJW0nTidvTYFiv0gTRe47pR0bER4XEU7CHPrZmwSgMe6Myu1D5R/jq931s9TQQB4m2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZwHyyaOa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwHyyaOa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOFTSzWrE1H2XW4lYiRV/2N7RwoShvRb5FcoAsHPVXU=;
	b=ZwHyyaOaAkG0OA1D203D5Qc4sk6FA8lxujjH4GnqWEhP8cJD2D9rmbLkMgFO9mmyGX98lq
	7iYQceZFhW9TFxp74/RwcLQTe0vQ78ZEhDI4MKEoB98FauoM3cksZlEdD6eZ1vNXS1bCxb
	hRJ1k3/Wh6WCIvxqvLrENvaZLKK6pGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-x8plDNApMr27b_uugjFz5w-1; Mon, 03 Jun 2024 17:56:09 -0400
X-MC-Unique: x8plDNApMr27b_uugjFz5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8EA0801190;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC446200E4A1;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 6/8] dlm: implement LSFL_SOFTIRQ_SAFE
Date: Mon,  3 Jun 2024 17:55:56 -0400
Message-ID: <20240603215558.2722969-7-aahringo@redhat.com>
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

This patch implements to allow to directly call ast and bast callbacks
in the context as soon they arrive. Currently every ast and bast callback
of a kernel lockspace  callback is queued through a workqueue to provide
the dlm user a different context. However some users can't currently handle
the strongest context of ast/bast which is a softirq context but new users
should directly implement their dlm application to run in softirq context.
Another mentioned requirement that is more unlikely that a current DLM
runs into is a lock recursion if a lock if the same lock is held in the
callback and when the DLM API is called.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c          | 157 +++++++++++++++++++++++++++---------------
 fs/dlm/ast.h          |  11 ++-
 fs/dlm/dlm_internal.h |   1 +
 fs/dlm/lockspace.c    |   3 +
 fs/dlm/user.c         |  38 +++++-----
 5 files changed, 126 insertions(+), 84 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 52ce27031314..742b30b61c19 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -18,35 +18,52 @@
 #include "user.h"
 #include "ast.h"
 
-static void dlm_callback_work(struct work_struct *work)
+static void dlm_run_callback(uint32_t ls_id, uint32_t lkb_id, int8_t mode,
+			     uint32_t flags, uint8_t sb_flags, int sb_status,
+			     struct dlm_lksb *lksb,
+			     void (*astfn)(void *astparam),
+			     void (*bastfn)(void *astparam, int mode),
+			     void *astparam, const char *res_name,
+			     size_t res_length)
 {
-	struct dlm_callback *cb = container_of(work, struct dlm_callback, work);
-
-	if (cb->flags & DLM_CB_BAST) {
-		trace_dlm_bast(cb->ls_id, cb->lkb_id, cb->mode, cb->res_name,
-			       cb->res_length);
-		cb->bastfn(cb->astparam, cb->mode);
-	} else if (cb->flags & DLM_CB_CAST) {
-		trace_dlm_ast(cb->ls_id, cb->lkb_id, cb->sb_status,
-			      cb->sb_flags, cb->res_name, cb->res_length);
-		cb->lkb_lksb->sb_status = cb->sb_status;
-		cb->lkb_lksb->sb_flags = cb->sb_flags;
-		cb->astfn(cb->astparam);
+	if (flags & DLM_CB_BAST) {
+		trace_dlm_bast(ls_id, lkb_id, mode, res_name, res_length);
+		bastfn(astparam, mode);
+	} else if (flags & DLM_CB_CAST) {
+		trace_dlm_ast(ls_id, lkb_id, sb_status, sb_flags, res_name,
+			      res_length);
+		lksb->sb_status = sb_status;
+		lksb->sb_flags = sb_flags;
+		astfn(astparam);
 	}
+}
 
+static void dlm_do_callback(struct dlm_callback *cb)
+{
+	dlm_run_callback(cb->ls_id, cb->lkb_id, cb->mode, cb->flags,
+			 cb->sb_flags, cb->sb_status, cb->lkb_lksb,
+			 cb->astfn, cb->bastfn, cb->astparam,
+			 cb->res_name, cb->res_length);
 	dlm_free_cb(cb);
 }
 
-int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
-			   int status, uint32_t sbflags,
-			   struct dlm_callback **cb)
+static void dlm_callback_work(struct work_struct *work)
+{
+	struct dlm_callback *cb = container_of(work, struct dlm_callback, work);
+
+	dlm_do_callback(cb);
+}
+
+bool dlm_may_skip_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
+			   int status, uint32_t sbflags, int *copy_lvb)
 {
 	struct dlm_rsb *rsb = lkb->lkb_resource;
-	int rv = DLM_ENQUEUE_CALLBACK_SUCCESS;
 	struct dlm_ls *ls = rsb->res_ls;
-	int copy_lvb = 0;
 	int prev_mode;
 
+	if (copy_lvb)
+		*copy_lvb = 0;
+
 	if (flags & DLM_CB_BAST) {
 		/* if cb is a bast, it should be skipped if the blocking mode is
 		 * compatible with the last granted mode
@@ -56,7 +73,7 @@ int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 				log_debug(ls, "skip %x bast mode %d for cast mode %d",
 					  lkb->lkb_id, mode,
 					  lkb->lkb_last_cast_cb_mode);
-				goto out;
+				return true;
 			}
 		}
 
@@ -74,7 +91,7 @@ int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 			    (prev_mode > mode && prev_mode > DLM_LOCK_PR)) {
 				log_debug(ls, "skip %x add bast mode %d for bast mode %d",
 					  lkb->lkb_id, mode, prev_mode);
-				goto out;
+				return true;
 			}
 		}
 
@@ -85,8 +102,10 @@ int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 			prev_mode = lkb->lkb_last_cast_cb_mode;
 
 			if (!status && lkb->lkb_lksb->sb_lvbptr &&
-			    dlm_lvb_operations[prev_mode + 1][mode + 1])
-				copy_lvb = 1;
+			    dlm_lvb_operations[prev_mode + 1][mode + 1]) {
+				if (copy_lvb)
+					*copy_lvb = 1;
+			}
 		}
 
 		lkb->lkb_last_cast_cb_mode = mode;
@@ -96,11 +115,19 @@ int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	lkb->lkb_last_cb_mode = mode;
 	lkb->lkb_last_cb_flags = flags;
 
+	return false;
+}
+
+int dlm_get_cb(struct dlm_lkb *lkb, uint32_t flags, int mode,
+	       int status, uint32_t sbflags,
+	       struct dlm_callback **cb)
+{
+	struct dlm_rsb *rsb = lkb->lkb_resource;
+	struct dlm_ls *ls = rsb->res_ls;
+
 	*cb = dlm_allocate_cb();
-	if (!*cb) {
-		rv = DLM_ENQUEUE_CALLBACK_FAILURE;
-		goto out;
-	}
+	if (WARN_ON_ONCE(!*cb))
+		return -ENOMEM;
 
 	/* for tracing */
 	(*cb)->lkb_id = lkb->lkb_id;
@@ -112,19 +139,34 @@ int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	(*cb)->mode = mode;
 	(*cb)->sb_status = status;
 	(*cb)->sb_flags = (sbflags & 0x000000FF);
-	(*cb)->copy_lvb = copy_lvb;
 	(*cb)->lkb_lksb = lkb->lkb_lksb;
 
-	rv = DLM_ENQUEUE_CALLBACK_NEED_SCHED;
+	return 0;
+}
+
+static int dlm_get_queue_cb(struct dlm_lkb *lkb, uint32_t flags, int mode,
+			    int status, uint32_t sbflags,
+			    struct dlm_callback **cb)
+{
+	int rv;
 
-out:
-	return rv;
+	rv = dlm_get_cb(lkb, flags, mode, status, sbflags, cb);
+	if (rv)
+		return rv;
+
+	(*cb)->astfn = lkb->lkb_astfn;
+	(*cb)->bastfn = lkb->lkb_bastfn;
+	(*cb)->astparam = lkb->lkb_astparam;
+	INIT_WORK(&(*cb)->work, dlm_callback_work);
+
+	return 0;
 }
 
 void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
-		  uint32_t sbflags)
+		uint32_t sbflags)
 {
-	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
+	struct dlm_rsb *rsb = lkb->lkb_resource;
+	struct dlm_ls *ls = rsb->res_ls;
 	struct dlm_callback *cb;
 	int rv;
 
@@ -133,35 +175,34 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 		return;
 	}
 
-	rv = dlm_queue_lkb_callback(lkb, flags, mode, status, sbflags,
-				    &cb);
-	switch (rv) {
-	case DLM_ENQUEUE_CALLBACK_NEED_SCHED:
-		cb->astfn = lkb->lkb_astfn;
-		cb->bastfn = lkb->lkb_bastfn;
-		cb->astparam = lkb->lkb_astparam;
-		INIT_WORK(&cb->work, dlm_callback_work);
-
-		spin_lock_bh(&ls->ls_cb_lock);
-		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags))
+	if (dlm_may_skip_callback(lkb, flags, mode, status, sbflags, NULL))
+		return;
+
+	spin_lock_bh(&ls->ls_cb_lock);
+	if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
+		rv = dlm_get_queue_cb(lkb, flags, mode, status, sbflags, &cb);
+		if (!rv)
 			list_add(&cb->list, &ls->ls_cb_delay);
-		else
-			queue_work(ls->ls_callback_wq, &cb->work);
-		spin_unlock_bh(&ls->ls_cb_lock);
-		break;
-	case DLM_ENQUEUE_CALLBACK_SUCCESS:
-		break;
-	case DLM_ENQUEUE_CALLBACK_FAILURE:
-		fallthrough;
-	default:
-		WARN_ON_ONCE(1);
-		break;
+	} else {
+		if (test_bit(LSFL_SOFTIRQ, &ls->ls_flags)) {
+			dlm_run_callback(ls->ls_global_id, lkb->lkb_id, mode, flags,
+					 sbflags, status, lkb->lkb_lksb,
+					 lkb->lkb_astfn, lkb->lkb_bastfn,
+					 lkb->lkb_astparam, rsb->res_name,
+					 rsb->res_length);
+		} else {
+			rv = dlm_get_queue_cb(lkb, flags, mode, status, sbflags, &cb);
+			if (!rv)
+				queue_work(ls->ls_callback_wq, &cb->work);
+		}
 	}
+	spin_unlock_bh(&ls->ls_cb_lock);
 }
 
 int dlm_callback_start(struct dlm_ls *ls)
 {
-	if (!test_bit(LSFL_FS, &ls->ls_flags))
+	if (!test_bit(LSFL_FS, &ls->ls_flags) ||
+	    test_bit(LSFL_SOFTIRQ, &ls->ls_flags))
 		return 0;
 
 	ls->ls_callback_wq = alloc_ordered_workqueue("dlm_callback",
@@ -207,7 +248,11 @@ void dlm_callback_resume(struct dlm_ls *ls)
 	spin_lock_bh(&ls->ls_cb_lock);
 	list_for_each_entry_safe(cb, safe, &ls->ls_cb_delay, list) {
 		list_del(&cb->list);
-		queue_work(ls->ls_callback_wq, &cb->work);
+		if (test_bit(LSFL_SOFTIRQ, &ls->ls_flags))
+			dlm_do_callback(cb);
+		else
+			queue_work(ls->ls_callback_wq, &cb->work);
+
 		count++;
 		if (count == MAX_CB_QUEUE)
 			break;
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index 9093ff043bee..e2b86845d331 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -11,12 +11,11 @@
 #ifndef __ASTD_DOT_H__
 #define __ASTD_DOT_H__
 
-#define DLM_ENQUEUE_CALLBACK_NEED_SCHED	1
-#define DLM_ENQUEUE_CALLBACK_SUCCESS	0
-#define DLM_ENQUEUE_CALLBACK_FAILURE	-1
-int dlm_queue_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
-			   int status, uint32_t sbflags,
-			   struct dlm_callback **cb);
+bool dlm_may_skip_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
+			   int status, uint32_t sbflags, int *copy_lvb);
+int dlm_get_cb(struct dlm_lkb *lkb, uint32_t flags, int mode,
+	       int status, uint32_t sbflags,
+	       struct dlm_callback **cb);
 void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
                 uint32_t sbflags);
 
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 3b026d80aa2b..e299d8d4d971 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -727,6 +727,7 @@ struct dlm_ls {
 #define LSFL_NODIR		10
 #define LSFL_RECV_MSG_BLOCKED	11
 #define LSFL_FS			12
+#define LSFL_SOFTIRQ		13
 
 #define DLM_PROC_FLAGS_CLOSING 1
 #define DLM_PROC_FLAGS_COMPAT  2
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 51f9516b710d..5b3a4c32ac99 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -407,6 +407,9 @@ static int new_lockspace(const char *name, const char *cluster,
 		ls->ls_ops_arg = ops_arg;
 	}
 
+	if (flags & DLM_LSFL_SOFTIRQ)
+		set_bit(LSFL_SOFTIRQ, &ls->ls_flags);
+
 	/* ls_exflags are forced to match among nodes, and we don't
 	 * need to require all nodes to have some flags set
 	 */
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index f6635a5314f4..5cb3896be826 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -182,7 +182,7 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	struct dlm_user_args *ua;
 	struct dlm_user_proc *proc;
 	struct dlm_callback *cb;
-	int rv;
+	int rv, copy_lvb;
 
 	if (test_bit(DLM_DFL_ORPHAN_BIT, &lkb->lkb_dflags) ||
 	    test_bit(DLM_IFL_DEAD_BIT, &lkb->lkb_iflags))
@@ -213,28 +213,22 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 
 	spin_lock_bh(&proc->asts_spin);
 
-	rv = dlm_queue_lkb_callback(lkb, flags, mode, status, sbflags, &cb);
-	switch (rv) {
-	case DLM_ENQUEUE_CALLBACK_NEED_SCHED:
-		cb->ua = *ua;
-		cb->lkb_lksb = &cb->ua.lksb;
-		if (cb->copy_lvb) {
-			memcpy(cb->lvbptr, ua->lksb.sb_lvbptr,
-			       DLM_USER_LVB_LEN);
-			cb->lkb_lksb->sb_lvbptr = cb->lvbptr;
+	if (!dlm_may_skip_callback(lkb, flags, mode, status, sbflags,
+				   &copy_lvb)) {
+		rv = dlm_get_cb(lkb, flags, mode, status, sbflags, &cb);
+		if (!rv) {
+			cb->copy_lvb = copy_lvb;
+			cb->ua = *ua;
+			cb->lkb_lksb = &cb->ua.lksb;
+			if (copy_lvb) {
+				memcpy(cb->lvbptr, ua->lksb.sb_lvbptr,
+				       DLM_USER_LVB_LEN);
+				cb->lkb_lksb->sb_lvbptr = cb->lvbptr;
+			}
+
+			list_add_tail(&cb->list, &proc->asts);
+			wake_up_interruptible(&proc->wait);
 		}
-
-		list_add_tail(&cb->list, &proc->asts);
-		wake_up_interruptible(&proc->wait);
-		break;
-	case DLM_ENQUEUE_CALLBACK_SUCCESS:
-		break;
-	case DLM_ENQUEUE_CALLBACK_FAILURE:
-		fallthrough;
-	default:
-		spin_unlock_bh(&proc->asts_spin);
-		WARN_ON_ONCE(1);
-		goto out;
 	}
 	spin_unlock_bh(&proc->asts_spin);
 
-- 
2.43.0

