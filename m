Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E443EECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 13:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiIINvP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 09:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiIINvJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 09:51:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D781893536
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662731450; x=1694267450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z4HnTvcp+bQUkaK1kM/WECmyitz/HAL2Bxm4nMetUlc=;
  b=GMeXB5kjczSezwBAkQGiOSCLslGFg0WSR0HX5n7HaHNqDSS3MepMBijR
   aAvPHbYPVKOKHnS0+OnB20OnIn5W10YUqNsFvfPfJ9VA5ivlmtjglYtwR
   MEusFBEGXZueFBRKbPGqQ2rU0qf0/TSYSbx6nMwnbq+5Al9Sz/gZNRIE/
   g0GMdXTPCgojGeEWPdXy9EXwIBVkkHicMCu9EECabqEw21ck7YFfHSt0c
   4/mLwO3uSjipfu39hrgYjtyCpLYnnWKqt32cL09eWD+iB7Wg4QPWxzT0h
   C2pknW1839zOQpJpbpV5TyAK7MCHeOTQvf74s9BQawCEkO1e9m2bio7ER
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298815248"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="298815248"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="592612675"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 06:50:48 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     felix.lechner@lease-up.com, linux-raid@vger.kernel.org
Subject: [PATCH v2 1/2] mdadm: Add Documentation entries to systemd services
Date:   Fri,  9 Sep 2022 15:50:33 +0200
Message-Id: <20220909135034.14397-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
References: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add documentation section.
Copied from Debian.

Cc: Felix Lechner <felix.lechner@lease-up.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 systemd/mdadm-grow-continue@.service | 1 +
 systemd/mdadm-last-resort@.service   | 1 +
 systemd/mdcheck_continue.service     | 3 ++-
 systemd/mdcheck_start.service        | 1 +
 systemd/mdmon@.service               | 1 +
 systemd/mdmonitor-oneshot.service    | 1 +
 systemd/mdmonitor.service            | 1 +
 7 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 9fdc8ec..64b8254 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -8,6 +8,7 @@
 [Unit]
 Description=Manage MD Reshape on /dev/%I
 DefaultDependencies=no
+Documentation=man:mdadm(8)
 
 [Service]
 ExecStart=BINDIR/mdadm --grow --continue /dev/%I
diff --git a/systemd/mdadm-last-resort@.service b/systemd/mdadm-last-resort@.service
index efeb3f6..e938112 100644
--- a/systemd/mdadm-last-resort@.service
+++ b/systemd/mdadm-last-resort@.service
@@ -2,6 +2,7 @@
 Description=Activate md array %I even though degraded
 DefaultDependencies=no
 ConditionPathExists=!/sys/devices/virtual/block/%i/md/sync_action
+Documentation=man:mdadm(8)
 
 [Service]
 Type=oneshot
diff --git a/systemd/mdcheck_continue.service b/systemd/mdcheck_continue.service
index 854317f..f532490 100644
--- a/systemd/mdcheck_continue.service
+++ b/systemd/mdcheck_continue.service
@@ -7,7 +7,8 @@
 
 [Unit]
 Description=MD array scrubbing - continuation
-ConditionPathExistsGlob = /var/lib/mdcheck/MD_UUID_*
+ConditionPathExistsGlob=/var/lib/mdcheck/MD_UUID_*
+Documentation=man:mdadm(8)
 
 [Service]
 Type=oneshot
diff --git a/systemd/mdcheck_start.service b/systemd/mdcheck_start.service
index 3bb3d13..703a658 100644
--- a/systemd/mdcheck_start.service
+++ b/systemd/mdcheck_start.service
@@ -8,6 +8,7 @@
 [Unit]
 Description=MD array scrubbing
 Wants=mdcheck_continue.timer
+Documentation=man:mdadm(8)
 
 [Service]
 Type=oneshot
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 7753395..97a1acd 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -9,6 +9,7 @@
 Description=MD Metadata Monitor on /dev/%I
 DefaultDependencies=no
 Before=initrd-switch-root.target
+Documentation=man:mdmon(8)
 
 [Service]
 # mdmon should never complain due to lack of a platform,
diff --git a/systemd/mdmonitor-oneshot.service b/systemd/mdmonitor-oneshot.service
index 373955a..ba86b44 100644
--- a/systemd/mdmonitor-oneshot.service
+++ b/systemd/mdmonitor-oneshot.service
@@ -7,6 +7,7 @@
 
 [Unit]
 Description=Reminder for degraded MD arrays
+Documentation=man:mdadm(8)
 
 [Service]
 Environment=MDADM_MONITOR_ARGS=--scan
diff --git a/systemd/mdmonitor.service b/systemd/mdmonitor.service
index 46f7b88..9c36478 100644
--- a/systemd/mdmonitor.service
+++ b/systemd/mdmonitor.service
@@ -8,6 +8,7 @@
 [Unit]
 Description=MD array monitor
 DefaultDependencies=no
+Documentation=man:mdadm(8)
 
 [Service]
 Environment=  MDADM_MONITOR_ARGS=--scan
-- 
2.26.2

