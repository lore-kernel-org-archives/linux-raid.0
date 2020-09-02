Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9304C433E2
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FCD2078B
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ug+z0wla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIBMB0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgIBMBE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 08:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599048055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gVenz3WFXJ/gXjGecmhDSZsz7lYbhjpQgjaEGPo4bH8=;
        b=Ug+z0wlalh8ihtPPDy+NRj38UGGLhbOneakb7uEFHkyXHWdNTGnznGOBOt7JUWG2ENkPSs
        Tf3hxNxcKufiPQ46Xhm31H+30AKUATVs9w3QKOTlRsm99CS2EjqnImdIio/zNUxRtOrVNQ
        RB0KYacSa7zQipC9FjQh7rienz1WnRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-sJzGYayYOIGb9i0166Jhjw-1; Wed, 02 Sep 2020 08:00:48 -0400
X-MC-Unique: sJzGYayYOIGb9i0166Jhjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A295818C5224;
        Wed,  2 Sep 2020 12:00:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE69C811B3;
        Wed,  2 Sep 2020 12:00:25 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
Subject: [PATCH V6 0/3] md/raid10: Improve handling raid10 discard request
Date:   Wed,  2 Sep 2020 20:00:20 +0800
Message-Id: <1599048023-9957-1-git-send-email-xni@redhat.com>
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

v5:
In 32bit platform, it doesn't support 64bit devide by 32bit value.
Reported-by: kernel test robot <lkp@intel.com>

v6:
Move the codes that calculate discard start/size into specific raid type.
Remove discard support for reshape

Xiao Ni (3):
  md: calculate discard start address and size in specific raid type
  md/raid10: improve raid10 discard request
  md/raid10: improve discard request for far layout

 drivers/md/md.c     |   9 +-
 drivers/md/md.h     |   3 +-
 drivers/md/raid0.c  |   5 +-
 drivers/md/raid10.c | 296 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid10.h |   1 +
 5 files changed, 303 insertions(+), 11 deletions(-)

-- 
2.7.5

