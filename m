Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7561FC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 16:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507DE6044F
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 16:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhJNQEM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230359AbhJNQEL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 12:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634227325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=irvTc/JREtDceQeB1XRufJmXzr5LJgQwow7Id4+WySc=;
        b=FbDfyCnLdQztpp4ti0KGaCnzGkvb5Piq6ZNJ7u9RN145fiDu62vKMiv27pNKd9BBPHaux2
        tiv/fOR22TMB3UrE3lxLVw7NuBR3hllb7sFT+eJxh8IxcnDx9VZMYjepD2/W5+FITnhYW7
        I27EQuUBR2ithWEsstvRhFfiDqEVjy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-X9XDx94xMy6WYoQyOgAdbw-1; Thu, 14 Oct 2021 12:02:02 -0400
X-MC-Unique: X9XDx94xMy6WYoQyOgAdbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62B0E19057A0;
        Thu, 14 Oct 2021 16:02:01 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FA3B10016F7;
        Thu, 14 Oct 2021 16:02:01 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: [PATCH V2] Fix 2 dc stream buffer
Date:   Thu, 14 Oct 2021 12:02:00 -0400
Message-Id: <20211014160200.437040-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

V2: Tighten the value in policy.c to match the limit of the metadata.
Add a change to policy_save_path() to use correct precision on the
fscanf call.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Monitor.c | 2 +-
 policy.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f541229..8bd3b5a 100644
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
index 3c53bd3..eee9ef6 100644
--- a/policy.c
+++ b/policy.c
@@ -761,7 +761,7 @@ void policy_save_path(char *id_path, struct map_ent *array)
 		return;
 	}
 
-	if (fprintf(f, "%s %08x:%08x:%08x:%08x\n",
+	if (fprintf(f, "%20s %08x:%08x:%08x:%08x\n",
 		    array->metadata,
 		    array->uuid[0], array->uuid[1],
 		    array->uuid[2], array->uuid[3]) <= 0)
@@ -784,7 +784,7 @@ int policy_check_path(struct mdinfo *disk, struct map_ent *array)
 		if (!f)
 			continue;
 
-		rv = fscanf(f, " %s %x:%x:%x:%x\n",
+		rv = fscanf(f, " %20s %x:%x:%x:%x\n",
 			    array->metadata,
 			    array->uuid,
 			    array->uuid+1,
-- 
2.29.2

