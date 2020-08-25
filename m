Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01476C433E3
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 05:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBCE204FD
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 05:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iagnMtfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgHYFnP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728145AbgHYFnO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 Aug 2020 01:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598334193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HWZE5Oydl8ZzX86wV0HMJtdEIoK/YcylsKYoshYivVg=;
        b=iagnMtfF4k94pbDWbZhwb0n1B2d2G7XnQ/LzEYmekbD+EBrr/BPaK9kazGc8h/VErATIU4
        cbYO7ZepGmP/8LAM7DAsZcBN1Gy6H0qpiUuNLc8lVJPhy/2wjGdYdDJs2UL2x36qnaOBFl
        LN1iovxSLPIxEP+TEyZyZz403qXPG60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-frzqic2cP3S0I6TkyWjchA-1; Tue, 25 Aug 2020 01:43:09 -0400
X-MC-Unique: frzqic2cP3S0I6TkyWjchA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7ACB84635B;
        Tue, 25 Aug 2020 05:43:08 +0000 (UTC)
Received: from xiao.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A65A100239B;
        Tue, 25 Aug 2020 05:43:04 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V5 0/5] md/raid10: Improve handling raid10 discard request
Date:   Tue, 25 Aug 2020 13:42:58 +0800
Message-Id: <1598334183-25301-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

v5:
In 32bit platform, it doesn't support 64bit devide by 32bit value.
Reported-by: kernel test robot <lkp@intel.com>

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
 drivers/md/raid10.c | 422 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid10.h |   1 +
 5 files changed, 394 insertions(+), 70 deletions(-)

-- 
2.7.5

