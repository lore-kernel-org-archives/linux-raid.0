Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5E8C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCFVaE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjCFV3U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D0B39BAA
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvRWzge/GH9C2SWwVECbnVZ5E7NstB1bc8yQoVWBEtU=;
        b=I8Uf9rndWIiI8kYgAWizUSzVLJC+8dsMjez+IflDbRalsiXqkjbYBoyYnJ+86h9VrrmGWC
        jbJGC1MQEng1NFtwgbpT5rniuKD12B9PxZXYzQZmPX9tTUCL1oHyxMZ+mdPJ30GkReRLb6
        epcFLM0FWaNn/TCqM2yZE/x4hSP4wHI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-oAf-4WpHNWC8k5bFWRoBlg-1; Mon, 06 Mar 2023 16:28:19 -0500
X-MC-Unique: oAf-4WpHNWC8k5bFWRoBlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79FA71C06EC0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:19 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B64BE40C83B6;
        Mon,  6 Mar 2023 21:28:18 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 20/34] md: avoid pointless filenames in files [WARNING]
Date:   Mon,  6 Mar 2023 22:27:43 +0100
Message-Id: <5e82beab0a2b132f4af30187dbce80e565383bd6.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c     | 2 +-
 drivers/md/raid0.c  | 3 ++-
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 2 +-
 drivers/md/raid5.c  | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index dbdd0288ddd2..e19edfe62516 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * md.c : Multiple Devices driver for Linux
+ * Multiple Devices driver for Linux
  *   Copyright (C) 1998, 1999, 2000 Ingo Molnar
  *
  *   completely rewritten, based on the MD driver code from Marc Zyngier
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0089f0657651..b4c372c6861b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * raid0.c : Multiple Devices driver for Linux
+ * Multiple Devices driver for Linux
+ *
  *	     Copyright (C) 1994-96 Marc ZYNGIER
  *	     <zyngier@ufr-info-p7.ibp.fr> or
  *	     <maz@gloups.fdn.fr>
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5b7d1dea889d..bd245f41393a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * raid1.c : Multiple Devices driver for Linux
+ * Multiple Devices driver for Linux
  *
  * Copyright (C) 1999, 2000, 2001 Ingo Molnar, Red Hat
  *
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 60c9fba59d9f..dbad26fcca12 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * raid10.c : Multiple Devices driver for Linux
+ * Multiple Devices driver for Linux
  *
  * Copyright (C) 2000-2004 Neil Brown
  *
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f834c497b8fe..a7b37a4e3f66 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * raid5.c : Multiple Devices driver for Linux
+ * Multiple Devices driver for Linux
  *	   Copyright (C) 1996, 1997 Ingo Molnar, Miguel de Icaza, Gadi Oxman
  *	   Copyright (C) 1999, 2000 Ingo Molnar
  *	   Copyright (C) 2002, 2003 H. Peter Anvin
-- 
2.39.2

