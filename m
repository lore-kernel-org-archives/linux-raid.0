Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C813C61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCMDpp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCMDpn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B053669E
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8306022AB4;
        Mon, 13 Mar 2023 03:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJaKBkydodC5lrhtBAnyoOz6Znaw5dF4tyZ0+FiHqxU=;
        b=dzyFnFf7YOap2jLmIh1qi3dllYF4lhKhNIroFQ5KMoNvmBYDi8p9iE4fuoKpVaGy8StFJz
        0FXqLHkrub48d8WcKKhzZUYJeMJYkaugcFLVqrHh1aW1e0TQiX1SprgSNk6QiG2LNUzAkl
        ezojQ9TZyt7jHK561jqgNFSI/F9hS9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679140;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJaKBkydodC5lrhtBAnyoOz6Znaw5dF4tyZ0+FiHqxU=;
        b=Gd8xgHMWlUUn5o0Xu3V057tqUsEVndE61L2rsaBYa/9NOpYy3pfKqHsiTVKuSJRYY4pXOo
        yU1o1R+wTG9s+UBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C222713463;
        Mon, 13 Mar 2023 03:45:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jClZHmKcDmSeCAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:38 +0000
Subject: [PATCH 4/6] mdmon: change systemd unit file to use --foreground
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897869.11443.112933145568864201.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is no value in mdmon forking when it is running under systemd -
systemd can still track it anyway.

So add --foreground option, and remove "Type=forking".

Signed-off-by: NeilBrown <neilb@suse.de>
---
 systemd/mdmon@.service |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
index e7ee17a8bf91..3502fadc3fc4 100644
--- a/systemd/mdmon@.service
+++ b/systemd/mdmon@.service
@@ -17,8 +17,7 @@ Documentation=man:mdmon(8)
 # 'takeover'.  As the '--offroot --takeover' don't hurt when
 # not necessary, are are useful with root-on-md in dracut,
 # have them always present.
-ExecStart=BINDIR/mdmon --offroot --takeover %I
-Type=forking
+ExecStart=BINDIR/mdmon --foreground --offroot --takeover %I
 # Don't set the PIDFile.  It isn't necessary (systemd can work
 # it out) and systemd will remove it when transitioning from
 # initramfs to rootfs.


