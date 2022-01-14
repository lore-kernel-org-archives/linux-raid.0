Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1E1C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 14 Jan 2022 15:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbiANPom (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:44:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:59677 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbiANPom (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 14 Jan 2022 10:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642175082; x=1673711082;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2yTc04+qaine6sP/GJ22ig8N/YEj6FR5Vlms9EL0D/M=;
  b=JCu1vOQkN6KK8Ud5KDnFkLLx4jjmyREYMYx243s84GCs6yqkbWTc9De6
   pvhJ9/5kJ3G07AIglIEaFcqWnqhCL0EQj0EIuSvG6Fg/xWHhdibzC3WRF
   jp3IiGVA3wxBv5rP3G+VHeHd/KHvPmuVwEeevyVCbKzC4tafW2rS4Py2W
   O9wI3DUTVthpWfxJq/aO/As9Qr7Cs4inbUdNts3lliVIkdDLMDHZz33Z3
   eraw6kssLVd2M+kCApB9IuDURQ1lef/pYeBZLvOocwMjEUtKVLbqZaHLI
   U67Do8PX/sZc9ATBKoGZbIISHq64EBaKcYeIlR9MxA8HMaYGwr+ksce2z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268632354"
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="268632354"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 07:44:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="624385814"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 07:44:41 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] udev: adapt rules to systemd v247
Date:   Fri, 14 Jan 2022 16:44:33 +0100
Message-Id: <20220114154433.7386-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

New events have been added in kernel 4.14 ("bind" and "unbind").
Systemd maintainer suggests to modify "add|change" branches.
This patches implements their suggestions. There is no issue yet because
new event types are not used in md.

Please see systemd announcement for details[1].

[1] https://lists.freedesktop.org/archives/systemd-devel/2020-November/045646.html

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 udev-md-raid-arrays.rules        | 2 +-
 udev-md-raid-assembly.rules      | 5 +++--
 udev-md-raid-safe-timeouts.rules | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index 13c9076e..2967ace1 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -3,7 +3,7 @@
 SUBSYSTEM!="block", GOTO="md_end"
 
 # handle md arrays
-ACTION!="add|change", GOTO="md_end"
+ACTION=="remove", GOTO="md_end"
 KERNEL!="md*", GOTO="md_end"
 
 # partitions have no md/{array_state,metadata_version}, but should not
diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d668cddd..39b4344b 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -30,8 +30,9 @@ LABEL="md_inc"
 
 # remember you can limit what gets auto/incrementally assembled by
 # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
-ACTION=="add|change", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
-ACTION=="add|change", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
+ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
+ACTION!="remove", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
+
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $name --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $name"
 
diff --git a/udev-md-raid-safe-timeouts.rules b/udev-md-raid-safe-timeouts.rules
index 12bdcaa8..2e185cee 100644
--- a/udev-md-raid-safe-timeouts.rules
+++ b/udev-md-raid-safe-timeouts.rules
@@ -50,7 +50,7 @@ ENV{DEVTYPE}!="partition", GOTO="md_timeouts_end"
 
 IMPORT{program}="/sbin/mdadm --examine --export $devnode"
 
-ACTION=="add|change", \
+ACTION!="remove", \
   ENV{ID_FS_TYPE}=="linux_raid_member", \
   ENV{MD_LEVEL}=="raid[1-9]*", \
   TEST=="/sys/block/$parent/device/timeout", \
-- 
2.26.2

