Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DD3C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 20:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbiGYUiv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiGYUiu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 16:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8895722BF5
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658781528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFks5NMd4f1nVcmXW8iPb003X6v5Rn8Pambi3h60UGU=;
        b=IeiiKEbpKjWNCbOfzfmL5IA4F52GVibIeiXH7HhpuL80L8q96H1mF6CGSrWzf1DkmXfqxz
        fSvnv19Hs7f+IVKfH2tUJPOGlVEOtjgnKTUiA/imkHlf0UKI7mcnYwq22FdB0oYKi3MhCA
        ltqnlUitgIUj2As2j7D5/jhO+KpcLJM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-NFtFJNLZPHiDGzqGoMuu2w-1; Mon, 25 Jul 2022 16:38:45 -0400
X-MC-Unique: NFtFJNLZPHiDGzqGoMuu2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ABA73C025CE;
        Mon, 25 Jul 2022 20:38:45 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0B13403D0D9;
        Mon, 25 Jul 2022 20:38:44 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, song@kernel.org, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 2/5] fs: dlm: change ls_clear_proc_locks to spinlock
Date:   Mon, 25 Jul 2022 16:38:32 -0400
Message-Id: <20220725203835.860277-3-aahringo@redhat.com>
In-Reply-To: <20220725203835.860277-1-aahringo@redhat.com>
References: <20220725203835.860277-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch changes the ls_clear_proc_locks to a spinlock because there
is no need to handle it as a mutex as there is no sleepable context when
ls_clear_proc_locks is held. This allows us to call those functionality
in non-sleepable contexts.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/dlm_internal.h | 2 +-
 fs/dlm/lock.c         | 8 ++++----
 fs/dlm/lockspace.c    | 2 +-
 fs/dlm/user.c         | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 8aca8085d24e..e34c3d2639a5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -661,7 +661,7 @@ struct dlm_ls {
 	spinlock_t		ls_recover_idr_lock;
 	wait_queue_head_t	ls_wait_general;
 	wait_queue_head_t	ls_recover_lock_wait;
-	struct mutex		ls_clear_proc_locks;
+	spinlock_t		ls_clear_proc_locks;
 
 	struct list_head	ls_root_list;	/* root resources */
 	struct rw_semaphore	ls_root_sem;	/* protect root_list */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 061fa96fc978..4c7ed4bec3f4 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -6208,7 +6208,7 @@ static struct dlm_lkb *del_proc_lock(struct dlm_ls *ls,
 {
 	struct dlm_lkb *lkb = NULL;
 
-	mutex_lock(&ls->ls_clear_proc_locks);
+	spin_lock(&ls->ls_clear_proc_locks);
 	if (list_empty(&proc->locks))
 		goto out;
 
@@ -6220,7 +6220,7 @@ static struct dlm_lkb *del_proc_lock(struct dlm_ls *ls,
 	else
 		lkb->lkb_flags |= DLM_IFL_DEAD;
  out:
-	mutex_unlock(&ls->ls_clear_proc_locks);
+	spin_unlock(&ls->ls_clear_proc_locks);
 	return lkb;
 }
 
@@ -6257,7 +6257,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 		dlm_put_lkb(lkb);
 	}
 
-	mutex_lock(&ls->ls_clear_proc_locks);
+	spin_lock(&ls->ls_clear_proc_locks);
 
 	/* in-progress unlocks */
 	list_for_each_entry_safe(lkb, safe, &proc->unlocking, lkb_ownqueue) {
@@ -6273,7 +6273,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 		dlm_put_lkb(lkb);
 	}
 
-	mutex_unlock(&ls->ls_clear_proc_locks);
+	spin_unlock(&ls->ls_clear_proc_locks);
 	dlm_unlock_recovery(ls);
 }
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 6e449abdc5f4..3cf4790dfb8b 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -584,7 +584,7 @@ static int new_lockspace(const char *name, const char *cluster,
 	atomic_set(&ls->ls_requestqueue_cnt, 0);
 	init_waitqueue_head(&ls->ls_requestqueue_wait);
 	mutex_init(&ls->ls_requestqueue_mutex);
-	mutex_init(&ls->ls_clear_proc_locks);
+	spin_lock_init(&ls->ls_clear_proc_locks);
 
 	/* Due backwards compatibility with 3.1 we need to use maximum
 	 * possible dlm message size to be sure the message will fit and
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 999918348b31..c6d38a06e94c 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -184,7 +184,7 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 		return;
 
 	ls = lkb->lkb_resource->res_ls;
-	mutex_lock(&ls->ls_clear_proc_locks);
+	spin_lock(&ls->ls_clear_proc_locks);
 
 	/* If ORPHAN/DEAD flag is set, it means the process is dead so an ast
 	   can't be delivered.  For ORPHAN's, dlm_clear_proc_locks() freed
@@ -230,7 +230,7 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, uint32_t flags, int mode,
 		spin_unlock(&proc->locks_spin);
 	}
  out:
-	mutex_unlock(&ls->ls_clear_proc_locks);
+	spin_unlock(&ls->ls_clear_proc_locks);
 }
 
 static int device_user_lock(struct dlm_user_proc *proc,
-- 
2.31.1

