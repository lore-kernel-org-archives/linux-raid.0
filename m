Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A951C43461
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4E2214F1
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8StPxks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgINFiL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 01:38:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726003AbgINFiK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Sep 2020 01:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600061905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=1WPKf7RcxOAdWs/rab8XU75W2ugrCa5JJUzBxtrI2vU=;
        b=Q8StPxksqMFCtruWoFIM9Coh4pPnqTCFCX9YCS/Kv6jWbNLY6NhrAXCghm9JcFjBVDvbGc
        XEGve/UX6Vyhk5ZcHeQ2uWfwYuUqPNzC2D/ramb7hybskLJbuVizO55m0rJa1y4tFNeN34
        Rg5r/MFK/NPHrOqKzWDxhP/8+31qE5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-TckU_yxFMmSdElQTAAmxCg-1; Mon, 14 Sep 2020 01:38:23 -0400
X-MC-Unique: TckU_yxFMmSdElQTAAmxCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F38481005E6D;
        Mon, 14 Sep 2020 05:38:21 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78AB55C893;
        Mon, 14 Sep 2020 05:38:17 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com
Subject: [mdadm PATCH 0/2] Some fixes for mdadm
Date:   Mon, 14 Sep 2020 13:38:13 +0800
Message-Id: <1600061895-16330-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

These two patches fix some mdadm problems. The first is to avoid one raid being
not active after boot. The second patch is to check journal device when creating
bitmap.

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

