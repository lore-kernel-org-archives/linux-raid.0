Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8326C64ED6
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjB0AQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjB0AQh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440911165E
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:16:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 034C821A05;
        Mon, 27 Feb 2023 00:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnuuiDXyXQA7WhhmDH1jD1SiUQHW0N971Em3IYMJMRs=;
        b=pXfSa7mX0ZVHC2YNQhpwiOhVb+q5imraHSud+ibPIwrcnu2TZd0eAEMrmsGBAsuxfRRqyy
        EhWbB1jWw7cTvhD8M2maL78xGO0oJ/FTMnbJaLi700aC1pRwXYwU7MQS3SUEsIP6illigX
        wC/VBFbEBxYpGT4QxwhV1lb8KA+pJIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456993;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnuuiDXyXQA7WhhmDH1jD1SiUQHW0N971Em3IYMJMRs=;
        b=mgMUGlowi/YM4qJfU64ChyKmoKiIElR/MF/5MTZtFkJjj9/FaDSE9JkVUkkR9IKjRPw9N4
        bhKtwOvmGywGiZDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66C4613912;
        Mon, 27 Feb 2023 00:16:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QwaUBl/2+2P6dQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:16:31 +0000
Subject: [PATCH 6/6] mdmon improvements for switchroot
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745678753.16565.5052083348539533042.stgit@noble.brown>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We need a new mdmon@mdfoo instance to run in the root filesystem after
switch root, as /sys and /dev are removed from the initrd.

systemd will not start a new unit with the same name running while the
old unit is still active, and we want the two mdmon processes to overlap
in time to avoid any risk of deadlock which a write is attempted with no
mdmon running.

So we need a different unit name in the initrd than in the root.  Apart
from the name, everything else should be the same.

This is easily achieved using a different instance name as the
mdmon@.service unit file already supports multiple instances (for
different arrays).

So start "mdmon@mdfoo.service" from root, but
"mdmon@initrd-mdfoo.service" from the initrd.  udev can tell which
circumstance is the case by looking for /etc/initrd-release.
continue_from_systemd() is enhanced so that the "initrd-" prefix can be
requested.

Teach mdmon that a container name like "initrd/foo" should be treated
just like "foo".  Note that systemd passes the instance name
"initrd-foo" as "initrd/foo".

We don't need a similar machanism at shutdown because dracut runs
"mdmon --takeover --all" when appropriate.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Grow.c                    |    4 ++--
 mdadm.h                   |    2 +-
 mdmon.c                   |    6 +++++-
 systemd/mdmon@.service    |    2 +-
 udev-md-raid-arrays.rules |    3 ++-
 util.c                    |    7 ++++---
 6 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index bb5fe45c851c..06001f2d334a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3516,7 +3516,7 @@ started:
 
 	if (!forked)
 		if (continue_via_systemd(container ?: sra->sys_name,
-					 GROW_SERVICE)) {
+					 GROW_SERVICE, NULL)) {
 			free(fdlist);
 			free(offsets);
 			sysfs_free(sra);
@@ -3714,7 +3714,7 @@ int reshape_container(char *container, char *devname,
 	ping_monitor(container);
 
 	if (!forked && !freeze_reshape)
-		if (continue_via_systemd(container, GROW_SERVICE))
+		if (continue_via_systemd(container, GROW_SERVICE, NULL))
 			return 0;
 
 	switch (forked ? 0 : fork()) {
diff --git a/mdadm.h b/mdadm.h
index 0939fd3cb1ee..f208ed5ec22f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1605,7 +1605,7 @@ extern int same_dev(char *one, char *two);
 extern int compare_paths (char* path1,char* path2);
 extern void enable_fds(int devices);
 extern void manage_fork_fds(int close_all);
-extern int continue_via_systemd(char *devnm, char *service_name);
+extern int continue_via_systemd(char *devnm, char *service_name, char *prefix);
 
 extern void ident_init(struct mddev_ident *ident);
 
diff --git a/mdmon.c b/mdmon.c
index 6d37b17c3f53..25abdd71fb1e 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -368,7 +368,11 @@ int main(int argc, char *argv[])
 	}
 
 	if (!all && argv[optind]) {
-		container_name = get_md_name(argv[optind]);
+		static const char prefix[] = "initrd/";
+		container_name = argv[optind];
+		if (strncmp(container_name, prefix, sizeof(prefix)-1) == 0)
+			container_name += sizeof(prefix)-1;
+		container_name = get_md_name(container_name);
 		if (!container_name)
 			return 1;
 	}
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 3ab908c45a3b..8d55fa63ce28 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -6,7 +6,7 @@
 #  (at your option) any later version.
 
 [Unit]
-Description=MD Metadata Monitor on /dev/%I
+Description=MD Metadata Monitor on %I
 DefaultDependencies=no
 Before=initrd-switch-root.target
 Documentation=man:mdmon(8)
diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index 2967ace1f040..4e64b249b2db 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -38,7 +38,8 @@ ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"
 
 # Tell systemd to run mdmon for our container, if we need it.
 ENV{MD_LEVEL}=="raid[1-9]*", ENV{MD_CONTAINER}=="?*", PROGRAM="/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}="%c"
-ENV{MD_MON_THIS}=="?*", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdmon@%c.service"
+ENV{MD_MON_THIS}=="?*", TEST=="/etc/initrd-release", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdmon@initrd-%c.service"
+ENV{MD_MON_THIS}=="?*", TEST!="/etc/initrd-release", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdmon@%c.service"
 ENV{RESHAPE_ACTIVE}=="yes", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdadm-grow-continue@%c.service"
 
 LABEL="md_end"
diff --git a/util.c b/util.c
index 6b44662db7cd..1d433d1826b5 100644
--- a/util.c
+++ b/util.c
@@ -1906,6 +1906,7 @@ int start_mdmon(char *devnm)
 	int len;
 	pid_t pid;
 	int status;
+	char *prefix = in_initrd() ? "initrd-", "";
 	char pathbuf[1024];
 	char *paths[4] = {
 		pathbuf,
@@ -1916,7 +1917,7 @@ int start_mdmon(char *devnm)
 
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
-	if (continue_via_systemd(devnm, MDMON_SERVICE))
+	if (continue_via_systemd(devnm, MDMON_SERVICE, prefix))
 		return 0;
 
 	/* That failed, try running mdmon directly */
@@ -2187,7 +2188,7 @@ void manage_fork_fds(int close_all)
  *	1- if systemd service has been started
  *	0- otherwise
  */
-int continue_via_systemd(char *devnm, char *service_name)
+int continue_via_systemd(char *devnm, char *service_name, char *prefix)
 {
 	int pid, status;
 	char pathbuf[1024];
@@ -2199,7 +2200,7 @@ int continue_via_systemd(char *devnm, char *service_name)
 	case  0:
 		manage_fork_fds(1);
 		snprintf(pathbuf, sizeof(pathbuf),
-			 "%s@%s.service", service_name, devnm);
+			 "%s@%s%s.service", service_name, prefix ?: "", devnm);
 		status = execl("/usr/bin/systemctl", "systemctl", "restart",
 			       pathbuf, NULL);
 		status = execl("/bin/systemctl", "systemctl", "restart",


