Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9450C61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 07:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjBBH44 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 02:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjBBH44 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 02:56:56 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B5574C07
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 23:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675324615; x=1706860615;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e8a/QqFfgpcSwDmGOjqCUPY+s7AGPFd/LG2J8Wy3bYs=;
  b=GtXl02q7Sgl+FHqsXo+6bpl6xwKJlkkxcMTOApgePyy0oR7GYjTJtsQa
   im3ugVMGLlOwg0x6Y8t8BCEnm0EoHeThZs0SA4ZyGlnUfSx/TcZhr5FiT
   sAvSBuicCY9SP8grD81bYcTf6y4Vaz/dg4asmk1MGzmCtphgxpxOyLxMM
   9VxGXNLHrYS17vVe9RhpMzR9dDYp+D8whcmK7seaWoYuXh+maW2awAKxL
   rizXZfRifahI+cH/rrqdHgWEp9CcHFqeyHmeDKlBBS+dN3AMYw34K5xjj
   AFT4TSwus2wljwjknTqteNAGssqwKKrYYV8+Gb0pNVvdR66zof2k/ToPF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="329672815"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="329672815"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 23:56:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993988726"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="993988726"
Received: from mtkaczyk-devel.elements.local ([10.102.105.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 23:56:51 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH] Revert "mdadm/systemd: remove KillMode=none from service file"
Date:   Thu,  2 Feb 2023 08:56:31 +0100
Message-Id: <20230202075631.18092-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 52c67fcdd6dadc4138ecad73e65599551804d445.

The functionality is marked as deprecated but we don't have alternative
solution yet. Shutdown hangs if OS is installed on external array:

task:umount state:D stack: 0 pid: 6285 ppid: flags:0x00004084
Call Trace:
__schedule+0x2d1/0x830
? finish_wait+0x80/0x80
schedule+0x35/0xa0
md_write_start+0x14b/0x220
? finish_wait+0x80/0x80
raid1_make_request+0x3c/0x90 [raid1]
md_handle_request+0x128/0x1b0
md_make_request+0x5b/0xb0
generic_make_request_no_check+0x202/0x330
submit_bio+0x3c/0x160

Use it until new solution is implemented.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 systemd/mdadm-grow-continue@.service | 1 +
 systemd/mdmon@.service               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 64b8254..9ccadca 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -15,3 +15,4 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
 StandardInput=null
 StandardOutput=null
 StandardError=null
+KillMode=none
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 97a1acd..cb6482d 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -26,3 +26,4 @@ Type=forking
 # it out) and systemd will remove it when transitioning from
 # initramfs to rootfs.
 #PIDFile=/run/mdadm/%I.pid
+KillMode=none
-- 
2.26.2

