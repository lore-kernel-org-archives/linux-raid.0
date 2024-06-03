Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EDA13C827
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451775; cv=none; b=e66OOuss/Dt3gaRAWP7YOGButnHjolqv3umF9py0YyItkwem7ppI1WL+g43DGGUcz6FGBQvHBMkri/KwYwROt/vWJoYoG7JUAQ7N+tJVXeAI4pVE/vc2JIuO07fIjBd1Wy7lTb/LtJWjG6icXqtmfSz2dzUnNJrHu3NbD3xniCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451775; c=relaxed/simple;
	bh=K+OwEKZcMQ++/P7KWZ9gm7ATqlj35yX+mcIVWMtKDXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4Ki46PhOLjhB26WROlrTU/keNK6x3QEgDU4975nBBn3nEPY3ze0ISJqnVDyCyoIxL5Y7GBETxa8/P3+2jXeAU7J8LOi87Lsj+8qaBJqjHMKFpfA4/7bH7RbMcpuz/NoK9ORNPCJIPhv8wjCvjpQNADyGsh2HMQzubx1pq+1p4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StGdcGyI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StGdcGyI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWPGN/PZ9jdQvazGCAystLXhuoCD4EN7FycFhcF+Y+Y=;
	b=StGdcGyI0JsaCc7jaH7RzrNiseL0S23Ze2bJ+V9AHI+9xl2A+FZ803uicEW2XgyYL7LaLc
	W4npnF7Zmt3TCilBlsANL6fH3BZkTSv/q6gvM4PwdzVRFtlG0cYNsi5j2MrnZ0Akiqn5zb
	lu0exRR+o+Vugbu341OGAPj1W36LPsM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-108-GYhw5mH5PuWL4r4xy2rTZA-1; Mon,
 03 Jun 2024 17:56:09 -0400
X-MC-Unique: GYhw5mH5PuWL4r4xy2rTZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3D963806701;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8630200E554;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 7/8] dlm: convert ls_cb_lock to rwlock
Date: Mon,  3 Jun 2024 17:55:57 -0400
Message-ID: <20240603215558.2722969-8-aahringo@redhat.com>
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

Currently a parallel call of dlm_add_cb() can happen either from the DLM
API call or from the DLM message receive context. In this case a rwlock
could have a benefit when both context running into the same critical
section at the same time. In future more parallel message receive
context can happen at the same time so that this conversion of a per
lockspace lock to a rwlock is more useful. In far future the whole
delayed callbacks might not be necessary when the synchronization
happens in a different way than it is now done.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c          | 21 +++++++++++++++------
 fs/dlm/dlm_internal.h |  2 +-
 fs/dlm/lockspace.c    |  2 +-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 742b30b61c19..ce8f1f5dfa0c 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -178,11 +178,20 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 	if (dlm_may_skip_callback(lkb, flags, mode, status, sbflags, NULL))
 		return;
 
-	spin_lock_bh(&ls->ls_cb_lock);
+retry:
+	read_lock_bh(&ls->ls_cb_lock);
 	if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
+		read_unlock_bh(&ls->ls_cb_lock);
+		write_lock_bh(&ls->ls_cb_lock);
+		if (!test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
+			write_unlock_bh(&ls->ls_cb_lock);
+			goto retry;
+		}
+
 		rv = dlm_get_queue_cb(lkb, flags, mode, status, sbflags, &cb);
 		if (!rv)
 			list_add(&cb->list, &ls->ls_cb_delay);
+		write_unlock_bh(&ls->ls_cb_lock);
 	} else {
 		if (test_bit(LSFL_SOFTIRQ, &ls->ls_flags)) {
 			dlm_run_callback(ls->ls_global_id, lkb->lkb_id, mode, flags,
@@ -195,8 +204,8 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 			if (!rv)
 				queue_work(ls->ls_callback_wq, &cb->work);
 		}
+		read_unlock_bh(&ls->ls_cb_lock);
 	}
-	spin_unlock_bh(&ls->ls_cb_lock);
 }
 
 int dlm_callback_start(struct dlm_ls *ls)
@@ -225,9 +234,9 @@ void dlm_callback_suspend(struct dlm_ls *ls)
 	if (!test_bit(LSFL_FS, &ls->ls_flags))
 		return;
 
-	spin_lock_bh(&ls->ls_cb_lock);
+	write_lock_bh(&ls->ls_cb_lock);
 	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
-	spin_unlock_bh(&ls->ls_cb_lock);
+	write_unlock_bh(&ls->ls_cb_lock);
 
 	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);
@@ -245,7 +254,7 @@ void dlm_callback_resume(struct dlm_ls *ls)
 		return;
 
 more:
-	spin_lock_bh(&ls->ls_cb_lock);
+	write_lock_bh(&ls->ls_cb_lock);
 	list_for_each_entry_safe(cb, safe, &ls->ls_cb_delay, list) {
 		list_del(&cb->list);
 		if (test_bit(LSFL_SOFTIRQ, &ls->ls_flags))
@@ -260,7 +269,7 @@ void dlm_callback_resume(struct dlm_ls *ls)
 	empty = list_empty(&ls->ls_cb_delay);
 	if (empty)
 		clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
-	spin_unlock_bh(&ls->ls_cb_lock);
+	write_unlock_bh(&ls->ls_cb_lock);
 
 	sum += count;
 	if (!empty) {
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index e299d8d4d971..5a7fbfec26fb 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -653,7 +653,7 @@ struct dlm_ls {
 
 	/* recovery related */
 
-	spinlock_t		ls_cb_lock;
+	rwlock_t		ls_cb_lock;
 	struct list_head	ls_cb_delay; /* save for queue_work later */
 	struct task_struct	*ls_recoverd_task;
 	struct mutex		ls_recoverd_active;
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 5b3a4c32ac99..f6918f366faa 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -449,7 +449,7 @@ static int new_lockspace(const char *name, const char *cluster,
 	init_completion(&ls->ls_recovery_done);
 	ls->ls_recovery_result = -1;
 
-	spin_lock_init(&ls->ls_cb_lock);
+	rwlock_init(&ls->ls_cb_lock);
 	INIT_LIST_HEAD(&ls->ls_cb_delay);
 
 	ls->ls_recoverd_task = NULL;
-- 
2.43.0

