Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB98C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 05:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhLIF7J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 00:59:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhLIF7J (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 00:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639029335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=6kYk6rZ4rcdTh0fVwmdmTfEcfkfxj+A1KkfJASjcNMs=;
        b=MexcD7mV6NZt0o32dcZ05YviGmifUKz1Ncvy/cN3RjchAF0bjasWeleJH9VxvCdOiHWYHS
        j6GZQEmgIAOjYaAW/iWFy6ikhdj7Ry8GvuEFd00sMNVhWV5mk9+8AkzuhRFwRnxG/hFyss
        Ds1tXvj1na1rM8o5LGytUGii+ost6R0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-zuN8c51TMUauqOXCR3wbtQ-1; Thu, 09 Dec 2021 00:55:32 -0500
X-MC-Unique: zuN8c51TMUauqOXCR3wbtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F5802F2C;
        Thu,  9 Dec 2021 05:55:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 712D6100AE2C;
        Thu,  9 Dec 2021 05:55:26 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 0/2] md: it panic after reshape from raid1 to raid5
Date:   Thu,  9 Dec 2021 13:55:22 +0800
Message-Id: <1639029324-4026-1-git-send-email-xni@redhat.com>
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

