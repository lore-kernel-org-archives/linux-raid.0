Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D35CC004D4
	for <linux-raid@archiver.kernel.org>; Wed, 18 Jan 2023 10:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjARK12 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Jan 2023 05:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjARK0n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Jan 2023 05:26:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7EAB2E5A
        for <linux-raid@vger.kernel.org>; Wed, 18 Jan 2023 01:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674034216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zWi81MveFELYsaCaE8yrVhKn58FChcX9uZDU7kiLqf8=;
        b=W6GNdttKX1t8rTcTQZJBzJR/ByfzvJBUtQXyjNeFinU4PwZ4pM8qxfiqaXf8HsEcHFaBd8
        ALuip4Cl0qGdac8BNUK7lUGer0po83zIxyfaRm6eOVR+GnM76V1X2NyjFFl6lfzqtCCtXv
        oStDBYTQSvPqTyAnZw4hbmQbjVyAJzM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-fywTSqYaMVO-4KPaHul2cw-1; Wed, 18 Jan 2023 04:30:13 -0500
X-MC-Unique: fywTSqYaMVO-4KPaHul2cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B80C8A0108;
        Wed, 18 Jan 2023 09:30:13 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-71.pek2.redhat.com [10.72.12.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9FEF2166B26;
        Wed, 18 Jan 2023 09:30:10 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 0/4] Change some counters to percpu type
Date:   Wed, 18 Jan 2023 17:30:04 +0800
Message-Id: <20230118093008.67170-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

There are two main changes in the patch set.

The first is to change ->active_io to percpu(patch02). The second
one is adding a counter for io_acct(patch03).

Xiao Ni (4):
  Factor out is_md_suspended helper
  Change active_io to percpu
  Add mddev->io_acct_cnt for raid0_quiesce
  Free writes_pending in md_stop

 drivers/md/md.c    | 69 ++++++++++++++++++++++++++++++++++------------
 drivers/md/md.h    | 11 +++++---
 drivers/md/raid0.c |  6 ++++
 3 files changed, 65 insertions(+), 21 deletions(-)

-- 
2.32.0 (Apple Git-132)

