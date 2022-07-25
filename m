Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B55C43334
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 20:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiGYUi5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbiGYUiv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 16:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8D6523156
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 13:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658781530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RKIBtu0FOweCY92vvZDLfDpbPY3XDlSi5UZ3Y5Tv6s=;
        b=btmd6zLkdrAOQK8n1d/f8HmA9ItyAzXIlYHWrVZWBcTTb+hxmakQNnKZ3G+8d2f6aYTlbh
        zIB97KSf+50ArZJe9kRK0sTjM2mTAVXIGS7iQV43UUVvjg9zrUIoqEWiXGMVQAG5xfnIhI
        XObWo92uvvPvXUkCEJvPmKoq290bE5A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-dHTrcp_iMfKQeV68k6EbeA-1; Mon, 25 Jul 2022 16:38:45 -0400
X-MC-Unique: dHTrcp_iMfKQeV68k6EbeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 611331C06EC3;
        Mon, 25 Jul 2022 20:38:45 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 238ED40D282F;
        Mon, 25 Jul 2022 20:38:45 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, song@kernel.org, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 3/5] fs: dlm: trace user space callbacks
Date:   Mon, 25 Jul 2022 16:38:33 -0400
Message-Id: <20220725203835.860277-4-aahringo@redhat.com>
In-Reply-To: <20220725203835.860277-1-aahringo@redhat.com>
References: <20220725203835.860277-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch adds trace callbacks for user locks. Unfortenately user locks
are handled in a different way than kernel locks in some cases. User
locks never call the dlm_lock()/dlm_unlock() kernel API and use the next
step internal API of dlm. Adding those traces from user API callers
should make it possible for dlm trace system to see lock handling for
user locks as well.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lock.c              | 24 ++++++++++++++++++++----
 fs/dlm/user.c              |  7 ++++++-
 include/trace/events/dlm.h | 23 +++++++++++++----------
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 4c7ed4bec3f4..44c85930211d 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3462,7 +3462,7 @@ int dlm_lock(dlm_lockspace_t *lockspace,
 	if (error == -EINPROGRESS)
 		error = 0;
  out_put:
-	trace_dlm_lock_end(ls, lkb, name, namelen, mode, flags, error);
+	trace_dlm_lock_end(ls, lkb, name, namelen, mode, flags, error, true);
 
 	if (convert || error)
 		__put_lkb(ls, lkb);
@@ -5835,13 +5835,15 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		goto out;
 	}
 
+	trace_dlm_lock_start(ls, lkb, name, namelen, mode, flags);
+
 	if (flags & DLM_LKF_VALBLK) {
 		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_NOFS);
 		if (!ua->lksb.sb_lvbptr) {
 			kfree(ua);
 			__put_lkb(ls, lkb);
 			error = -ENOMEM;
-			goto out;
+			goto out_trace_end;
 		}
 	}
 #ifdef CONFIG_DLM_DEPRECATED_API
@@ -5856,7 +5858,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		ua->lksb.sb_lvbptr = NULL;
 		kfree(ua);
 		__put_lkb(ls, lkb);
-		goto out;
+		goto out_trace_end;
 	}
 
 	/* After ua is attached to lkb it will be freed by dlm_free_lkb().
@@ -5876,7 +5878,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		fallthrough;
 	default:
 		__put_lkb(ls, lkb);
-		goto out;
+		goto out_trace_end;
 	}
 
 	/* add this new lkb to the per-process list of locks */
@@ -5884,6 +5886,8 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	hold_lkb(lkb);
 	list_add_tail(&lkb->lkb_ownqueue, &ua->proc->locks);
 	spin_unlock(&ua->proc->locks_spin);
+ out_trace_end:
+	trace_dlm_lock_end(ls, lkb, name, namelen, mode, flags, error, false);
  out:
 	dlm_unlock_recovery(ls);
 	return error;
@@ -5909,6 +5913,8 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error)
 		goto out;
 
+	trace_dlm_lock_start(ls, lkb, NULL, 0, mode, flags);
+
 	/* user can change the params on its lock when it converts it, or
 	   add an lvb that didn't exist before */
 
@@ -5946,6 +5952,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error == -EINPROGRESS || error == -EAGAIN || error == -EDEADLK)
 		error = 0;
  out_put:
+	trace_dlm_lock_end(ls, lkb, NULL, 0, mode, flags, error, false);
 	dlm_put_lkb(lkb);
  out:
 	dlm_unlock_recovery(ls);
@@ -6038,6 +6045,8 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error)
 		goto out;
 
+	trace_dlm_unlock_start(ls, lkb, flags);
+
 	ua = lkb->lkb_ua;
 
 	if (lvb_in && ua->lksb.sb_lvbptr)
@@ -6066,6 +6075,7 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 		list_move(&lkb->lkb_ownqueue, &ua->proc->unlocking);
 	spin_unlock(&ua->proc->locks_spin);
  out_put:
+	trace_dlm_unlock_end(ls, lkb, flags, error);
 	dlm_put_lkb(lkb);
  out:
 	dlm_unlock_recovery(ls);
@@ -6087,6 +6097,8 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error)
 		goto out;
 
+	trace_dlm_unlock_start(ls, lkb, flags);
+
 	ua = lkb->lkb_ua;
 	if (ua_tmp->castparam)
 		ua->castparam = ua_tmp->castparam;
@@ -6104,6 +6116,7 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	if (error == -EBUSY)
 		error = 0;
  out_put:
+	trace_dlm_unlock_end(ls, lkb, flags, error);
 	dlm_put_lkb(lkb);
  out:
 	dlm_unlock_recovery(ls);
@@ -6125,6 +6138,8 @@ int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid)
 	if (error)
 		goto out;
 
+	trace_dlm_unlock_start(ls, lkb, flags);
+
 	ua = lkb->lkb_ua;
 
 	error = set_unlock_args(flags, ua, &args);
@@ -6153,6 +6168,7 @@ int dlm_user_deadlock(struct dlm_ls *ls, uint32_t flags, uint32_t lkid)
 	if (error == -EBUSY)
 		error = 0;
  out_put:
+	trace_dlm_unlock_end(ls, lkb, flags, error);
 	dlm_put_lkb(lkb);
  out:
 	dlm_unlock_recovery(ls);
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c6d38a06e94c..792a3efb8d60 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 
+#include <trace/events/dlm.h>
+
 #include "dlm_internal.h"
 #include "lockspace.h"
 #include "lock.h"
@@ -882,7 +884,9 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 		goto try_another;
 	}
 
-	if (cb.flags & DLM_CB_CAST) {
+	if (cb.flags & DLM_CB_BAST) {
+		trace_dlm_bast(lkb->lkb_resource->res_ls, lkb, cb.mode);
+	} else if (cb.flags & DLM_CB_CAST) {
 		new_mode = cb.mode;
 
 		if (!cb.sb_status && lkb->lkb_lksb->sb_lvbptr &&
@@ -891,6 +895,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 
 		lkb->lkb_lksb->sb_status = cb.sb_status;
 		lkb->lkb_lksb->sb_flags = cb.sb_flags;
+		trace_dlm_ast(lkb->lkb_resource->res_ls, lkb);
 	}
 
 	rv = copy_result_to_user(lkb->lkb_ua,
diff --git a/include/trace/events/dlm.h b/include/trace/events/dlm.h
index bad21222130e..92d263aab848 100644
--- a/include/trace/events/dlm.h
+++ b/include/trace/events/dlm.h
@@ -92,9 +92,10 @@ TRACE_EVENT(dlm_lock_start,
 TRACE_EVENT(dlm_lock_end,
 
 	TP_PROTO(struct dlm_ls *ls, struct dlm_lkb *lkb, void *name,
-		 unsigned int namelen, int mode, __u32 flags, int error),
+		 unsigned int namelen, int mode, __u32 flags, int error,
+		 bool kernel_lock),
 
-	TP_ARGS(ls, lkb, name, namelen, mode, flags, error),
+	TP_ARGS(ls, lkb, name, namelen, mode, flags, error, kernel_lock),
 
 	TP_STRUCT__entry(
 		__field(__u32, ls_id)
@@ -122,14 +123,16 @@ TRACE_EVENT(dlm_lock_end,
 			memcpy(__get_dynamic_array(res_name), name,
 			       __get_dynamic_array_len(res_name));
 
-		/* return value will be zeroed in those cases by dlm_lock()
-		 * we do it here again to not introduce more overhead if
-		 * trace isn't running and error reflects the return value.
-		 */
-		if (error == -EAGAIN || error == -EDEADLK)
-			__entry->error = 0;
-		else
-			__entry->error = error;
+		if (kernel_lock) {
+			/* return value will be zeroed in those cases by dlm_lock()
+			 * we do it here again to not introduce more overhead if
+			 * trace isn't running and error reflects the return value.
+			 */
+			if (error == -EAGAIN || error == -EDEADLK)
+				__entry->error = 0;
+			else
+				__entry->error = error;
+		}
 
 	),
 
-- 
2.31.1

