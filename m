Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660C5C6FD19
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCMDqF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCMDp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08043366B6
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9C05722AB4;
        Mon, 13 Mar 2023 03:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0+QfO1SVN/4a+LTuEzrm7iWbAUTUxTTqlod2gorhaI=;
        b=bNmWYkxEt5j5q7iSy58ceYA0yGSSE+mddIE3TEPwO9dyocUhursyDAkoFsepNfuUP1UbjI
        tmw4QnzedbRud8zDwNzH8FGeTKdAFYJ3LkHVJ5IWSIYfdKd+Yfu7qU/HguLyPXTPLjIzgw
        oKhYxD7W+Wz7gXPNK8n/zB6bl/RcxJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679155;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0+QfO1SVN/4a+LTuEzrm7iWbAUTUxTTqlod2gorhaI=;
        b=ZU5gs/LpMGzXzHHeDPeJ5P5FfvrUMxgb8UTnErs3tAeJHjT1W/rP10uanaTT34HtvflkPp
        P9kAYqwGzyIF8nAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DBF9113463;
        Mon, 13 Mar 2023 03:45:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id S3i+JHGcDmSwCAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:53 +0000
Subject: [PATCH 6/6] mdmon: Improve switchroot interactions.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897870.11443.16634209918000405045.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
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
in time to avoid any risk of deadlock, which can happen when a write is
attempted with no mdmon running.

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

We don't need a similar mechanism at shutdown because dracut runs
"mdmon --takeover --all" when appropriate.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Grow.c                    |    4 ++--
 mdadm.h                   |    2 +-
 mdmon.c                   |    7 ++++++-
 systemd/mdmon@.service    |    2 +-
 udev-md-raid-arrays.rules |    3 ++-
 util.c                    |    7 ++++---
 6 files changed, 16 insertions(+), 9 deletions(-)

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
index 16acb2dd1ce4..1af86dc79d0f 100644
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
index 6d37b17c3f53..cef5bbc8b0dd 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -368,7 +368,12 @@ int main(int argc, char *argv[])
 	}
 
 	if (!all && argv[optind]) {
-		container_name = get_md_name(argv[optind]);
+		static const char prefix[] = "initrd/";
+		container_name = argv[optind];
+		if (strncmp(container_name, prefix,
+			    sizeof(prefix) - 1) == 0)
+			container_name += sizeof(prefix)-1;
+		container_name = get_md_name(container_name);
 		if (!container_name)
 			return 1;
 	}
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 79f80b5c372e..020cc7e15e1f 100644
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
index 509fb43ea906..d70ca43bc31d 100644
--- a/util.c
+++ b/util.c
@@ -1916,6 +1916,7 @@ int start_mdmon(char *devnm)
 	int len;
 	pid_t pid;
 	int status;
+	char *prefix = in_initrd() ? "initrd-" : "";
 	char pathbuf[1024];
 	char *paths[4] = {
 		pathbuf,
@@ -1926,7 +1927,7 @@ int start_mdmon(char *devnm)
 
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
-	if (continue_via_systemd(devnm, MDMON_SERVICE))
+	if (continue_via_systemd(devnm, MDMON_SERVICE, prefix))
 		return 0;
 
 	/* That failed, try running mdmon directly */
@@ -2197,7 +2198,7 @@ void manage_fork_fds(int close_all)
  *	1- if systemd service has been started
  *	0- otherwise
  */
-int continue_via_systemd(char *devnm, char *service_name)
+int continue_via_systemd(char *devnm, char *service_name, char *prefix)
 {
 	int pid, status;
 	char pathbuf[1024];
@@ -2209,7 +2210,7 @@ int continue_via_systemd(char *devnm, char *service_name)
 	case  0:
 		manage_fork_fds(1);
 		snprintf(pathbuf, sizeof(pathbuf),
-			 "%s@%s.service", service_name, devnm);
+			 "%s@%s%s.service", service_name, prefix ?: "", devnm);
 		status = execl("/usr/bin/systemctl", "systemctl", "restart",
 			       pathbuf, NULL);
 		status = execl("/bin/systemctl", "systemctl", "restart",


