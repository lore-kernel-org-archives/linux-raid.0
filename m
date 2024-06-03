Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CF13C69C
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451774; cv=none; b=hH+CrgjloIja5K70slFqVG+leXVnfBnB674qwdZtd0wHpdGriY7/IG0O+o7urzXERWeLQfqb1SLqPVFunHeMbUgsUhTO4HSsqysfIISn2LMABoAZkU/pNWv+ZGjomKOqE+ap2TQJdn9Z4VET4xWooZ3U6eOqGloKoVzp2rkE34c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451774; c=relaxed/simple;
	bh=jWJWtpYyHQWZir+Z7m4u7eN7tveGJS5Q+6RYhmr9P4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSKbdNZQ05GGtt921wvi2qSjkNf9QlulLMYirJgH6Jp/sPGTbM/9T1DZOcWEgA6mLSwl5WfF88SmV660HM25sEiPXiRheFvlWJZlFEEFjn5hX53kvAmzQYzK2KoMor6JirXenr/S4VNF3KM03KRogixJQ1w6FJhbpEeOWFn6pfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fC8OXNaH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fC8OXNaH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8QQ+DkGq/TPZFhs6jqyCdzFqoMg+zkrinBIcXp5DV0=;
	b=fC8OXNaHe+bI2ukgSqJ47t4JZRWmkGeWBqVcuNV1W+gSqyt4hg9c/M1ceKDOroaQqb8dfV
	mKuIwumMBN9OHXBrWdOZTddEfvrhDae20YQxihuCiCr2RA72WG2gsgNSCfI85bdqBHXX+4
	DQSNikazwdmctm80I3S0aGF4WKYYnIo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-c5Q-to2QObC-IKcNM7hXJQ-1; Mon, 03 Jun 2024 17:56:09 -0400
X-MC-Unique: c5Q-to2QObC-IKcNM7hXJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C211A800CAC;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B714B200E576;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 4/8] dlm: use LSFL_FS to check if it's a kernel lockspace
Date: Mon,  3 Jun 2024 17:55:54 -0400
Message-ID: <20240603215558.2722969-5-aahringo@redhat.com>
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

This patch sets and uses the internal flag LSFL_FS to check in workqueue
handling if it's a kernel lockspace or not in the callback workqueue
handling. Currently user space lockspaces don't require the callback
workqueue. Upcoming changes will make it possible to remove the
the callback workqueue context switch when a specific lockspace flag is
passed. This patch prepares for such handling as some handling like
setting of LSFL_CB_DELAY is still required for those kernel lockspaces
but they don't have a callback workqueue.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c          | 17 +++++++++++------
 fs/dlm/dlm_internal.h |  1 +
 fs/dlm/lockspace.c    | 13 +++++++------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 59711486d801..52ce27031314 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -161,6 +161,9 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 
 int dlm_callback_start(struct dlm_ls *ls)
 {
+	if (!test_bit(LSFL_FS, &ls->ls_flags))
+		return 0;
+
 	ls->ls_callback_wq = alloc_ordered_workqueue("dlm_callback",
 						     WQ_HIGHPRI | WQ_MEM_RECLAIM);
 	if (!ls->ls_callback_wq) {
@@ -178,13 +181,15 @@ void dlm_callback_stop(struct dlm_ls *ls)
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
-	if (ls->ls_callback_wq) {
-		spin_lock_bh(&ls->ls_cb_lock);
-		set_bit(LSFL_CB_DELAY, &ls->ls_flags);
-		spin_unlock_bh(&ls->ls_cb_lock);
+	if (!test_bit(LSFL_FS, &ls->ls_flags))
+		return;
 
+	spin_lock_bh(&ls->ls_cb_lock);
+	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	spin_unlock_bh(&ls->ls_cb_lock);
+
+	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);
-	}
 }
 
 #define MAX_CB_QUEUE 25
@@ -195,7 +200,7 @@ void dlm_callback_resume(struct dlm_ls *ls)
 	int count = 0, sum = 0;
 	bool empty;
 
-	if (!ls->ls_callback_wq)
+	if (!test_bit(LSFL_FS, &ls->ls_flags))
 		return;
 
 more:
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 2c7ad3c5e893..3b026d80aa2b 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -726,6 +726,7 @@ struct dlm_ls {
 #define LSFL_CB_DELAY		9
 #define LSFL_NODIR		10
 #define LSFL_RECV_MSG_BLOCKED	11
+#define LSFL_FS			12
 
 #define DLM_PROC_FLAGS_CLOSING 1
 #define DLM_PROC_FLAGS_COMPAT  2
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index f54f43dbe7b6..be5dd5c990e5 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -500,12 +500,13 @@ static int new_lockspace(const char *name, const char *cluster,
 	list_add(&ls->ls_list, &lslist);
 	spin_unlock_bh(&lslist_lock);
 
-	if (flags & DLM_LSFL_FS) {
-		error = dlm_callback_start(ls);
-		if (error) {
-			log_error(ls, "can't start dlm_callback %d", error);
-			goto out_delist;
-		}
+	if (flags & DLM_LSFL_FS)
+		set_bit(LSFL_FS, &ls->ls_flags);
+
+	error = dlm_callback_start(ls);
+	if (error) {
+		log_error(ls, "can't start dlm_callback %d", error);
+		goto out_delist;
 	}
 
 	init_waitqueue_head(&ls->ls_recover_lock_wait);
-- 
2.43.0

