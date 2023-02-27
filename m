Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312A1C7EE23
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjB0AQb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjB0AQX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFF116AE8
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:16:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 91BC321A05;
        Mon, 27 Feb 2023 00:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJaKBkydodC5lrhtBAnyoOz6Znaw5dF4tyZ0+FiHqxU=;
        b=gpYcW+1C6+x81I5udSHwlhBPjltC1xIv1rAxsGESnHSzUrzx6XKi1u4/WcNGvO3UP5J3oY
        srH4xXx0htxR1HM34F+nTUj5wH5Zk/92cVqGRN3YpJ9UBt3Wf7EusF0jlbfyrlbON35Tax
        zh8q5qLAV3DGfFEtRBDJMrUqTTaOdQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456980;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJaKBkydodC5lrhtBAnyoOz6Znaw5dF4tyZ0+FiHqxU=;
        b=somrpsiByP+1lWbjMTQUeiNEzDE68y7rItrChRHoESCjEUGac7VDUPwpMAygVHMOoFf3B9
        zsIaJS5FC3YYJjDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40D1113912;
        Mon, 27 Feb 2023 00:16:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aLBbOVH2+2PcdQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:16:17 +0000
Subject: [PATCH 4/6] mdmon: change systemd unit file to use --foreground
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745678752.16565.7116046778637460538.stgit@noble.brown>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
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


