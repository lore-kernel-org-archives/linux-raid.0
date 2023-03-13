Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD65C61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCMDpa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCMDp0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA0360A6
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 80B211FE05;
        Mon, 13 Mar 2023 03:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUv27qBLbmbA+uBGawtk15gIv29Xrxw2qfxVwNncG1k=;
        b=L5golzxhAVjxslu3d8tgdF9lzRknNBj3Fr6aitQcbvZuGs2QEl2UY0vM5WD0SD3JcixQ8d
        AdbEsYShFpfD5z5ifpmJlX4BEIcDbHggaATBcupIWV3D/Hp54oNzdnVZznMguPGi2yk+41
        8arO1ROhGJTE6j/DluscyJ2cEu0NvT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679123;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUv27qBLbmbA+uBGawtk15gIv29Xrxw2qfxVwNncG1k=;
        b=nrlFJQFSerxepv/Q+M3RV3iRHwrhFkCxBofVKtpjGOkrN2O5SRvQnZrGjSv0U/gFOjZunW
        1Hf7XV0m6sCA75BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B1C0313463;
        Mon, 13 Mar 2023 03:45:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kgSlGVGcDmR8CAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:21 +0000
Subject: [PATCH 1/6] Use existence of /etc/initrd-release to detect initrd.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897868.11443.18016379077963467936.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
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
index 9f1e1f7c1279..509fb43ea906 100644
--- a/util.c
+++ b/util.c
@@ -2227,15 +2227,7 @@ int continue_via_systemd(char *devnm, char *service_name)
 
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


