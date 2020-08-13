Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7592AC433DF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 08:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42ADC20781
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 08:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8wnXr0C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHMIOt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 04:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbgHMIOs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 Aug 2020 04:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597306486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2HaQ6cuKphXN/1AIGjsEf8BhjU0t44Jm4mjQgEi2BgQ=;
        b=Z8wnXr0CmC5aXnsio+EbpnKBIXIhgVM9crVGMox8xUOGf8f9Iaj/1i+/yBiQKvYIGks40T
        Hb7BzzWmeORXTPkS91AutvogwWCCTGYzBho1bYyVMGZRkbPIbq/dIB4POvPYF5K5S9R6fu
        p4V3pZ0nLdKGYmsnUzubBXkn/7Nnjpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-kPWdvyLcMfmptutPssBqwQ-1; Thu, 13 Aug 2020 04:14:42 -0400
X-MC-Unique: kPWdvyLcMfmptutPssBqwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B64F6106B1CA;
        Thu, 13 Aug 2020 08:14:41 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63E32600D4;
        Thu, 13 Aug 2020 08:14:37 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     colyli@suse.de, guoqing.jiang@cloud.ionos.com, heinzm@redhat.com,
        ncroxon@redhat.com
Subject: [PATCH V3 0/4] md/raid10: Improve handling raid10 discard request
Date:   Thu, 13 Aug 2020 16:14:32 +0800
Message-Id: <1597306476-8396-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Change the patch name

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

