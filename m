Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC93BC6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCTDq5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 23:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCTDq2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 23:46:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114111C7E9
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 20:44:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E552321B09;
        Mon, 20 Mar 2023 03:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679283838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WAmCLSLW50UboItj34RBpofNWOfWFMVMSVjHqiFIc/Q=;
        b=nCGc9XL6Fod/WlfGiHFkc5qk99dACg/rpI7l/w/tlZN1KYXHw+Tv7RkU1ZxjS42X8afP9I
        Wa5lHJQoylARpJQmAe8XKTEF+YrPc43C+IowQSFmwtRUn03+lYaDUbt1zbbZwJb3Nke584
        bs4wnraHO5G7qtwZAAHxEKCW534Yt/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679283838;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WAmCLSLW50UboItj34RBpofNWOfWFMVMSVjHqiFIc/Q=;
        b=GlxZogc4ZcnNhGylAMZig1Ze2MJ6RpJWJ8IP5tcLgJ8JYypz1HGqDHxoHOtAVUH6q30Tz3
        /QBAgjai8FArtpCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F178713912;
        Mon, 20 Mar 2023 03:43:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AR7KKX3WF2QVXQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 20 Mar 2023 03:43:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: [PATCH v2] Improvements for IMSM_NO_PLATFORM testing.
Date:   Mon, 20 Mar 2023 14:43:54 +1100
Message-id: <167928383495.8008.10987312807759367944@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Factor out IMSM_NO_PLATFORM testing into a single function that caches
the result.

Allow mdmon to explicitly set the result to "1" so that we don't need
the ENV var in the unit file

Check if the kernel command line contains "mdadm.imsm.test=3D1" and in
that case assert NO_PLATFORM.  This simplifies testing in a virtual
machine.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 mdadm.8.in             |  5 +++++
 mdadm.h                |  2 ++
 mdmon.c                |  6 ++++++
 super-intel.c          | 45 +++++++++++++++++++++++++++++++++++++++---
 systemd/mdmon@.service |  3 ---
 5 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 6f0f6c13baf1..b7159509f74d 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -3197,6 +3197,11 @@ environment.  This can be useful for testing or for di=
saster
 recovery.  You should be aware that interoperability may be
 compromised by setting this value.
=20
+These change can also be suppressed by adding=20
+.B mdadm.imsm.test=3D1
+to the kernel command line. This makes it easy to test IMSM
+code in a virtual machine that doesn't have IMSM virtual hardware.
+
 .TP
 .B MDADM_GROW_ALLOW_OLD
 If an array is stopped while it is performing a reshape and that
diff --git a/mdadm.h b/mdadm.h
index 1e518276116b..0d99544526fc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1263,6 +1263,8 @@ extern struct superswitch super0, super1;
 extern struct superswitch super_imsm, super_ddf;
 extern struct superswitch mbr, gpt;
=20
+void imsm_set_no_platform(int v);
+
 struct metadata_update {
 	int	len;
 	char	*buf;
diff --git a/mdmon.c b/mdmon.c
index 096b4d7650cf..cef5bbc8b0dd 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -318,6 +318,12 @@ int main(int argc, char *argv[])
 		{NULL, 0, NULL, 0}
 	};
=20
+	/*
+	 * mdmon should never complain due to lack of a platform,
+	 * that is mdadm's job if at all.
+	 */
+	imsm_set_no_platform(1);
+
 	while ((opt =3D getopt_long(argc, argv, "thaF", options, NULL)) !=3D -1) {
 		switch (opt) {
 		case 'a':
diff --git a/super-intel.c b/super-intel.c
index e155a8ae99cb..a5c86cb2a390 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -20,6 +20,7 @@
 #define HAVE_STDINT_H 1
 #include "mdadm.h"
 #include "mdmon.h"
+#include "dlink.h"
 #include "sha1.h"
 #include "platform-intel.h"
 #include <values.h>
@@ -629,6 +630,44 @@ static const char *_sys_dev_type[] =3D {
 	[SYS_DEV_VMD] =3D "VMD"
 };
=20
+static int no_platform =3D -1;
+
+static int check_no_platform(void)
+{
+	static const char search[] =3D "mdadm.imsm.test=3D1";
+	FILE *fp;
+
+	if (no_platform >=3D 0)
+		return no_platform;
+
+	if (check_env("IMSM_NO_PLATFORM")) {
+		no_platform =3D 1;
+		return 1;
+	}
+	fp =3D fopen("/proc/cmdline", "r");
+	if (fp) {
+		char *l =3D conf_line(fp);
+		char *w =3D l;
+
+		do {
+			if (strcmp(w, search) =3D=3D 0)
+				no_platform =3D 1;
+			w =3D dl_next(w);
+		} while (w !=3D l);
+		free_line(l);
+		fclose(fp);
+		if (no_platform >=3D 0)
+			return no_platform;
+	}
+	no_platform =3D 0;
+	return 0;
+}
+
+void imsm_set_no_platform(int v)
+{
+	no_platform =3D v;
+}
+
 const char *get_sys_dev_type(enum sys_dev_type type)
 {
 	if (type >=3D SYS_DEV_MAX)
@@ -2699,7 +2738,7 @@ static int detail_platform_imsm(int verbose, int enumer=
ate_only, char *controlle
 	int result=3D1;
=20
 	if (enumerate_only) {
-		if (check_env("IMSM_NO_PLATFORM"))
+		if (check_no_platform())
 			return 0;
 		list =3D find_intel_devices();
 		if (!list)
@@ -4722,7 +4761,7 @@ static int find_intel_hba_capability(int fd, struct int=
el_super *super, char *de
 		       devname);
 		return 1;
 	}
-	if (!is_fd_valid(fd) || check_env("IMSM_NO_PLATFORM")) {
+	if (!is_fd_valid(fd) || check_no_platform()) {
 		super->orom =3D NULL;
 		super->hba =3D NULL;
 		return 0;
@@ -10697,7 +10736,7 @@ static int imsm_get_allowed_degradation(int level, in=
t raid_disks,
  ***************************************************************************=
***/
 int validate_container_imsm(struct mdinfo *info)
 {
-	if (check_env("IMSM_NO_PLATFORM"))
+	if (check_no_platform())
 		return 0;
=20
 	struct sys_dev *idev;
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 23a375f6ba48..020cc7e15e1f 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -15,9 +15,6 @@ Documentation=3Dman:mdmon(8)
 IgnoreOnIsolate=3Dtrue
=20
 [Service]
-# mdmon should never complain due to lack of a platform,
-# that is mdadm's job if at all.
-Environment=3DIMSM_NO_PLATFORM=3D1
 # The mdmon starting in the initramfs (with dracut at least)
 # cannot see sysfs after root is mounted, so we will have to
 # 'takeover'.  As the '--offroot --takeover' don't hurt when
--=20
2.40.0

