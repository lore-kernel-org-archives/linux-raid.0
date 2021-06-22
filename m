Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2414C2B9F4
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 15:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9196128E
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 15:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFVPSS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Jun 2021 11:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231350AbhFVPSS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 22 Jun 2021 11:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624374961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/n/dlGsqSRC/mhD+z0vniMFq5LjTy2vLQFZqLM6aLr0=;
        b=QO/DFa+uG/uUUwh0cwIzWoL5pPpKLpWRI39e6PeeKhWwdqmNueMwb/8PX7KmKmOOgSk34j
        +P56vg0l6oNjnOijoM3uURkPmAFXDK/btbTTfZgGfwIiqWmiKMcJs9GiHiBlKhibnkTBa1
        uyTPBDXpvWrYWf9NWv3zSsZdEztWpeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-Z8NXL2dhOWKQdM41xeNTCw-1; Tue, 22 Jun 2021 11:16:00 -0400
X-MC-Unique: Z8NXL2dhOWKQdM41xeNTCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89D071084F57;
        Tue, 22 Jun 2021 15:15:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA27860854;
        Tue, 22 Jun 2021 15:15:57 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: [PATCH 1/1] mdadm: Fix building errors
Date:   Tue, 22 Jun 2021 23:15:55 +0800
Message-Id: <1624374955-13214-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In util.c, there is a building error:
'/md/metadata_version' directive writing 20 bytes into a
region of size between 0 and 255 [-Werror=format-overflow=]

In mapfile.c
It declares the fouth argument as 'int *' in map_update,
but in mdadm.h it's previously declared as an array 'int[4]'

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mapfile.c | 2 +-
 util.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mapfile.c b/mapfile.c
index 8d7acb3..6b2207d 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -215,7 +215,7 @@ void map_free(struct map_ent *map)
 }
 
 int map_update(struct map_ent **mpp, char *devnm, char *metadata,
-	       int *uuid, char *path)
+	       int uuid[4], char *path)
 {
 	struct map_ent *map, *mp;
 	int rv;
diff --git a/util.c b/util.c
index 5879694..cdf1da2 100644
--- a/util.c
+++ b/util.c
@@ -1543,7 +1543,7 @@ int open_container(int fd)
 	/* 'fd' is a block device.  Find out if it is in use
 	 * by a container, and return an open fd on that container.
 	 */
-	char path[256];
+	char path[288];
 	char *e;
 	DIR *dir;
 	struct dirent *de;
-- 
2.7.5

