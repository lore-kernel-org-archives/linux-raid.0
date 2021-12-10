Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7320AC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 09:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhLJJfN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 04:35:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhLJJfM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 10 Dec 2021 04:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639128697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6kYk6rZ4rcdTh0fVwmdmTfEcfkfxj+A1KkfJASjcNMs=;
        b=iUgoQr7FGLe5zZYQ4Gw+Pwl4Ay+kUU9jeZHKco3i9oRUs/uiLjAT/cKn/2tkDK2YHeZ4Qx
        qz+V+uPQ2mNQOR4a9z+grEfUxRxceL9jH3ShWo+qjWt1e/eO4VIksrEBO5wmUhaAIkm8jE
        dXbXlb43/lVq5HB3yTFtRRfUSgDTfRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-HrD9cNH9M2GiM3sHNHefIA-1; Fri, 10 Dec 2021 04:31:33 -0500
X-MC-Unique: HrD9cNH9M2GiM3sHNHefIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656541853024;
        Fri, 10 Dec 2021 09:31:32 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A0C21001F4D;
        Fri, 10 Dec 2021 09:31:22 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 0/2] md: it panice after reshape from raid1 to raid5
Date:   Fri, 10 Dec 2021 17:31:14 +0800
Message-Id: <20211210093116.7847-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

After reshape from raid1 to raid5, it can panice when there are I/Os

The steps can reproduce this:
mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1
mdadm --wait /dev/md0
mkfs.xfs /dev/md0
mdadm /dev/md0 --grow -l5
mount /dev/md0 /mnt

These two patches fix this problem.

Xiao Ni (2):
  Free r0conf memory when register integrity failed
  Move alloc/free acct bioset in to personality

 drivers/md/md.c    | 27 +++++++++++++++++----------
 drivers/md/md.h    |  2 ++
 drivers/md/raid0.c | 28 ++++++++++++++++++++++++----
 drivers/md/raid5.c | 41 ++++++++++++++++++++++++++++++-----------
 4 files changed, 73 insertions(+), 25 deletions(-)

-- 
2.31.1

