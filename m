Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EDAC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiGYUiy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiGYUiv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 16:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E82522BF8
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 13:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658781529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIKKemJJInfKJ0/bRrW7N0Ef6BtisMRa/5nJk4tBp8g=;
        b=WucOTgw1B1hXZpY0L59OAC/mKPknA4LrWqolN7I3nN8Np7VGBFN+CHf3jhmtZNRurs6JM2
        /fX4hxVfW3uXCBGyPtrlCQC6cdOVwroJNlvIYZA3wLG8P2IuxUdkdAk2GPTbNHRldA/MKW
        K/vlDufvIhV3/gvW/mVMDJfJ3jIhudQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-duCneR4pNT6MAsNrzlZUPw-1; Mon, 25 Jul 2022 16:38:45 -0400
X-MC-Unique: duCneR4pNT6MAsNrzlZUPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C85D8101A588;
        Mon, 25 Jul 2022 20:38:44 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8977E40C128A;
        Mon, 25 Jul 2022 20:38:44 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, song@kernel.org, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 1/5] fs: dlm: remove dlm_del_ast prototype
Date:   Mon, 25 Jul 2022 16:38:31 -0400
Message-Id: <20220725203835.860277-2-aahringo@redhat.com>
In-Reply-To: <20220725203835.860277-1-aahringo@redhat.com>
References: <20220725203835.860277-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch removes dlm_del_ast() prototype which is not being used in
the dlm subsystem because there is not implementation for it.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index 181ad7d20c4d..e5e05fcc5813 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -11,7 +11,6 @@
 #ifndef __ASTD_DOT_H__
 #define __ASTD_DOT_H__
 
-void dlm_del_ast(struct dlm_lkb *lkb);
 int dlm_add_lkb_callback(struct dlm_lkb *lkb, uint32_t flags, int mode,
                          int status, uint32_t sbflags, uint64_t seq);
 int dlm_rem_lkb_callback(struct dlm_ls *ls, struct dlm_lkb *lkb,
-- 
2.31.1

