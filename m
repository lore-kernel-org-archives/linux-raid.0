Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E690C7EE23
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjB0AQM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0AQL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:11 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5F8166C2
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:16:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E193421A0B;
        Mon, 27 Feb 2023 00:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=biyQfW85R26FBpzSflFh1HGgDmjBo6SyzVlhE+RclBU=;
        b=iD57FJXaO2WARkeNcMFZvmCSkONr+AJjbR9AJkttmnhWxLBU/v0FCvT4uhuKNDNHvEs+hg
        E+85AWFmlKqkUt3VMrAMjcfJkVzYe4FW41GoZL90YEhimYVtKuzfm7FNgjNGygOmvNLoVf
        kNevH6w3S/WK7COej1h6/l4O5VTjFoY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456962;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=biyQfW85R26FBpzSflFh1HGgDmjBo6SyzVlhE+RclBU=;
        b=w5YsQ8/3w7v4UrCPTWzCg514er8E5OAcqtReiwP16gg8v3aB1s34IJnX5KhTE5bITTEYyB
        J2JW74ejwQNo4VAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6380413912;
        Mon, 27 Feb 2023 00:16:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /fR8BkH2+2O6dQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:16:01 +0000
Subject: [PATCH 1/6] Use existence of /etc/initrd-release to detect initrd.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745678751.16565.12510750935171291813.stgit@noble.brown>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Since v183, systemd has used the existence of /etc/initrd-release to
detect if it is running in an initrd, rather than looking at the magic
number of the root filesystem's device.  It is time for mdadm to do the
same.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 util.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/util.c b/util.c
index 9cd89fa416bd..6b44662db7cd 100644
--- a/util.c
+++ b/util.c
@@ -2217,15 +2217,7 @@ int continue_via_systemd(char *devnm, char *service_name)
 
 int in_initrd(void)
 {
-	/* This is based on similar function in systemd. */
-	struct statfs s;
-	/* statfs.f_type is signed long on s390x and MIPS, causing all
-	   sorts of sign extension problems with RAMFS_MAGIC being
-	   defined as 0x858458f6 */
-	return  statfs("/", &s) >= 0 &&
-		((unsigned long)s.f_type == TMPFS_MAGIC ||
-		 ((unsigned long)s.f_type & 0xFFFFFFFFUL) ==
-		 ((unsigned long)RAMFS_MAGIC & 0xFFFFFFFFUL));
+	return access("/etc/initrd-release", F_OK) >= 0;
 }
 
 void reopen_mddev(int mdfd)


