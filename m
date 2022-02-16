Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C921EC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 16 Feb 2022 20:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiBPU7z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:59:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiBPU7t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Feb 2022 15:59:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4DA2AFEA3
        for <linux-raid@vger.kernel.org>; Wed, 16 Feb 2022 12:59:37 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AC63721135;
        Wed, 16 Feb 2022 20:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645045175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cIrSbaEy04tXygBBnnIdoClq1TYmR5Zc9izAZs0Z+B0=;
        b=p2LfNn2f3iOCO7a3tGs62bqfWB8hvrQCxxf+IxY90XaO8Db2c7NB1A3DsRDWNGLXK32Yrg
        5749JQBpAoRxX16AHm7+btX/rPRUj7uMk6Z6npvmpVYVyHTX51C16hhuBS6wxkUgIoBxG9
        g+cAepuG+bHRes2WS0+dLjA6slG6cTM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 463E613B31;
        Wed, 16 Feb 2022 20:59:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nR5vDrdlDWIWOwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 16 Feb 2022 20:59:35 +0000
From:   mwilck@suse.com
To:     Jes Sorensen <jsorensen@fb.com>, linux-raid@vger.kernel.org
Cc:     lvm-devel@redhat.com, Peter Rajnoha <prajnoha@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Heming Zhao <heming.zhao@suse.com>, Coly Li <colyli@suse.com>,
        dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH] udev-md-raid-assembly.rules: skip if DM_UDEV_DISABLE_OTHER_RULES_FLAG
Date:   Wed, 16 Feb 2022 21:59:14 +0100
Message-Id: <20220216205914.7575-1-mwilck@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1 for
devices which are unusable. They may be no set up yet, suspended, or
otherwise unusable (e.g. multipath maps without usable path). This
flag does not necessarily imply SYSTEMD_READY=0 and must therefore
be tested separately.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev-md-raid-assembly.rules | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d668cdd..4568b01 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -21,6 +21,11 @@ IMPORT{cmdline}="noiswmd"
 IMPORT{cmdline}="nodmraid"
 
 ENV{nodmraid}=="?*", GOTO="md_inc_end"
+
+# device mapper sets DM_UDEV_DISABLE_OTHER_RULES_FLAG for devices which
+# aren't ready to use
+KERNEL=="dm-*", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="md_inc_end"
+
 ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
 ENV{noiswmd}=="?*", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change", GOTO="md_inc"
-- 
2.35.1

