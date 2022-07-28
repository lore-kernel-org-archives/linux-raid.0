Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725A3C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiG1MWs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbiG1MWa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A486BD64
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E1A09373CD;
        Thu, 28 Jul 2022 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gi+tcIFVVTqTamklve+K4sXeOM5+84GSAQTaJLT9M1Y=;
        b=J7D/7t7sVJofse5ZwNu/acwFHiSNqNqkM9KttGHDJ3yPXq7jPdO0Ii5pKeEXM+Jha8H9AX
        xupqE1si/BvjvsgSyPu+EbBmZsNRNAXu7Y7iWwYsyZi2FvJHgYY4c6fi1XY4uzBz+bVpRE
        7DwEVNyJ9D5IvPVw2EdmkWE/ke69cbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010947;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gi+tcIFVVTqTamklve+K4sXeOM5+84GSAQTaJLT9M1Y=;
        b=ZhHEMFruVbcuqIDwqdj5ZPxxN7k6RyucF7fjyOngcfPhGPJ5UvNx0lwhIVuG6hpetPuJHX
        Q+o3iFZ84YtyzABA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8469C2C141;
        Thu, 28 Jul 2022 12:22:25 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 21/23] mdadm: remove symlink option
Date:   Thu, 28 Jul 2022 20:20:59 +0800
Message-Id: <20220728122101.28744-22-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

The option is not used. Remove it from code.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 ReadMe.c        |  1 -
 config.c        |  7 +------
 mdadm.8.in      |  9 ---------
 mdadm.c         | 20 --------------------
 mdadm.conf.5.in | 15 ---------------
 mdadm.h         |  2 --
 6 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 7518a32a..7f94847e 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -147,7 +147,6 @@ struct option long_options[] = {
     {"nofailfast",0, 0,  NoFailFast},
     {"re-add",    0, 0,  ReAdd},
     {"homehost",  1, 0,  HomeHost},
-    {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
     {"nodes",1, 0, Nodes}, /* also for --assemble */
     {"home-cluster",1, 0, ClusterName},
diff --git a/config.c b/config.c
index 9c725457..dc1620c1 100644
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
index 0be02e4a..f2736226 100644
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
index 56722ed9..180f7a9c 100644
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
@@ -663,13 +662,6 @@ int main(int argc, char *argv[])
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
@@ -1325,18 +1317,6 @@ int main(int argc, char *argv[])
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
index cd4e6a9d..bc2295c2 100644
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
index c838a233..55791b09 100644
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
@@ -442,7 +441,6 @@ enum special_options {
 	BackupFile,
 	HomeHost,
 	AutoHomeHost,
-	Symlinks,
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
-- 
2.35.3

