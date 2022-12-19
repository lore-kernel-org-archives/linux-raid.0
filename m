Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDD8C4167B
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 10:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiLSKWN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 05:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiLSKWH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 05:22:07 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629172BFF
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 02:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671445327; x=1702981327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ENE+EyUOhHi5cbzLGa+Jl/AoGto3XvlaLLRyB3CP5ZQ=;
  b=nKtb7m0FipEvn/FsVEFgCMVPqY3htloPGZhNxPqqsVwz+eq2LMqVTnDk
   jVrH+ijaZrSskB8WsP7uWR1AkZRK/HxPcKEXPO1bzzo45ySvos/PoqkWZ
   DXHkDrkpA8anrAOgJHi4SL8qHR07GiUoHBNYphglxlxrGVjwt76E4Cljn
   ilwogZhfcQE5w8Cjbi1GO0eW8x8ctOuJNWjCeTeAJhER9zjykBRNFIGo3
   4o7zj+1KDJ4I/YPabEWU1YRItfntw0En7vl6ZUnkJdBFSkhshOikhlfQm
   4z9a4sAjFRsgIvWlyFdKYFt/m1nWzvPzKKOKmQKEsUGgwAVaRkw8BOJe5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="319364351"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="319364351"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:22:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="824805181"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="824805181"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2022 02:22:06 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH V2 2/2] Update mdadm Monitor manual.
Date:   Mon, 19 Dec 2022 11:21:58 +0100
Message-Id: <20221219102158.10180-3-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221219102158.10180-1-blazej.kucman@intel.com>
References: <20221219102158.10180-1-blazej.kucman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

- describe monitor work modes,
- clarify the turning off condition,
- describe the mdmonitor.service as a prefered management way.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
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

