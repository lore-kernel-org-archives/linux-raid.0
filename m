Return-Path: <SRS0=bg3X=DW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F935C433E7
	for <linux-raid@archiver.kernel.org>; Thu, 15 Oct 2020 08:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55ACA218AC
	for <linux-raid@archiver.kernel.org>; Thu, 15 Oct 2020 08:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgJOIpn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:45:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:47809 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388233AbgJOIpn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Oct 2020 04:45:43 -0400
IronPort-SDR: dnZx1NJ0gIBiZ0Dq8tLrtRHmht3GpzBgpXRGDK/mAkawL7gfyaOrlQUr12Ep4rCoGFD2eYbI8y
 y2QiONsCzQNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9774"; a="165516818"
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="165516818"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 01:45:42 -0700
IronPort-SDR: aXEhnAiB8M45EJsMTdsyKiZZ2AknOR1hfYEbqsmlOfEN7+wCjR0cKhen9nrlQW3FkcuQYZ1yeE
 TJ9lIKPBA0Sw==
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="531169499"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 01:45:41 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] udev: start grow service automatically
Date:   Thu, 15 Oct 2020 10:45:29 +0200
Message-Id: <20201015084529.5306-1-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>

Grow continue via service or fork is started during raid assembly.
If raid was assembled in initrd it will be newer restarted after
switch root.
Add udev support for starting mdadm-grow-continue service.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 udev-md-raid-arrays.rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index c8fa8e89..13c9076e 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -15,6 +15,7 @@ ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"
 ATTR{md/metadata_version}=="external:[A-Za-z]*", ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
 TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 ATTR{md/array_state}=="clear*|inactive", ENV{SYSTEMD_READY}="0", GOTO="md_end"
+ATTR{md/sync_action}=="reshape", ENV{RESHAPE_ACTIVE}="yes"
 LABEL="md_ignore_state"
 
 IMPORT{program}="BINDIR/mdadm --detail --no-devices --export $devnode"
@@ -38,5 +39,6 @@ ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"
 # Tell systemd to run mdmon for our container, if we need it.
 ENV{MD_LEVEL}=="raid[1-9]*", ENV{MD_CONTAINER}=="?*", PROGRAM="/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}="%c"
 ENV{MD_MON_THIS}=="?*", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdmon@%c.service"
+ENV{RESHAPE_ACTIVE}=="yes", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdadm-grow-continue@%c.service"
 
 LABEL="md_end"
-- 
2.25.0

