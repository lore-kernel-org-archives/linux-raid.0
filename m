Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4F3ECAAD5
	for <linux-raid@archiver.kernel.org>; Tue,  6 Sep 2022 12:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiIFM7r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Sep 2022 08:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiIFM7r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Sep 2022 08:59:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB248CE2A
        for <linux-raid@vger.kernel.org>; Tue,  6 Sep 2022 05:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662469184; x=1694005184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xe6grRBAxhHenNENXc++1C3ijYkTynIXWb7RHOzg/mI=;
  b=EHJBY1hAQJO8tSSkp1mfuSny/Lna2U3Kl55JmleWks39hBgkt3X9usyQ
   Wuf5NzzOiZcRK5A8LETYcBtLG7IUZfyEMtMAdqIGiXPATftPseqIiyGUk
   W+PNTFt1oUUgryK/SfHEFdE3xt8xFXYEZNBKmr13Kytd9FKdeKWigKd/h
   WL8cI1BasABW4t0SNYEIQSjXzo+InI+gQ7bRcI5b1XG70QspvdBztuevs
   vIfMDMiGW4XERVPU2vo7DzMsF9+GB3QN7mvzGyRirOZuhy5P7r++jBbdG
   V4wOOjUGEcEskW6Vju+CNC4stWXmRREjngGVx6yxOnx/pUKmjoGIMEUjh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296585136"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="296585136"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 05:59:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="675679192"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 05:59:43 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org, felix.lechner@lease-up.com
Subject: [PATCH 1/2] mdadm: systemd services adjustments
Date:   Tue,  6 Sep 2022 14:59:31 +0200
Message-Id: <20220906125932.15214-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220906125932.15214-1-mariusz.tkaczyk@linux.intel.com>
References: <20220906125932.15214-1-mariusz.tkaczyk@linux.intel.com>
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
index 9fdc8ec7..64b8254a 100644
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
index efeb3f63..e9381125 100644
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
index 854317f1..f5324905 100644
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
index 3bb3d130..703a6583 100644
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
index 77533958..97a1acd9 100644
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
index 373955a2..ba86b44e 100644
--- a/systemd/mdmonitor-oneshot.service
+++ b/systemd/mdmonitor-oneshot.service
@@ -7,6 +7,7 @@
 
 [Unit]
 Description=Reminder for degraded MD arrays
+Documentation=man:mdadm(8)
 
 [Service]
 Environment=MDADM_MONITOR_ARGS=--scan
diff --git a/systemd/mdmonitor.service b/systemd/mdmonitor.service
index 46f7b880..9c364785 100644
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

