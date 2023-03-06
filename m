Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE6CC64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCFV2y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFV2t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A29540F0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9g7qAixEI846n6XIs+xIk3Ss7B9Pp+aVhiK8mZ6qzL0=;
        b=JpQjeXJJE/1u8b18ZO94IopgeXQOPidMp8Zj3uztZ3MEA8uzZD+la54Dssd69ncMfif5Gr
        GhxPf7de9j10Emm0ES7xRsEpzMGO/71KIn72IQcxjdtaM1+yGMqy2ECl2n5W7LFq1zjBxy
        l92tnT+oQtvtgxtq2d/9QSMvALT+rIE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-BsX42k0GMdiDd9w7h_KPWA-1; Mon, 06 Mar 2023 16:27:59 -0500
X-MC-Unique: BsX42k0GMdiDd9w7h_KPWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4EF3802D2F
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:27:58 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFED8401B290;
        Mon,  6 Mar 2023 21:27:57 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 00/34] address various checkpatch.pl requirements
Date:   Mon,  6 Mar 2023 22:27:23 +0100
Message-Id: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: heinzm <heinzm@redhat.com>

This patch series addresses checkpatch.pl reuirements.

It is grouped into patches addressing errors first then warnings.
Each patch fixes flaws in one semantical respect (e.g. fix spaces).

Series passed upstream regression tests succesfully.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Reviewed-by: Nigel Croxon <ncroxon@redhat.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Tested-by: Nigel Croxon <ncroxon@redhat.com>
Tested-by: Xiao Ni <xni@redhat.com>

Heinz Mauelshagen (34):
  md: fix required/prohibited spaces [ERROR]
  md: fix 'foo*' and 'foo * bar' [ERROR]
  md: fix EXPORT_SYMBOL() to follow its functions immediately [ERROR]
  md: adjust braces on functions/structures [ERROR]
  md: correct code indent [ERROR]
  md: move trailing statements to next line [ERROR]
  md: consistent spacing around operators [ERROR]
  md: don't initialize statics/globals to 0/false [ERROR]
  md: else should follow close curly brace [ERROR]
  md: remove trailing whitespace [ERROR]
  md: do not use assignment in if condition [ERROR]
  md: add missing blank line after declaration [WARNING]
  md: space prohibited between function and opening parenthesis [WARNING]
  md: prefer seq_put[cs]() to seq_printf() |WARNING]
  md: avoid multiple line dereference [WARNING}
  md: fix block comments [WARNING]
  md: add missing function identifier names to function definition arguments [WARNING]
  md: avoid redundant braces in single line statements [WARNING]
  md: place constant on the right side of a test [WARNING]
  md: avoid pointless filenames in files [WARNING]
  md: avoid useless else after break or return [WARNING]
  md: don't indent labels [WARNING]
  md: fix code indent for conditional statements [WARNING]
  md: prefer octal permissions [WARNING]
  md: remove bogus IS_ENABLED() macro [WARNING]
  md autodetect: correct placement of __initdata [WARNING]
  md: prefer using "%s...", __func__ [WARNING]
  md pq: adjust __attribute__ [WARNING]
  md: prefer 'unsigned int' [WARNING]
  md: prefer kmap_local_page() instead of deprecated kmap_atomic() [WARNING]
  md raid5: prefer 'int' instead of 'signed' [WARNING]
  md: prefer kvmalloc_array() with multiply [WARNING]
  md: avoid splitting quoted strings [WARNING]
  md: avoid return in void functions [WARNING]

 drivers/md/md-autodetect.c |  18 +-
 drivers/md/md-bitmap.c     | 159 ++++----
 drivers/md/md-bitmap.h     |   2 +-
 drivers/md/md-cluster.c    |  51 ++-
 drivers/md/md-faulty.c     |  43 ++-
 drivers/md/md-linear.c     |  33 +-
 drivers/md/md-linear.h     |   3 +-
 drivers/md/md-multipath.c  |  52 +--
 drivers/md/md.c            | 755 +++++++++++++++++++------------------
 drivers/md/md.h            |  17 +-
 drivers/md/raid0.c         |  70 ++--
 drivers/md/raid1-10.c      |   3 +-
 drivers/md/raid1.c         |  91 +++--
 drivers/md/raid10.c        | 174 +++++----
 drivers/md/raid5-cache.c   |  41 +-
 drivers/md/raid5-ppl.c     |  16 +-
 drivers/md/raid5.c         | 293 +++++++-------
 include/linux/raid/pq.h    |  33 +-
 include/linux/raid/xor.h   |  34 +-
 19 files changed, 1032 insertions(+), 856 deletions(-)

-- 
2.39.2

