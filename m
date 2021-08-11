Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FB7C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 13:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BB760FDA
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 13:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhHKNj4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:39:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhHKNjz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Aug 2021 09:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628689171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mBNQTG4kT8XD736g8tyFMXhl9tsW4f3Xh6ByTWmHGUU=;
        b=DszVoyCK954ea/Az9SnVYrrlDFMNZ/l9MkVRqfCsptfsZbT78WxnH9sS7F6xlddjVzo9DR
        Fg+QEQsOyNWkAM5xLfx0woIPTN99FHL8CfZviZ2+Rc87dabQ35GwrYKoiPsusWejaTIK3s
        Sp7JanS1ynZeVvOP88gZG+6Rz4C4zBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-6erko1QcPSGcFJwNo2RIOw-1; Wed, 11 Aug 2021 09:39:30 -0400
X-MC-Unique: 6erko1QcPSGcFJwNo2RIOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0C28801A92;
        Wed, 11 Aug 2021 13:39:29 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC820781E8;
        Wed, 11 Aug 2021 13:39:29 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org, xni@redhat.com
Subject: [PATCH] Fix 2 dc stream buffer
Date:   Wed, 11 Aug 2021 09:39:28 -0400
Message-Id: <20210811133928.1791065-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To meet requirements of Common Criteria certification vulnerablility
assessment. Static code analysis has been run and found the following
Error: DC.STREAM_BUFFER (CWE-120): [#def46]
mdadm-4.2: dont_call: "fscanf" assumes an arbitrarily
long string, so callers must use correct precision specifiers or
never use "fscanf".

The change is to define a value for string %s.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Monitor.c | 2 +-
 policy.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f5412299..8bd3b5a1 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -359,7 +359,7 @@ static int check_one_sharer(int scan)
 			 "/proc/%d/comm", pid);
 		comm_fp = fopen(comm_path, "r");
 		if (comm_fp) {
-			if (fscanf(comm_fp, "%s", comm) &&
+			if (fscanf(comm_fp, "%19s", comm) &&
 			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
 				if (scan) {
 					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
diff --git a/policy.c b/policy.c
index 3c53bd35..e9760a65 100644
--- a/policy.c
+++ b/policy.c
@@ -784,7 +784,7 @@ int policy_check_path(struct mdinfo *disk, struct map_ent *array)
 		if (!f)
 			continue;
 
-		rv = fscanf(f, " %s %x:%x:%x:%x\n",
+		rv = fscanf(f, " %255s %x:%x:%x:%x\n",
 			    array->metadata,
 			    array->uuid,
 			    array->uuid+1,
-- 
2.29.2

