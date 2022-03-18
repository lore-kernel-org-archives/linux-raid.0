Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9851AC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 08:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiCRI1q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiCRI1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 04:27:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7037D12F15E
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 01:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591985; x=1679127985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WHQP6Z0RyEzaFy9x+UtAIWAD8DrWOBBY8zxRaogh0lg=;
  b=jQVbKDIPXfZ8cayH1unMxCCwAbjuR/+MIlFPrRVw5J5Lzp/aC9lqxPAs
   2kKiOeRbhyU3iSJCsvUfwqscprrnFvxAu70L7tHfZphPMIHiCv+GRHdU/
   XJm/hqncaq49rY53bNgrgQwuExDozVELzieotB7dKN74j26J0jpiNhJsM
   pIYbjhjT3hTkMzLUFuNrnczwElxSuBZkD0xqvmm3vi9v1kHt/SLFY8jvo
   uPfELGbOF0iJLQzkniIyg2HxBm21qNhn4M23UJ/1DQ/K2Oz5GF7ENDPLB
   y4JvpMpSTgftQUa8GT89jZ2ikqJx279D/cQ1EQaCU+lTDmSsUlWwCa5CY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281900456"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="281900456"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="715379747"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2022 01:26:23 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH 1/4] mdadm: Respect config file location in man
Date:   Fri, 18 Mar 2022 09:26:04 +0100
Message-Id: <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Default config file location could differ depending on OS (e.g. Debian family).
This patch takes default config file into consideration when creating mdadm.man
file as well as mdadm.conf.man.

Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is generated automatically.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 .gitignore                      |  1 +
 Makefile                        |  7 ++++++-
 mdadm.8.in                      | 16 ++++++++--------
 mdadm.conf.5 => mdadm.conf.5.in |  2 +-
 4 files changed, 16 insertions(+), 10 deletions(-)
 rename mdadm.conf.5 => mdadm.conf.5.in (99%)

diff --git a/.gitignore b/.gitignore
index 217fe76d..8d791c6f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,6 +3,7 @@
 /*-stamp
 /mdadm
 /mdadm.8
+/mdadm.conf.5
 /mdadm.udeb
 /mdassemble
 /mdmon
diff --git a/Makefile b/Makefile
index 2a51d813..bf126033 100644
--- a/Makefile
+++ b/Makefile
@@ -227,7 +227,12 @@ raid6check : raid6check.o mdadm.h $(CHECK_OBJS)
 
 mdadm.8 : mdadm.8.in
 	sed -e 's/{DEFAULT_METADATA}/$(DEFAULT_METADATA)/g' \
-	-e 's,{MAP_PATH},$(MAP_PATH),g'  mdadm.8.in > mdadm.8
+	-e 's,{MAP_PATH},$(MAP_PATH),g' -e 's,{CONFFILE},$(CONFFILE),g' \
+	-e 's,{CONFFILE2},$(CONFFILE2),g'  mdadm.8.in > mdadm.8
+
+mdadm.conf.5 : mdadm.conf.5.in
+	sed -e 's,{CONFFILE},$(CONFFILE),g' \
+	-e 's,{CONFFILE2},$(CONFFILE2),g'  mdadm.conf.5.in > mdadm.conf.5
 
 mdadm.man : mdadm.8
 	man -l mdadm.8 > mdadm.man
diff --git a/mdadm.8.in b/mdadm.8.in
index be902dba..d41b3ca7 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -267,13 +267,13 @@ the exact meaning of this option in different contexts.
 .TP
 .BR \-c ", " \-\-config=
 Specify the config file or directory.  Default is to use
-.B /etc/mdadm.conf
+.B {CONFFILE}
 and
-.BR /etc/mdadm.conf.d ,
+.BR {CONFFILE}.d ,
 or if those are missing then
-.B /etc/mdadm/mdadm.conf
+.B {CONFFILE2}
 and
-.BR /etc/mdadm/mdadm.conf.d .
+.BR {CONFFILE2}.d .
 If the config file given is
 .B "partitions"
 then nothing will be read, but
@@ -2009,9 +2009,9 @@ The config file is only used if explicitly named with
 or requested with (a possibly implicit)
 .BR \-\-scan .
 In the later case,
-.B /etc/mdadm.conf
+.B {CONFFILE}
 or
-.B /etc/mdadm/mdadm.conf
+.B {CONFFILE2}
 is used.
 
 If
@@ -3339,7 +3339,7 @@ uses this to find arrays when
 is given in Misc mode, and to monitor array reconstruction
 on Monitor mode.
 
-.SS /etc/mdadm.conf
+.SS {CONFFILE} (or {CONFFILE2})
 
 The config file lists which devices may be scanned to see if
 they contain MD super block, and gives identifying information
@@ -3347,7 +3347,7 @@ they contain MD super block, and gives identifying information
 .BR mdadm.conf (5)
 for more details.
 
-.SS /etc/mdadm.conf.d
+.SS {CONFFILE}.d (or {CONFFILE2}.d)
 
 A directory containing configuration files which are read in lexical
 order.
diff --git a/mdadm.conf.5 b/mdadm.conf.5.in
similarity index 99%
rename from mdadm.conf.5
rename to mdadm.conf.5.in
index 74a21c5f..83edd008 100644
--- a/mdadm.conf.5
+++ b/mdadm.conf.5.in
@@ -8,7 +8,7 @@
 .SH NAME
 mdadm.conf \- configuration for management of Software RAID with mdadm
 .SH SYNOPSIS
-/etc/mdadm.conf
+{CONFFILE}
 .SH DESCRIPTION
 .PP
 .I mdadm
-- 
2.27.0

