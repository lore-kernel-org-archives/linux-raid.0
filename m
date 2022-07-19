Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2B6C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 13:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiGSNeB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiGSNdo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 09:33:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A758E1D7
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 05:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658234961; x=1689770961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wy/b29YPZC/ybk0t6gVs6FeIk2GScRrlPpWyzk1VbOI=;
  b=SrSZphOXuLXmAjt1Kb8dZxqkvcFNu9xJ392gqtbotP4T4Z8kgxl8M5RU
   XVwuGhg1iY4DqfAeMFsHxCIoaKZ0m7W2qqmgjxBfv3DGiBqdWTH2NnxXX
   uQPI5yOT0iNnABAu9L1sKsa5qWq1OfJaP5c05KXVrla10bFZhV8cI9/xv
   8KF6eoQGjNJ3SVqejyJY2DQtZb70S8ZSmDVudVUiw/OHSH0Bl2rHa0Gg3
   n9Al2vZA5g2+Y8HP3JID3N0g+mM9Oo/QAPePNg8u8YDwzq6TO8HJdnQek
   NlPLBp5bTsIpR097bbFtZamAWAO0oAe7KZ/DuBj8Izc/OMhaubkoMbhQT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287225195"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287225195"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687100951"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:45 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] mdadm: remove symlink option
Date:   Tue, 19 Jul 2022 14:48:22 +0200
Message-Id: <20220719124823.20302-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
References: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The option is not used. Remove it from code.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 ReadMe.c        |  1 -
 config.c        |  7 +------
 mdadm.8.in      |  9 ---------
 mdadm.c         | 20 --------------------
 mdadm.conf.5.in | 15 ---------------
 mdadm.h         |  2 --
 6 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index bec1be9..14a5214 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -146,7 +146,6 @@ struct option long_options[] = {
     {"nofailfast",0, 0,  NoFailFast},
     {"re-add",    0, 0,  ReAdd},
     {"homehost",  1, 0,  HomeHost},
-    {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
     {"nodes",1, 0, Nodes}, /* also for --assemble */
     {"home-cluster",1, 0, ClusterName},
diff --git a/config.c b/config.c
index 9c72545..dc1620c 100644
--- a/config.c
+++ b/config.c
@@ -194,7 +194,6 @@ struct mddev_dev *load_containers(void)
 
 struct createinfo createinfo = {
 	.autof = 2, /* by default, create devices with standard names */
-	.symlinks = 1,
 	.names = 0, /* By default, stick with numbered md devices. */
 	.bblist = 1, /* Use a bad block list by default */
 #ifdef DEBIAN
@@ -310,11 +309,7 @@ static void createline(char *line)
 			if (!createinfo.supertype)
 				pr_err("metadata format %s unknown, ignoring\n",
 					w+9);
-		} else if (strncasecmp(w, "symlinks=yes", 12) == 0)
-			createinfo.symlinks = 1;
-		else if  (strncasecmp(w, "symlinks=no", 11) == 0)
-			createinfo.symlinks = 0;
-		else if (strncasecmp(w, "names=yes", 12) == 0)
+		} else if (strncasecmp(w, "names=yes", 12) == 0)
 			createinfo.names = 1;
 		else if  (strncasecmp(w, "names=no", 11) == 0)
 			createinfo.names = 0;
diff --git a/mdadm.8.in b/mdadm.8.in
index 0be02e4..f273622 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1048,11 +1048,6 @@ simultaneously. If not specified, this defaults to 4.
 Specify journal device for the RAID-4/5/6 array. The journal device
 should be a SSD with reasonable lifetime.
 
-.TP
-.BR \-\-symlinks
-Auto creation of symlinks in /dev to /dev/md, option --symlinks must
-be 'no' or 'yes' and work with --create and --build.
-
 .TP
 .BR \-k ", " \-\-consistency\-policy=
 Specify how the array maintains consistency in case of unexpected shutdown.
@@ -1405,10 +1400,6 @@ Reshape can be continued later using the
 .B \-\-continue
 option for the grow command.
 
-.TP
-.BR \-\-symlinks
-See this option under Create and Build options.
-
 .SH For Manage mode:
 
 .TP
diff --git a/mdadm.c b/mdadm.c
index be40686..3e8bfef 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -59,7 +59,6 @@ int main(int argc, char *argv[])
 	struct mddev_dev *dv;
 	mdu_array_info_t array;
 	int devs_found = 0;
-	char *symlinks = NULL;
 	int grow_continue = 0;
 	/* autof indicates whether and how to create device node.
 	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
@@ -662,13 +661,6 @@ int main(int argc, char *argv[])
 		case O(ASSEMBLE,Auto): /* auto-creation of device node */
 			c.autof = parse_auto(optarg, "--auto flag", 0);
 			continue;
-
-		case O(CREATE,Symlinks):
-		case O(BUILD,Symlinks):
-		case O(ASSEMBLE,Symlinks): /* auto creation of symlinks in /dev to /dev/md */
-			symlinks = optarg;
-			continue;
-
 		case O(BUILD,'f'): /* force honouring '-n 1' */
 		case O(BUILD,Force): /* force honouring '-n 1' */
 		case O(GROW,'f'): /* ditto */
@@ -1323,18 +1315,6 @@ int main(int argc, char *argv[])
 		exit(2);
 	}
 
-	if (symlinks) {
-		struct createinfo *ci = conf_get_create_info();
-
-		if (strcasecmp(symlinks, "yes") == 0)
-			ci->symlinks = 1;
-		else if (strcasecmp(symlinks, "no") == 0)
-			ci->symlinks = 0;
-		else {
-			pr_err("option --symlinks must be 'no' or 'yes'\n");
-			exit(2);
-		}
-	}
 	/* Ok, got the option parsing out of the way
 	 * hopefully it's mostly right but there might be some stuff
 	 * missing
diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index cd4e6a9..bc2295c 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -338,21 +338,6 @@ missing device entries should be created.
 The name of the metadata format to use if none is explicitly given.
 This can be useful to impose a system-wide default of version-1 superblocks.
 
-.TP
-.B symlinks=no
-Normally when creating devices in
-.B /dev/md/
-.I mdadm
-will create a matching symlink from
-.B /dev/
-with a name starting
-.B md
-or
-.BR md_ .
-Give
-.B symlinks=no
-to suppress this symlink creation.
-
 .TP
 .B names=yes
 Since Linux 2.6.29 it has been possible to create
diff --git a/mdadm.h b/mdadm.h
index 974415b..8d1af86 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -394,7 +394,6 @@ struct createinfo {
 	int	gid;
 	int	autof;
 	int	mode;
-	int	symlinks;
 	int	names;
 	int	bblist;
 	struct supertype *supertype;
@@ -441,7 +440,6 @@ enum special_options {
 	BackupFile,
 	HomeHost,
 	AutoHomeHost,
-	Symlinks,
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
-- 
2.26.2

