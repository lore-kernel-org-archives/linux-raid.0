Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74291C4167B
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 09:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiLSJ7U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 04:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiLSJ7R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 04:59:17 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9A93889
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 01:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671443956; x=1702979956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxTghS+Tl+P0mcZdAeiCnLuAyVkFkHDsVpPseLU7eeQ=;
  b=Wf4uHm0QapfKk/UME3LbY4RMjZ2oEWBLL7pXwVaMCGFwOoGRMtpmylQX
   oAMwapSUBbhiDv5IlP/FU1UxGkiogHm8S5RvMxxaGvst1ZkRHMPwjkruX
   zkuVOIQP5pyJ9ZMUCGSwQ8lbsJaX/B/SytUdShzo1hn5KN1zYyWDWog4h
   uOHsSTE/F2E4q8G3DpFZWnjFpRe7HEEHa1WGtIP2CaLkuLfKjLkHBz471
   S7XxfYUsHbm4WShCwmIAIjYHVPAM+NwpdjRb9GKGl2Ml3JSrZb5u4lv+h
   knIAOhjjfwwAn13TyuWT3YN6cph+z/7VsRokv2BneUMBB9bUJ5NjIWBNE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="306990601"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="306990601"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 01:59:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="774860959"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="774860959"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga004.jf.intel.com with ESMTP; 19 Dec 2022 01:59:15 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 2/2] Update mdadm Monitor manual.
Date:   Mon, 19 Dec 2022 10:58:35 +0100
Message-Id: <20221219095835.686-3-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221219095835.686-1-blazej.kucman@intel.com>
References: <20221219095835.686-1-blazej.kucman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

- describe monitor work modes,
- clarify the turning off condition,
- describe the mdmonitor.service as a prefered management way.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
Change-Id: Id5a1d5e60b958954f48d3e0285dfeb0c6f54a9d4
---
 mdadm.8.in | 71 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 70c79d1e..64f71ed1 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2548,13 +2548,33 @@ Usage:
 .I options... devices...
 
 .PP
-This usage causes
+Monitor option can work in two modes:
+.IP \(bu 4
+system wide mode, follow all md devices based on
+.B /proc/mdstat,
+.IP \(bu 4
+follow only specified MD devices in command line.
+.PP
+
+.B \-\-scan -
+indicates system wide mode. Option causes the
+.I monitor
+to track all md devices that appear in
+.B /proc/mdstat.
+If it is not set, then at least one
+.B device
+must be specified.
+
+Monitor usage causes
 .I mdadm
 to periodically poll a number of md arrays and to report on any events
 noticed.
-.I mdadm
-will never exit once it decides that there are arrays to be checked,
-so it should normally be run in the background.
+
+In both modes,
+.I monitor
+will work as long as there is an active array with redundancy and it is defined to follow (for
+.B \-\-scan
+every array is followed).
 
 As well as reporting events,
 .I mdadm
@@ -2565,15 +2585,6 @@ or
 .B domain
 and if the destination array has a failed drive but no spares.
 
-If any devices are listed on the command line,
-.I mdadm
-will only monitor those devices, otherwise, all arrays listed in the
-configuration file will be monitored.  Further, if
-.B \-\-scan
-is given, then any other md devices that appear in
-.B /proc/mdstat
-will also be monitored.
-
 The result of monitoring the arrays is the generation of events.
 These events are passed to a separate program (if specified) and may
 be mailed to a given E-mail address.
@@ -2586,16 +2597,34 @@ device if relevant (such as a component device that has failed).
 
 If
 .B \-\-scan
-is given, then a program or an E-mail address must be specified on the
-command line or in the config file.  If neither are available, then
+is given, then a
+.B program
+or an
+.B e-mail
+address must be specified on the
+command line or in the config file. If neither are available, then
 .I mdadm
 will not monitor anything.
-Without
-.B \-\-scan,
-.I mdadm
-will continue monitoring as long as something was found to monitor.  If
-no program or email is given, then each event is reported to
-.BR stdout .
+For devices given directly in command line, without
+.B program
+or
+.B email
+specified, each event is reported to
+.BR stdout.
+
+Note: For systems where
+.If mdadm monitor
+is configured via systemd,
+.B mdmonitor(mdmonitor.service)
+should be configured. The service is designed to be primary solution for array monitoring,
+it is configured to work in system wide mode.
+It is automatically started and stopped according to current state and types of MD arrays in system.
+The service may require additional configuration, like
+.B e-mail
+or
+.B delay.
+That should be done in
+.B mdadm.conf.
 
 The different events are:
 
-- 
2.35.3

