Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE88C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 08:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiCRI1t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiCRI1s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 04:27:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C8F15B987
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 01:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591989; x=1679127989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rjK0aLxNtE7wpzWr1FuD+xVhC/LcFQtUsDkEqnqrvAo=;
  b=K8bR4h3cBSpX1n9EA+Rkr/kn4xnXaDujoxENpnXc2DXT4BsKzHFDCyE2
   b0nFS22MjojFstkCoJqtMXxDvky/m+GvLum/aSSpCorIZkWnzYF5VOOex
   oRS5k8/Cuz5wEhTsE1JXq0uBNmADwIh+LnVzLGYWJ+P5xfCvVzVIF3A9q
   kN0lIaxq4fFtUAr2nlHHFM9eeNZvegXWrosPGSLOGBH5hpJLmnuhBAWvk
   Fjiwjpwt/0yV4A64iKsv37I6d+UaMxVuAuD/hvpft/9X0BoAuHYz1VeO3
   U50RXe3a2nShiLXVTTa7PHv0jWtaSWyMrrWZe2Kd2rMzAwWqFFy0ikAjz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281900467"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="281900467"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:26:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="715379771"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2022 01:26:28 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH 3/4] mdadm: Update config man regarding default files and multi-keyword behavior
Date:   Fri, 18 Mar 2022 09:26:06 +0100
Message-Id: <20220318082607.675665-4-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Simplify default and alternative config file and directory location references
from mdadm(8) as references to mdadm.conf(5). Add FILE section in config man
and explain order and conditions in which default and alternative config files
and directories are used.

Update config man behavior regarding parsing order when multiple keywords/config
files are involved.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 mdadm.8.in      | 30 +++++++++--------------
 mdadm.conf.5.in | 65 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index d41b3ca7..d6af73b7 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -266,14 +266,11 @@ the exact meaning of this option in different contexts.
 
 .TP
 .BR \-c ", " \-\-config=
-Specify the config file or directory.  Default is to use
-.B {CONFFILE}
-and
-.BR {CONFFILE}.d ,
-or if those are missing then
-.B {CONFFILE2}
-and
-.BR {CONFFILE2}.d .
+Specify the config file or directory.  If not specified, default config file
+and default conf.d directory will be used.  See
+.BR mdadm.conf (5)
+for more details.
+
 If the config file given is
 .B "partitions"
 then nothing will be read, but
@@ -2008,11 +2005,9 @@ The config file is only used if explicitly named with
 .B \-\-config
 or requested with (a possibly implicit)
 .BR \-\-scan .
-In the later case,
-.B {CONFFILE}
-or
-.B {CONFFILE2}
-is used.
+In the later case, default config file is used.  See
+.BR mdadm.conf (5)
+for more details.
 
 If
 .B \-\-scan
@@ -3341,16 +3336,15 @@ on Monitor mode.
 
 .SS {CONFFILE} (or {CONFFILE2})
 
-The config file lists which devices may be scanned to see if
-they contain MD super block, and gives identifying information
-(e.g. UUID) about known MD arrays.  See
+Default config file.  See
 .BR mdadm.conf (5)
 for more details.
 
 .SS {CONFFILE}.d (or {CONFFILE2}.d)
 
-A directory containing configuration files which are read in lexical
-order.
+Default directory containing configuration files.  See
+.BR mdadm.conf (5)
+for more details.
 
 .SS {MAP_PATH}
 When
diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index 83edd008..dd331a6a 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -88,7 +88,8 @@ but only the major and minor device numbers.  It scans
 .I /dev
 to find the name that matches the numbers.
 
-If no DEVICE line is present, then "DEVICE partitions containers" is assumed.
+If no DEVICE line is present in any config file,
+then "DEVICE partitions containers" is assumed.
 
 For example:
 .IP
@@ -272,6 +273,10 @@ catenated with spaces to form the address.
 Note that this value cannot be set via the
 .I mdadm
 commandline.  It is only settable via the config file.
+There should only be one
+.B MAILADDR
+line and it should have only one address.  Any subsequent addresses
+are silently ignored.
 
 .TP
 .B PROGRAM
@@ -286,7 +291,8 @@ device.
 
 There should only be one
 .B program
-line and it should be give only one program.
+line and it should be given only one program.  Any subsequent programs
+are silently ignored.
 
 
 .TP
@@ -295,7 +301,14 @@ The
 .B create
 line gives default values to be used when creating arrays, new members
 of arrays, and device entries for arrays.
-These include:
+
+There should only be one
+.B create
+line.  Any subsequent lines will override the previous settings.
+
+Keywords used in the
+.I CREATE
+line and supported values are:
 
 .RS 4
 .TP
@@ -475,8 +488,8 @@ The known metadata types are
 
 .B AUTO
 should be given at most once.  Subsequent lines are silently ignored.
-Thus an earlier config file in a config directory will over-ride
-the setting in a later config file.
+Thus a later config file in a config directory will not overwrite
+the setting in an earlier config file.
 
 .TP
 .B POLICY
@@ -594,6 +607,7 @@ The
 line lists custom values of MD device's sysfs attributes which will be
 stored in sysfs after the array is assembled. Multiple lines are allowed and each
 line has to contain the uuid or the name of the device to which it relates.
+Lines are applied in reverse order.
 .RS 4
 .TP
 .B uuid=
@@ -621,7 +635,46 @@ is running in
 .B \-\-monitor
 mode.
 .B \-d/\-\-delay
-command line argument takes precedence over the config file
+command line argument takes precedence over the config file.
+
+If multiple
+.B MINITORDELAY
+lines are provided, only first non-zero value is considered.
+
+.SH FILES
+
+.SS {CONFFILE}
+
+The default config file location, used when
+.I mdadm
+is running without --config option.
+
+.SS {CONFFILE}.d
+
+The default directory with config files. Used when
+.I mdadm
+is running without --config option, after successful reading of the
+.B {CONFFILE}
+default config file. Files in that directory
+are read in lexical order.
+
+
+.SS {CONFFILE2}
+
+Alternative config file that is read, when
+.I mdadm
+is running without --config option and the
+.B {CONFFILE}
+default config file was not opened successfully.
+
+.SS {CONFFILE2}.d
+
+The alternative directory with config files. Used when
+.I mdadm
+is runninng without --config option, after reading the
+.B {CONFFILE2}
+alternative config file whether it was successful or not. Files in
+that directory are read in lexical order.
 
 .SH EXAMPLE
 DEVICE /dev/sd[bcdjkl]1
-- 
2.27.0

