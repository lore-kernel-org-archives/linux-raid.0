Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA00EB64DD
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 09:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjHNJ2k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbjHNJ2G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 05:28:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921A8E77
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 02:27:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4B5641FD60;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1692005241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLf4dsN/4HaX73SrOX4tPPdgwuMr94/niyIot57MHUU=;
        b=vu5696MuxiQGbl9YPVd2vKt6SwKMn7PxcTVXF5qi3FQY7W23ea9uvvhdr9Qt3Kr38uNWyd
        al82HRYh75dr+rypQehFZXKkujj7LzzluZNqS0JW1kDq1CqMqWW1+vwdQl0ELCd3FtUQQE
        XDPy40m/1dyVuk2O0nOkRuQkRu9a2oQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1692005241;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLf4dsN/4HaX73SrOX4tPPdgwuMr94/niyIot57MHUU=;
        b=5LgxoQ+XaveT+zRFv5QtQctba7y9iPsCFB96Xy0U4gYdq3u9TbArRATNdwggwRXRCG6lND
        JkolL46uLvnxWrAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39BF213AA7;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JZ4RDnnz2WRObAAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 14 Aug 2023 09:27:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 76E8BA0775; Mon, 14 Aug 2023 11:27:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] md/raid0: Fix performance regression for large sequential writes
Date:   Mon, 14 Aug 2023 11:27:08 +0200
Message-Id: <20230814092720.3931-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230814091452.9670-1-jack@suse.cz>
References: <20230814091452.9670-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3248; i=jack@suse.cz; h=from:subject; bh=7ampjRduZyHKAVEtuJBNxWHOUxJWLU2eh6Z3RGx8LdE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBk2fNrxcCeIoHBDkXCfmmvVx6QESJrrQikEricr/5V R/5F8z+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZNnzawAKCRCcnaoHP2RA2bIyCA Cmi3RKUFzAasCVsfSFYcPEiUQ6wsFwbeSXSAm00X4qxnSG7ovd5WNu2Lw5hnIqCXuNYDf+9C0Ra5JK QsTafD6E90OZ0Rm6Bc1BQEXwp47ghyOvrzrjhgr9qbNdo3GA7twL1i4KK+z0zsGWE3hc8+fXqwHmFb mwJR57SRv5t1lrgYZfaLWpY4I0GxVorIceV9cdkGjCcWbUTBSvdcMFY1dpsOfeI6Svpl9efYP8ODpQ NDdciKmda4LCDLLAuVDFadZwaPA+EgYNBMJpLYR4jh0aLEw68Ni22BKnCKfOMYtRDDWCalPewYRHz7 odl5Mdg/s59phdbd/zf9qmEpfSfwyD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit f00d7c85be9e ("md/raid0: fix up bio splitting.") among other
things changed how bio that needs to be split is submitted. Before this
commit, we have split the bio, mapped and submitted each part. After
this commit, we map only the first part of the split bio and submit the
second part unmapped. Due to bio sorting in __submit_bio_noacct() this
results in the following request ordering:

  9,0   18     1181     0.525037895 15995  Q  WS 1479315464 + 63392

  Split off chunk-sized (1024 sectors) request:

  9,0   18     1182     0.629019647 15995  X  WS 1479315464 / 1479316488

  Request is unaligned to the chunk so it's split in
  raid0_make_request().  This is the first part mapped and punted to
  bio_list:

  8,0   18     7053     0.629020455 15995  A  WS 739921928 + 1016 <- (9,0) 1479315464

  Now raid0_make_request() returns, second part is postponed on
  bio_list. __submit_bio_noacct() resorts the bio_list, mapped request
  is submitted to the underlying device:

  8,0   18     7054     0.629022782 15995  G  WS 739921928 + 1016

  Now we take another request from the bio_list which is the remainder
  of the original huge request. Split off another chunk-sized bit from
  it and the situation repeats:

  9,0   18     1183     0.629024499 15995  X  WS 1479316488 / 1479317512
  8,16  18     6998     0.629025110 15995  A  WS 739921928 + 1016 <- (9,0) 1479316488
  8,16  18     6999     0.629026728 15995  G  WS 739921928 + 1016
  ...
  9,0   18     1184     0.629032940 15995  X  WS 1479317512 / 1479318536 [libnetacq-write]
  8,0   18     7059     0.629033294 15995  A  WS 739922952 + 1016 <- (9,0) 1479317512
  8,0   18     7060     0.629033902 15995  G  WS 739922952 + 1016
  ...

  This repeats until we consume the whole original huge request. Now we
  finally get to processing the second parts of the split off requests
  (in reverse order):

  8,16  18     7181     0.629161384 15995  A  WS 739952640 + 8 <- (9,0) 1479377920
  8,0   18     7239     0.629162140 15995  A  WS 739952640 + 8 <- (9,0) 1479376896
  8,16  18     7186     0.629163881 15995  A  WS 739951616 + 8 <- (9,0) 1479375872
  8,0   18     7242     0.629164421 15995  A  WS 739951616 + 8 <- (9,0) 1479374848
  ...

I guess it is obvious that this IO pattern is extremely inefficient way
to perform sequential IO. It also makes bio_list to grow to rather long
lengths.

Change raid0_make_request() to map both parts of the split bio. Since we
know we are provided with at most chunk-sized bios, we will always need
to split the incoming bio at most once.

Fixes: f00d7c85be9e ("md/raid0: fix up bio splitting.")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d3c55f2e9b18..595856948dff 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -626,7 +626,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		raid0_map_submit_bio(mddev, bio);
 		bio = split;
 	}
 
-- 
2.35.3

