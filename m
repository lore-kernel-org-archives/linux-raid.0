Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3236C61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 03:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCMDpj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Mar 2023 23:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCMDpg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Mar 2023 23:45:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47CF35275
        for <linux-raid@vger.kernel.org>; Sun, 12 Mar 2023 20:45:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5F5721FE04;
        Mon, 13 Mar 2023 03:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678679134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnd/YuGcn5taUH4pR/rssoFxWQ0sLTN7l84W3NXtS/w=;
        b=zJPZPk3YNRJrbSBthDF17oAhGWHAo832Q/V5Lddz/aCt0IrXTz7jg9SN1bgtTbv2XwU01l
        AqU+ZclNnGAIcOQPfq1H2WQZsXHfNwZmIv6wR2VekeeL86e9dn8VO3xsysLs8Vut83HAfy
        zn4XsUbBBzyUGGdzWiGrnNR8EMweskk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678679134;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnd/YuGcn5taUH4pR/rssoFxWQ0sLTN7l84W3NXtS/w=;
        b=xFLDQ+Ut1yqg/aum/vfNwb+vigdyoSbRsjWFbzJq9VcLsib8HVFwV0bhGezvux3eTzWHhI
        tRqhQhWoK/8uCWAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A1E1B13463;
        Mon, 13 Mar 2023 03:45:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b8ZnFlycDmSRCAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 13 Mar 2023 03:45:32 +0000
Subject: [PATCH 3/6] mdmon: don't test both 'all' and 'container_name'.
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 14:42:58 +1100
Message-ID: <167867897869.11443.12453413152392906620.stgit@noble.brown>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If 'all' is not set, then container_name must be NULL, as nothing else
can set it.  So simplify the test to ignore container_name.
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


