Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4778EC61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCMDpw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCMDpw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19FB35275
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6260E22AB4;
        Mon, 13 Mar 2023 03:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15cwGEnrI5h6mTH/Q7UMZPtvHehxktGRMO6kf6UmgVk=;
        b=YHWXoLgqGLOOhaEGqOknuABzM/gRSSSBYrVS5hKIyWVKFp/KeMZDHnV0ft4VGYRHlvshBu
        xg49tVY8dfe61obl/95enMdeHHYDkmhKcarrbZ85QX+yXCim7Knzd8Qjnx/IaFs4jLIFt9
        8jzMkwNJrsS5UcudWyWeyVszkke6Bhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679149;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15cwGEnrI5h6mTH/Q7UMZPtvHehxktGRMO6kf6UmgVk=;
        b=YfSkJ2xvMhDSOxa5/CGlooul8HO58hCJq4UM33sCAqc3pqkmDq6t/VbkNkFYBFkGMqGGIe
        cREr1nkn/hJiB9CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93EE213463;
        Mon, 13 Mar 2023 03:45:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ScGGEmucDmSkCAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:47 +0000
Subject: [PATCH 5/6] mdmon: Remove need for KillMode=none
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897870.11443.17356255216855712787.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mdmon needs to keep running during the switchroot out of (at boot) and
then back into (at shutdown) the initrd.  It runs until a new mdmon
takes over.

Killmode=none is used to achieve this, with the help of --offroot which
sets argv[0][0] to '@' which systemd understands.

This is needed because mdmon is currently run in system-mdmon.slice
which conflicts with shutdown.target so without Killmode=none mdmon
would get killed early in shutdown when system.mdmon.slice is removed.

As described in systemd.service(5), this conflict with shutdown can be
resolved by explicitly requesting system.slice, which is a natural
counterpart to DefaultDependencies=no.

So add that, and also add IgnoreOnIsolate=true to avoid another possible
source of an early death.  With these we no longer need KillMode=none
which the systemd developers have marked as "deprecated".

Signed-off-by: NeilBrown <neilb@suse.de>
---
 systemd/mdmon@.service |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index 3502fadc3fc4..79f80b5c372e 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -10,6 +10,9 @@ Description=MD Metadata Monitor on /dev/%I
 DefaultDependencies=no
 Before=initrd-switch-root.target
 Documentation=man:mdmon(8)
+# Allow mdmon to keep running after switchroot, until a new
+# instance is started.
+IgnoreOnIsolate=true
 
 [Service]
 # The mdmon starting in the initramfs (with dracut at least)
@@ -22,4 +25,6 @@ ExecStart=BINDIR/mdmon --foreground --offroot --takeover %I
 # it out) and systemd will remove it when transitioning from
 # initramfs to rootfs.
 #PIDFile=/run/mdadm/%I.pid
-KillMode=none
+# The default slice is system-mdmon.slice which Conflicts
+# with shutdown, causing mdmon to exit early.  So use system.slice.
+Slice=system.slice


