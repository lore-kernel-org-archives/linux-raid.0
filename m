Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6F0C76196
	for <linux-raid@archiver.kernel.org>; Fri,  7 Apr 2023 00:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjDGAqZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Apr 2023 20:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDGAqY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Apr 2023 20:46:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E716EA1
        for <linux-raid@vger.kernel.org>; Thu,  6 Apr 2023 17:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680828336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OAK2MVwskbD4sv0QXFxEpgJJ2jIM2d/e5FTZqVMwUnA=;
        b=MmdkxGymMyZq9vdbffqRs01ULPWLoeGmyBDJJjdDEdPmsBbVW4OncC6kFNkwqT65xZiJFU
        10uflrLdQJgDcKb4O8w/UIxPPAEOVbouhrirc0XgnepqGkSIiLMRrJuIh699wSEzaOpbyJ
        0Qs3eHf9Qqd5aciJ09dAoMgOhcp10Kw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-etoEZvLFMJehl59shG5ntQ-1; Thu, 06 Apr 2023 20:45:33 -0400
X-MC-Unique: etoEZvLFMJehl59shG5ntQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07D83884343;
        Fri,  7 Apr 2023 00:45:33 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 037E8440D8;
        Fri,  7 Apr 2023 00:45:30 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     neilb@suse.de, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] Remove the config files in mdcheck_start|continue service
Date:   Fri,  7 Apr 2023 08:45:28 +0800
Message-Id: <20230407004528.59539-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We set MDADM_CHECK_DURATION in the mdcheck_start|continue.service files.
And mdcheck doesn't use any configs from the config file. So we can remove
the dependencies.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 systemd/mdcheck_continue.service | 2 --
 systemd/mdcheck_start.service    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/systemd/mdcheck_continue.service b/systemd/mdcheck_continue.service
index 854317f11700..f576e0167f3c 100644
--- a/systemd/mdcheck_continue.service
+++ b/systemd/mdcheck_continue.service
@@ -12,6 +12,4 @@ ConditionPathExistsGlob = /var/lib/mdcheck/MD_UUID_*
 [Service]
 Type=oneshot
 Environment="MDADM_CHECK_DURATION=6 hours"
-EnvironmentFile=-/run/sysconfig/mdadm
-ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=/usr/share/mdadm/mdcheck --continue --duration ${MDADM_CHECK_DURATION}
diff --git a/systemd/mdcheck_start.service b/systemd/mdcheck_start.service
index 3bb3d130801f..f98e5c6f52d7 100644
--- a/systemd/mdcheck_start.service
+++ b/systemd/mdcheck_start.service
@@ -12,6 +12,4 @@ Wants=mdcheck_continue.timer
 [Service]
 Type=oneshot
 Environment="MDADM_CHECK_DURATION=6 hours"
-EnvironmentFile=-/run/sysconfig/mdadm
-ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=/usr/share/mdadm/mdcheck --duration ${MDADM_CHECK_DURATION}
-- 
2.32.0 (Apple Git-132)

