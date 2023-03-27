Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2533C761A6
	for <linux-raid@archiver.kernel.org>; Mon, 27 Mar 2023 13:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjC0NZa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjC0NY5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Mar 2023 09:24:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986E044B6
        for <linux-raid@vger.kernel.org>; Mon, 27 Mar 2023 06:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ui34VP0V+QC6wWMG4ZdbC0pVVInhui/1SjnIEjUUE7Q=;
        b=VzuARDO4fh0swi1oTLQ5mkTR/tGlEDtg5PmG7nhaiHnkv1xrD5zmYrIlQdUFK0bM0U0uPg
        Ug1meBZ4sNLXwWwOsihrd0xHbHu1DdxtQblBV5mYw8j16ygv7MF7Rl4xXviFMGbV5qpdK8
        2aooOCfrXJuE8jyZfpBW2rxa/sLqV/Y=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-ef_---lhMsmjdeNLXo9IDg-1; Mon, 27 Mar 2023 09:23:30 -0400
X-MC-Unique: ef_---lhMsmjdeNLXo9IDg-1
Received: by mail-qk1-f197.google.com with SMTP id pc36-20020a05620a842400b00742c715894bso3941922qkn.21
        for <linux-raid@vger.kernel.org>; Mon, 27 Mar 2023 06:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ui34VP0V+QC6wWMG4ZdbC0pVVInhui/1SjnIEjUUE7Q=;
        b=eTQo7hGeNDvDDvKoFy2kM5EVPoPOZBBPfBHW/LMBmfvvSzEo138QiC8HIBRVSowJX2
         H2X7QD60ZgjGnVAg3Y/zUmqdJU4lrpnygFPA2O4JY6XDzEMeXrSI0xLVPhppbKy3Llho
         qSnehl9Jilyn9sp3sXBvrdiKvA9nuZqx8Y3c7yMT8hCcO4GbLYJDFCh/56T9I5d/pKQw
         Mx+yPUMAxBIk8eTQy74hM+Z7dlE6YRbuVKi8riw0u4uaWn+E9UOAq/g+7+xZOzL4Xndt
         EztB7Z+Vo4hMPZFC8XiiL82P81lIshfsMbcRdWMSeGxoWC7Y7cVXAwo+oSMZ+dFDToyk
         hCiA==
X-Gm-Message-State: AO0yUKXFv/ErGxIJy/8j5LWLPY9O8Ae2NjhqPBuL4q8ggD9eVUinIvDq
        ltDmHqGWX34AIzbOgs+Mk5di1iPVDYajbBgyTnnII1W7btSkaKXAjww5BjtmnMcSP07njcllAea
        kcLUQu9Bi8bc603IlxTDTAQ==
X-Received: by 2002:a05:622a:40a:b0:3db:7f42:ab0f with SMTP id n10-20020a05622a040a00b003db7f42ab0fmr19454882qtx.67.1679923409754;
        Mon, 27 Mar 2023 06:23:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set+TKrzjeDXUF1w6E7KXi6Z2D3VUgzjcBgQe8o1XtRAeXO/pT5DBPtMKGbooPmazbkCED5aifw==
X-Received: by 2002:a05:622a:40a:b0:3db:7f42:ab0f with SMTP id n10-20020a05622a040a00b003db7f42ab0fmr19454839qtx.67.1679923409444;
        Mon, 27 Mar 2023 06:23:29 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j23-20020ac86657000000b003e0c29112b6sm10606129qtp.7.2023.03.27.06.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:23:29 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     song@kernel.org, nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] md/raid5: remove unused working_disks variable
Date:   Mon, 27 Mar 2023 09:23:24 -0400
Message-Id: <20230327132324.1769595-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

clang with W=1 reports
drivers/md/raid5.c:7719:6: error: variable 'working_disks'
  set but not used [-Werror,-Wunused-but-set-variable]
        int working_disks = 0;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: remove brances
---
 drivers/md/raid5.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..812a12e3e41a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7716,7 +7716,6 @@ static void raid5_set_io_opt(struct r5conf *conf)
 static int raid5_run(struct mddev *mddev)
 {
 	struct r5conf *conf;
-	int working_disks = 0;
 	int dirty_parity_disks = 0;
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
@@ -7912,10 +7911,8 @@ static int raid5_run(struct mddev *mddev)
 			pr_warn("md: cannot handle concurrent replacement and reshape.\n");
 			goto abort;
 		}
-		if (test_bit(In_sync, &rdev->flags)) {
-			working_disks++;
+		if (test_bit(In_sync, &rdev->flags))
 			continue;
-		}
 		/* This disc is not fully in-sync.  However if it
 		 * just stored parity (beyond the recovery_offset),
 		 * when we don't need to be concerned about the
-- 
2.27.0

