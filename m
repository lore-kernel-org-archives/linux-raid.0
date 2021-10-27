Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D03C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4918C60F9B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241869AbhJ0MZ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 08:25:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237338AbhJ0MZ4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 08:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635337410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=scBkAtCf/QLbYMmJdq1k9BSAIOE/ZJBkmn3SsdmlTXE=;
        b=hDJNTLtlRe5qQkRcDb7KHl7uA0mVSntHLs1tqXRVb/+0P0KDIMANvUnNznLMJHojVqfNyH
        B0ebvWWiOmkPtqJTYc+mXGL0iHyKr7Jt61fKQp39f2FkYw3SJtZM+gn9bOUGHLDnQ7L/oi
        bwgloit+WyLdI/BPsBBtsy+THyZ+peg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-eCWX-FOeMtuX3XafYXNP0Q-1; Wed, 27 Oct 2021 08:23:27 -0400
X-MC-Unique: eCWX-FOeMtuX3XafYXNP0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33EEE1808308;
        Wed, 27 Oct 2021 12:23:26 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54D2A5C1B4;
        Wed, 27 Oct 2021 12:23:15 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com,
        mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Subject: [PATCH 0/2] --detail show messy container name
Date:   Wed, 27 Oct 2021 20:23:12 +0800
Message-Id: <1635337394-4782-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch set tries to fix the bug that --detail show messy container
name. It adds a new method to check if one device is alive in first
patch.

V2:
use access rather than devid2kname

V3:
define a new function to check if disk is alive
include <stdbool.h> to use bool

Xiao Ni (2):
  mdadm/lib: Define a new helper function is_dev_alived
  mdadm/Detail: Can't show container name correctly when unpluging disks

 Detail.c | 16 ++++++++--------
 lib.c    | 11 +++++++++++
 mdadm.h  |  2 ++
 3 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.7.5

