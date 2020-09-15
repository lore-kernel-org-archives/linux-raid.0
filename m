Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D52C43461
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 07:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A5B21974
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 07:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eA1pHfJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIOHq4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:46:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgIOHov (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Sep 2020 03:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600155891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=MFaD1AKk5ATyDN93ja7oJAXP+9SuiJh4ctESObS1DtE=;
        b=eA1pHfJJnSxAeMRnxVBE5mmqbR1cwN042Ca3ZLxKG7YhGaQgWwNwmrTo8290NmxhRNaT+V
        IO/xWrfvPze+jZELpveACGoMrU5wE4/oDBbrFzWXKaT7RXqTln14xMi8wb0a0EN9LexlnK
        VG9lSyrIpu/WQYmpmKJThN5JDAQZw+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-gvIsLjuFNfan7E_dWCGnwA-1; Tue, 15 Sep 2020 03:44:49 -0400
X-MC-Unique: gvIsLjuFNfan7E_dWCGnwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3CCE10BBEC2;
        Tue, 15 Sep 2020 07:44:47 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-36.pek2.redhat.com [10.72.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A74C927BBC;
        Tue, 15 Sep 2020 07:44:44 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com, antmbox@youngman.org.uk
Subject: [PATCH V2 0/2] Some fixes for mdadm
Date:   Tue, 15 Sep 2020 15:44:40 +0800
Message-Id: <1600155882-4488-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

These two patches fix some mdadm problems. The first is to avoid one raid being
not active after boot. The second patch is to check journal device when creating
bitmap.

v2:Change patch1's comments to make it more clear

Xiao Ni (2):
  Check hostname file empty or not when creating raid device
  Don't create bitmap for raid5 with journal disk

 Create.c |  1 +
 mdadm.c  |  3 +++
 mdadm.h  |  1 +
 util.c   | 19 +++++++++++++++++++
 4 files changed, 24 insertions(+)

-- 
2.7.5

