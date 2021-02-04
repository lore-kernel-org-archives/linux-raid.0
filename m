Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0275CC433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05DB64F58
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 05:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBDF65 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 00:58:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhBDF64 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 00:58:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612418250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ewVN+e7o9bcV6tHm7OUWK7tQehJHV4ezJFmspWN9YiY=;
        b=MXiKVmfX/wAvShFU8O1EED+BuwD3BVs7JUjcvYdyJJW/UVs43+ozlvIZRdme5euFwL84mO
        7zWH5vU+kSD0Wc6IZSFO/ZDma67CD3KMQ6lSicUmanY5Jv8D6ty85YZw5u3o1RmkB/Qs8/
        sNZyOtg7YC5i/4pPz2h1/kLaApA95KE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-JtD0p3ZqMaKCoAJOepQidQ-1; Thu, 04 Feb 2021 00:57:26 -0500
X-MC-Unique: JtD0p3ZqMaKCoAJOepQidQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F34985EE8F;
        Thu,  4 Feb 2021 05:57:24 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E671760C5F;
        Thu,  4 Feb 2021 05:57:20 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com,
        hch@infradead.org
Subject: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
Date:   Thu,  4 Feb 2021 13:57:13 +0800
Message-Id: <1612418238-9976-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
This patch set tries to resolve this problem.

This patch set had been reverted because of a data corruption problem. This
version fix this problem. The root cause which causes the data corruption is
the wrong calculation of start address of near copies disks.

Now we use a similar way with raid0 to handle discard request for raid10.
Because the discard region is very big, we can calculate the start/end
address for each disk. Then we can submit the discard request to each disk.
But for raid10, it has copies. For near layout, if the discard request
doesn't align with chunk size, we calculate a start_disk_offset. Now we only
use start_disk_offset for the first disk, but it should be used for the
near copies disks too.

[  789.709501] discard bio start : 70968, size : 191176
[  789.709507] first stripe index 69, start disk index 0, start disk offset 70968
[  789.709509] last stripe index 256, end disk index 0, end disk offset 262144
[  789.709511] disk 0, dev start : 70968, dev end : 262144
[  789.709515] disk 1, dev start : 70656, dev end : 262144

For example, in this test case, it has 2 near copies. The start_disk_offset
for the first disk is 70968. It should use the same offset address for second disk.
But it uses the start address of this chunk. It discard more region. This version
simply spilt the un-aligned part with strip size.

And it fixes another problem. The calculation of stripe_size is wrong in reverted version.

V2: Fix problems pointed by Christoph Hellwig.

Xiao Ni (5):
  md: add md_submit_discard_bio() for submitting discard bio
  md/raid10: extend r10bio devs to raid disks
  md/raid10: pull the code that wait for blocked dev into one function
  md/raid10: improve raid10 discard request
  md/raid10: improve discard request for far layout

 drivers/md/md.c     |  20 +++
 drivers/md/md.h     |   2 +
 drivers/md/raid0.c  |  14 +-
 drivers/md/raid10.c | 434 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid10.h |   1 +
 5 files changed, 402 insertions(+), 69 deletions(-)

-- 
2.7.5

