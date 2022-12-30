Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C55C4167B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Dec 2022 09:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiL3JIs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Dec 2022 04:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiL3JIn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Dec 2022 04:08:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CA4192B4
        for <linux-raid@vger.kernel.org>; Fri, 30 Dec 2022 01:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672391275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g+xfBZDkQNZ2NATLVEgNk5rpyqqiM+mfEnboEu8HMV8=;
        b=JqHgvfELD+a3nM30fDr7IUEnocz0nTXR31IGha+rkhWy/EM4UlefOKKUtGwfLEniEHFZO9
        Zw8t2sI67PaB2eDjzTqz/21YoASt6gdYaxnt0il+P5ZbuLekbmM2w4P7dPW9ZTJ33hbSG6
        nib0EoO2VpNQueldVQZQSIKWPnIORAo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-jH5TFr9TOCie0tgLyqsThw-1; Fri, 30 Dec 2022 04:07:52 -0500
X-MC-Unique: jH5TFr9TOCie0tgLyqsThw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 401CA3804069;
        Fri, 30 Dec 2022 09:07:52 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-20.pek2.redhat.com [10.72.13.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 681A7492B00;
        Fri, 30 Dec 2022 09:07:49 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: [PATCH 1/1] Don't handle change event against raw devices
Date:   Fri, 30 Dec 2022 17:07:48 +0800
Message-Id: <20221230090748.53598-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 udev-md-raid-assembly.rules | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 39b4344b8592..748ea05dadaa 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -11,6 +11,11 @@ SUBSYSTEM!="block", GOTO="md_inc_end"
 ENV{SYSTEMD_READY}=="0", GOTO="md_inc_end"
 
 # handle potential components of arrays (the ones supported by md)
+# For member devices which are md/dm devices, we don't need to
+# handle add event. Because md/dm devices need to do some init jobs.
+# Then the change event happens.
+# When adding md/dm devices, ID_FS_TYPE only be linux_raid_member
+# after change event happens.
 ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"
 
 # "noiswmd" on kernel command line stops mdadm from handling
@@ -28,6 +33,11 @@ GOTO="md_inc_end"
 
 LABEL="md_inc"
 
+# We only handle add event on raw disks. If we handle change event on raw disk,
+# the tool parted can't change partition table unless clear superblock on
+# member disks
+ACTION=="change", KERNEL!="dm-*|md*", GOTO="md_inc_end"
+
 # remember you can limit what gets auto/incrementally assembled by
 # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
 ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
-- 
2.32.0 (Apple Git-132)

