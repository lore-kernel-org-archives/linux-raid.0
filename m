Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AA5C25B06
	for <linux-raid@archiver.kernel.org>; Fri, 12 Aug 2022 02:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbiHLCQ7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Aug 2022 22:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiHLCQ6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Aug 2022 22:16:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDC2A260F
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 19:16:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 38AC55D5A6;
        Fri, 12 Aug 2022 02:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660270616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cDt+trVsWD4FVUfjQ6ZCr6Epf4W3LzskvL0G+gNFJBA=;
        b=C3xuGMaBvNgf1Mcd+xh+l5zMAbh36m/YqS9NeBPql1kNcv+iHCe6ziNtfGYhMx5rlTHJH1
        +rn+MClGm2Hz5RnX5kGGcliSnt6ZC3xCoXdhPB2kEAG+z8m7qnrSvcctePFVCw61NWCEYk
        wdeG2Vd8UZtizj3UBf0hflQxZvZF3Ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660270616;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cDt+trVsWD4FVUfjQ6ZCr6Epf4W3LzskvL0G+gNFJBA=;
        b=GP5t8KeMNlyzqOGDxgVEvy1IY3570fEIlUvtVh04zVZwjOJExdCJj5xe7UPcTf5YII3Qom
        LYL+T/DRSaoskgDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 28CC113AAE;
        Fri, 12 Aug 2022 02:16:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yNgZNha49WK8FwAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 12 Aug 2022 02:16:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH RFC] md: call md_cluster_stop() in __md_stop()
Date:   Fri, 12 Aug 2022 12:16:51 +1000
Message-id: <166027061107.20931.13490156249149223084@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


[[ I noticed the e151 patch recently which seems to admit that it broke=20
   something.  So I looked into it and came up with this.
   It seems to make sense, but I'm not in a position to test it.
   Guoqing: does it look OK to you?
   - NeilBrown
]]

As described in Commit: 48df498daf62 ("md: move bitmap_destroy to the
beginning of __md_stop") md_cluster_stop() needs to run before the
mdddev->thread is stopped.
The change to make this happen was reverted in Commit: e151db8ecfb0
("md-raid: destroy the bitmap after destroying the thread") due to
problems it caused.

To restore correct behaviour, make md_cluster_stop() reentrant and
explicitly call it at the start of __md_stop(), after first calling
md_bitmap_wait_behind_writes().

Fixes: e151db8ecfb0 ("md-raid: destroy the bitmap after destroying the thread=
")
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md-cluster.c | 1 +
 drivers/md/md.c         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 742b2349fea3..37bf0aa4ed71 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1009,6 +1009,7 @@ static int leave(struct mddev *mddev)
 	     test_bit(MD_CLOSING, &mddev->flags)))
 		resync_bitmap(mddev);
=20
+	mddev->cluster_info =3D NULL;
 	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 	md_unregister_thread(&cinfo->recovery_thread);
 	md_unregister_thread(&cinfo->recv_thread);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index afaf36b2f6ab..a57b2dff64dd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6238,6 +6238,9 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers =3D mddev->pers;
+
+	md_bitmap_wait_behind_writes(mddev);
+	md_cluster_stop(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
--=20
2.36.1

