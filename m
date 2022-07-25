Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D62DC43334
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 20:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbiGYUiy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiGYUiv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 16:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB3402314F
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 13:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658781529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVy0+ZulU9PvKvHz6Mig7aRQnyZfhbu1qn+goFMpuvY=;
        b=f96ClJqLCDmDDau+XYR+kICpf9aQ5+8J4VETbvWgfAYIYFLO1q9vMtSPqkxPoA+Odl94KR
        T8heCh9vAHQQveOOpRJ8lmUpgRVbNDbX5mGEGuT8GXPDIrfrgsBCWbJrLKr6oGGdDGU3Oq
        US1MlV5Ii1P8lMyL02+MsqQghbNTXdw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-bk1p3Si8NUqK1IqVsjoP_g-1; Mon, 25 Jul 2022 16:38:46 -0400
X-MC-Unique: bk1p3Si8NUqK1IqVsjoP_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDAD98032FB;
        Mon, 25 Jul 2022 20:38:45 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFD1240D2962;
        Mon, 25 Jul 2022 20:38:45 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, song@kernel.org, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 5/5] fs: dlm: LSFL_CB_DELAY only for kernel lockspaces
Date:   Mon, 25 Jul 2022 16:38:35 -0400
Message-Id: <20220725203835.860277-6-aahringo@redhat.com>
In-Reply-To: <20220725203835.860277-1-aahringo@redhat.com>
References: <20220725203835.860277-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch only set/clear the LSFL_CB_DELAY bit when it's actually a
kernel lockspace signaled by if ls->ls_callback_wq is set or not set in
this case. User lockspaces will never evaluate this flag.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index a44cc42b6317..d60a8d8f109d 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -288,12 +288,13 @@ void dlm_callback_stop(struct dlm_ls *ls)
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
-	mutex_lock(&ls->ls_cb_mutex);
-	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
-	mutex_unlock(&ls->ls_cb_mutex);
+	if (ls->ls_callback_wq) {
+		mutex_lock(&ls->ls_cb_mutex);
+		set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+		mutex_unlock(&ls->ls_cb_mutex);
 
-	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);
+	}
 }
 
 #define MAX_CB_QUEUE 25
@@ -304,11 +305,11 @@ void dlm_callback_resume(struct dlm_ls *ls)
 	int count = 0, sum = 0;
 	bool empty;
 
-	clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
-
 	if (!ls->ls_callback_wq)
 		return;
 
+	clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
+
 more:
 	mutex_lock(&ls->ls_cb_mutex);
 	list_for_each_entry_safe(lkb, safe, &ls->ls_cb_delay, lkb_cb_list) {
-- 
2.31.1

