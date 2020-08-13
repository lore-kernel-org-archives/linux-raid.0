Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA7BC433DF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 06:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 740E52078B
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 06:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPPWS35j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgHMGo7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 02:44:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725964AbgHMGo7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Aug 2020 02:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597301098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=coF8U/YtKy0lczLfe5+UaOxQ731Jr+o9jES93x+fXXw=;
        b=KPPWS35jfdBGuMYeEbyt73PrTvSE6luo8++fAQsdnMKpfB7QDNDiqxYGI2E9G7zwXj5ZeI
        UfylYqUmDII2MNovAuSjeFsR+6jNTH3iai/w7reiRS+q4GancYdBmxMEv5te6us9WPuYkP
        wL/eZ/OrgKH43u88HklFov2PrHMMAMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-kHlIGns8ON2np7yxnmOlHg-1; Thu, 13 Aug 2020 02:44:54 -0400
X-MC-Unique: kHlIGns8ON2np7yxnmOlHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCAB1180DE23;
        Thu, 13 Aug 2020 06:44:52 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E46EB69323;
        Thu, 13 Aug 2020 06:44:49 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, guoqing.jiang@cloud.ionos.com, heinzm@redhat.com,
        ncroxon@redhat.com
Subject: [md PATCH V3 0/4] Improve handling raid10 discard request
Date:   Thu, 13 Aug 2020 14:44:43 +0800
Message-Id: <1597301087-6565-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
This patch set tries to resolve this problem.

v1:
Coly helps to review these patches and give some suggestions:
One bug is found. If discard bio is across one stripe but bio size is bigger
than one stripe size. After spliting, the bio will be NULL. In this version,
it checks whether discard bio size is bigger than 2*stripe_size.
In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
or not. It can avoid write memory to improve performance.
Add more comments for calculating addresses.

v2:
Fix error by checkpatch.pl
Fix one bug for offset layout. v1 calculates wrongly split size
Add more comments to explain how the discard range of each component disk
is decided.

v3:
add support for far layout

Xiao Ni (4):
  Move codes related with submitting discard bio into one function
  extend r10bio devs to raid disks
  improve raid10 discard request
  Improve discard request for far layout

 drivers/md/md.c     |  23 ++++
 drivers/md/md.h     |   3 +
 drivers/md/raid0.c  |  15 +--
 drivers/md/raid10.c | 338 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid10.h |   1 +
 5 files changed, 361 insertions(+), 19 deletions(-)

-- 
2.7.5

