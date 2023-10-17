Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF67CDB482
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 05:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjJQFtu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 01:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQFtu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 01:49:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813B69E
        for <linux-raid@vger.kernel.org>; Mon, 16 Oct 2023 22:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697521740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PzIiXpik2hUl3xEFne3R99bNtpmaMgPMhtsrswhAafY=;
        b=MuXwtQP9b8g2nfALiwGQ25d5l/ZwkoDWy7GpyvwQiEi0DNl8QWAlp7zTe3TOnxB3ivZOjf
        1rZZ7ye0is86PuwSFvEO0bddYy8ShqSJi6tqFMS+3anunkMhfSWU60Qx/sul0EKHWjeEqb
        TNDz0ZoC4bij+Yhz7dYbnqtmRLHLJS4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-YpozECAuM4mVQSWe2LcknA-1; Tue, 17 Oct 2023 01:48:52 -0400
X-MC-Unique: YpozECAuM4mVQSWe2LcknA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC5401C06500;
        Tue, 17 Oct 2023 05:48:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E631BC15BB8;
        Tue, 17 Oct 2023 05:48:49 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, colyli@suse.de,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/udev: Don't add member disk if super is disabled in conf file
Date:   Tue, 17 Oct 2023 13:48:48 +0800
Message-Id: <20231017054848.42279-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Superblocks can be disabled behind AUTO in mdadm.conf. For this situation udev
rule still can handle the member disk. But it's not expected. Change the udev
rule to check the conf file before handling member disk.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 udev-md-raid-assembly.rules | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d4a7f0a5a049..a0f9494f4461 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -16,6 +16,10 @@ ENV{SYSTEMD_READY}=="0", GOTO="md_inc_end"
 # Then the change event happens.
 # When adding md/dm devices, ID_FS_TYPE can only be linux_raid_member
 # after change event happens.
+ENV{ID_FS_TYPE}=="linux_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*+1\.x.*-1\.x.*$ /etc/mdadm.conf", GOTO="md_inc"
+ENV{ID_FS_TYPE}=="linux_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*-1\.x.*$ /etc/mdadm.conf", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"
 
 # "noiswmd" on kernel command line stops mdadm from handling
@@ -26,9 +30,20 @@ IMPORT{cmdline}="noiswmd"
 IMPORT{cmdline}="nodmraid"
 
 ENV{nodmraid}=="?*", GOTO="md_inc_end"
+
+ENV{ID_FS_TYPE}=="ddf_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*+ddf.*-ddf.*$ /etc/mdadm.conf", GOTO="md_inc"
+ENV{ID_FS_TYPE}=="ddf_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*-ddf.*$ /etc/mdadm.conf", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
+
 ENV{noiswmd}=="?*", GOTO="md_inc_end"
+ENV{ID_FS_TYPE}=="isw_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*+imsm.*-imsm.*$ /etc/mdadm.conf", GOTO="md_inc"
+ENV{ID_FS_TYPE}=="isw_raid_member", \
+	PROGRAM="/usr/bin/egrep -c ^AUTO.*-imsm.*$ /etc/mdadm.conf", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change", GOTO="md_inc"
+
 GOTO="md_inc_end"
 
 LABEL="md_inc"
-- 
2.32.0 (Apple Git-132)

