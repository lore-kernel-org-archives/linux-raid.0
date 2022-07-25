Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF36C43334
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 20:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiGYUiw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiGYUiu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 16:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F55022BF7
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658781528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sogPp70ZC2D8gfw2PwjlEtTgvtGFqDXiU9fOvLqURpk=;
        b=ceQIpDaPg1Fqm7KAWDpxZOVfbEYK33zN1JwAAHid2FgMp+GRJTafbhYVAjWUGq/7+IMSQH
        U0YeNT5Je9jwF3Vw+XohdiRbmZnJgKsZ9P/R3SUmbcvtMLrrzvGZ6wXXbzA3M8NuJpnZV9
        fa4mGj1gCbBX0bYbCv9tjyCZ07Piduo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-uwt5IIAEPmOKezaDzdh2og-1; Mon, 25 Jul 2022 16:38:45 -0400
X-MC-Unique: uwt5IIAEPmOKezaDzdh2og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 811693801144;
        Mon, 25 Jul 2022 20:38:44 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B73B40C128A;
        Mon, 25 Jul 2022 20:38:44 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, song@kernel.org, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-raid@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 0/5] fs: dlm: misc cleanups
Date:   Mon, 25 Jul 2022 16:38:30 -0400
Message-Id: <20220725203835.860277-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

as I am working on some bigger change in the callback handling I
separated this patch series from a bigger series. This series removes
unused prototype, change a lock to spinlock because no sleepable
context, adding traces for user space locks, moving DLM_LSFL_FS out of
uapi because the user space should never set this flag and move
LSFL_CB_DELAY to kernel space lockspaces only.

- Alex

Alexander Aring (5):
  fs: dlm: remove dlm_del_ast prototype
  fs: dlm: change ls_clear_proc_locks to spinlock
  fs: dlm: trace user space callbacks
  fs: dlm: move DLM_LSFL_FS out of uapi
  fs: dlm: LSFL_CB_DELAY only for kernel lockspaces

 drivers/md/md-cluster.c    |  4 ++--
 fs/dlm/ast.c               | 13 +++++++------
 fs/dlm/ast.h               |  1 -
 fs/dlm/dlm_internal.h      |  2 +-
 fs/dlm/lock.c              | 32 ++++++++++++++++++++++++--------
 fs/dlm/lockspace.c         | 30 +++++++++++++++++++++++++-----
 fs/dlm/lockspace.h         | 13 +++++++++++++
 fs/dlm/user.c              | 17 +++++++++++------
 fs/gfs2/lock_dlm.c         |  2 +-
 fs/ocfs2/stack_user.c      |  2 +-
 include/linux/dlm.h        |  3 ---
 include/trace/events/dlm.h | 23 +++++++++++++----------
 include/uapi/linux/dlm.h   |  1 -
 13 files changed, 98 insertions(+), 45 deletions(-)

-- 
2.31.1

