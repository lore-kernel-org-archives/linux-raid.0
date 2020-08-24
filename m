Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B718C433E1
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D3F20768
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 04:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/yUgsTx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHXEMA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 00:12:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725271AbgHXEL7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Aug 2020 00:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598242318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6gvhxdw5majYfAOIZs+RfrQB/jwZlcKw1n2wkQtD4S8=;
        b=S/yUgsTxMWByZWDb5R2pOw4b1CZNMVyev+2xSKn/ErXpirg1j2e8ct2fy8v9QXOfhT1w8/
        WUzhLVR2vpdsWjXEClv9c5CAN8gdxhwsxvaa2t5aMIy7puchYv2jYXvKqO7ryaA/VwHFHB
        wBQVE9VxyM/q+xYRc9HrhdQ9c2fGhMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-ni9rRdXXPXutA5UMG8kPkw-1; Mon, 24 Aug 2020 00:11:54 -0400
X-MC-Unique: ni9rRdXXPXutA5UMG8kPkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D2A151B6;
        Mon, 24 Aug 2020 04:11:53 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2536E7E69B;
        Mon, 24 Aug 2020 04:11:49 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V4 0/4] md/raid10: Improve handling raid10 discard request
Date:   Mon, 24 Aug 2020 12:11:43 +0800
Message-Id: <1598242308-9619-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
This patch set tries to resolve this problem.

v1:
Coly helps to review these patches and give some suggestions:
One bug is found. If discard bio is across one stripe but bio size is
bigger than one stripe size. After spliting, the bio will be NULL.
In this version, it checks whether discard bio size is bigger than
(2*stripe_size). 
In raid10_end_discard_request, it's better to check R10BIO_Uptodate
is set or not. It can avoid write memory to improve performance. 
Add more comments for calculating addresses.

v2:
Fix error by checkpatch.pl
Fix one bug for offset layout. v1 calculates wrongly split size
Add more comments to explain how the discard range of each component disk
is decided.

v3:
add support for far layout
Change the patch name

v4:
Pull codes that wait for blocked device into a seprate function
It can't use (stripe_size-1) as a mask to calculate. (stripe_size-1) may
not be power of 2.
It doesn't need to use a full copy of geo.
Fix warning by checkpatch.pl

Xiao Ni (5):
  md/raid10: move codes related with submitting discard bio into one
    function
  md/raid10: extend r10bio devs to raid disks
  md/raid10: pull codes that wait for blocked dev into one function
  md/raid10: improve raid10 discard request
  md/raid10: improve discard request for far layout

 drivers/md/md.c     |  23 +++
 drivers/md/md.h     |   3 +
 drivers/md/raid0.c  |  15 +-
 drivers/md/raid10.c | 419 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid10.h |   1 +
 5 files changed, 391 insertions(+), 70 deletions(-)

-- 
2.7.5

