Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7166C64ED6
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjB0AQf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjB0AQa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:30 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3691165E
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:16:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AF5A221A05;
        Mon, 27 Feb 2023 00:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tUAQtSqdmIk78XH3a+alvk2vRpbDJL0i9d1sVuxk4M=;
        b=R/LFn7dcFo3jG/RlTegnQ8ckWY/sm0Jm7pJNTfEhLRfXAFkX80FxA5AvgyZvXPWkKL1AkQ
        h2jIDybJiVwy7HIuK5r/2rEoRvtlwi16xi+pzMR92aDxDF11ny/dxBksjTV9EBiqubU16E
        ZQ5WtGtc3/LgvB79EJbDOFjSseVc5Xs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tUAQtSqdmIk78XH3a+alvk2vRpbDJL0i9d1sVuxk4M=;
        b=hMD4lzz5dKAou5EYCRIDUSlh7aHYYk+JXzMnt4JLonDbXl6HIa1RVXk2HHg/HGvNwgaZmA
        2NqVthqOyJnsnnBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E91E13912;
        Mon, 27 Feb 2023 00:16:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id seiJMFn2+2PzdQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:16:25 +0000
Subject: [PATCH 5/6] mdmon: Remove need for KillMode=none
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745678753.16565.4556106790376379653.stgit@noble.brown>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
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

As described in systemd.service(5), this conflict which shutdown can be
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
index 3502fadc3fc4..3ab908c45a3b 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -10,6 +10,9 @@ Description=MD Metadata Monitor on /dev/%I
 DefaultDependencies=no
 Before=initrd-switch-root.target
 Documentation=man:mdmon(8)
+# allow this to keep running after switchroot, until a new
+# instance is started
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


