Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB16C64ED6
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjB0AQS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjB0AQR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF5166D8
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:16:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 803BA21A05;
        Mon, 27 Feb 2023 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXciMMKUe/VfKuBXDImPZmixs79pSCFsGkKbtGXLHX0=;
        b=h9o56KtpUmuO1E5L82JxqNp1RYaRW/zfAUdmTWPEajL77VKRtEiOqoRHWUGNsO1HaopmaK
        HjrK+Bj+vt1UO+njeHE+vT5lnGYK0tF5MHM6+9Tqehrg3bBPrLeeGtsRM8kx+I3CxAO99/
        O0OxpWiGy6CPlip7DjTkHlRiY8PeE88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456974;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXciMMKUe/VfKuBXDImPZmixs79pSCFsGkKbtGXLHX0=;
        b=J5TTRJ5KG4et6p3zJQn52bYpHAG5UiZ90BmM4SzVKt78dGOhCo5zTaFoDV895fI8FeelX6
        caZ7c1yM5vOyDOBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C3A613912;
        Mon, 27 Feb 2023 00:16:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O6FhLUz2+2PSdQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:16:12 +0000
Subject: [PATCH 3/6] mdmon: don't test both 'all' and 'container_name'.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745678752.16565.9787611444570379100.stgit@noble.brown>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If 'all' is not set, then container_name must be NULL, as nothing else
can set it.  So simplify the test it ignore container_name.
This makes the purpose of the code more obvious.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 mdmon.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index f557e12c6533..6d37b17c3f53 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -358,7 +358,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
-
 	if (in_initrd()) {
 		/*
 		 * set first char of argv[0] to @. This is used by
@@ -368,12 +367,10 @@ int main(int argc, char *argv[])
 		argv[0][0] = '@';
 	}
 
-	if (all == 0 && container_name == NULL) {
-		if (argv[optind]) {
-			container_name = get_md_name(argv[optind]);
-			if (!container_name)
-				return 1;
-		}
+	if (!all && argv[optind]) {
+		container_name = get_md_name(argv[optind]);
+		if (!container_name)
+			return 1;
 	}
 
 	if (container_name == NULL || argc - optind > 1)


