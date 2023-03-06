Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8B2C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCFV3B (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCFV2y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BD3303FD
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUyEr4Wk8fQP9lDEcxTf4rTF2DEo2NnYLBchGAbrznk=;
        b=IUCUXunlEeSq5zNHvBvO0Nslcx8r7cpg6DNg+dckXKOPLq0fqyzB9J5f8Qkc7Sp77++D/H
        Bocl+/3/px3AnCW1C62rh3HJPP8pon0h8wwoPG8TGK/wJLDgG9k2Tlj78mRF+5MhL2/XSX
        2G3ZGLeB5PXkq9yG5IcJm+xa0ycE+VQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-kUtvbA4fOb-gk9MIPynO_A-1; Mon, 06 Mar 2023 16:28:07 -0500
X-MC-Unique: kUtvbA4fOb-gk9MIPynO_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7ABE183B3E2
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:06 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 106D6400DFA1;
        Mon,  6 Mar 2023 21:28:05 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 08/34] md: don't initilize statics/globals to 0/false [ERROR]
Date:   Mon,  6 Mar 2023 22:27:31 +0100
Message-Id: <0692170434769af589854c961ece89a44414c698.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md.c    | 2 +-
 drivers/md/raid0.c | 2 +-
 drivers/md/raid5.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e6ff0da6ebb6..9dc1df40c52d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5563,7 +5563,7 @@ static struct kobj_type md_ktype = {
 	.default_groups	= md_attr_groups,
 };
 
-int mdp_major = 0;
+int mdp_major;
 
 static void mddev_delayed_delete(struct work_struct *ws)
 {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 582457cea439..11b9815f153d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -19,7 +19,7 @@
 #include "raid0.h"
 #include "raid5.h"
 
-static int default_layout = 0;
+static int default_layout;
 module_param(default_layout, int, 0644);
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 00151c850a35..d0b6a97200fa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -64,7 +64,7 @@
 
 #define RAID5_MAX_REQ_STRIPES 256
 
-static bool devices_handle_discard_safely = false;
+static bool devices_handle_discard_safely;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
-- 
2.39.2

