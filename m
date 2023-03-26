Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0EFC6FD1C
	for <linux-raid@archiver.kernel.org>; Sun, 26 Mar 2023 12:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCZM5Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Mar 2023 08:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjCZM5X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Mar 2023 08:57:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCA17D9D
        for <linux-raid@vger.kernel.org>; Sun, 26 Mar 2023 05:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679835402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=47SSw0FAIC6XRUpZxGWJ69o8W+2IBdufTOfNiRZChbc=;
        b=anJzAu5lQiL31+lV5t3Jv1WXe+JzsRa38HArQWvkJqaNQM4BHwfw9UryezYaYvgOOjdwu3
        QIe59YNq6/fGgOkI0ONB6gK40dxrcMzpRy7JLOd/bHHo3pTQfsOLF/XoVayakeSeawGGHA
        1sC4aSFk+Unvad9r5UgWsqM4l/Gjuuc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-FRw7ZaNlOEiqbk21z9W2Aw-1; Sun, 26 Mar 2023 08:56:41 -0400
X-MC-Unique: FRw7ZaNlOEiqbk21z9W2Aw-1
Received: by mail-qt1-f198.google.com with SMTP id r4-20020ac867c4000000b003bfefb6dd58so4249743qtp.2
        for <linux-raid@vger.kernel.org>; Sun, 26 Mar 2023 05:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679835400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47SSw0FAIC6XRUpZxGWJ69o8W+2IBdufTOfNiRZChbc=;
        b=FHrshoKwrtUuQinVuhMLoypRv1oHSFZn8i3ExzYfKGeJsva9Wyr4iOsc3voOvFRht7
         Cqqe7rlz/UXxuC2LEDgHtn3xN8RB7dmts01yp1hoGe70Bh5OEMQBgaknBXxz3cRJHiZR
         L6kboaZkXJZG4BTusBfo7JRFz40sVnNPtff4vNAsWNS6aJYP9S+pOQNtyZnIM2SFEg3p
         b8d8JvN1TIow49NpwWTfZaDnEi4LPnovhFrATXA+AtHKlRYxp/QRwqAV1OWtDxtenakE
         JwnBXC3frEwNjBazyOffxOeuq38+6+8458KZjLjE1Y6rUlCVT/uKPxkVZgFhMJPx9nWk
         hc8Q==
X-Gm-Message-State: AAQBX9cNlYNUpeB2b+3tX9yEYTXr4HvJhbfxQMLlv5Dt5bPXzj+AP6M5
        0HfZCVi0t1NUFmO+GIZchT6/GuHjMbeLJKfjwGQWQq1LBRpwu2+8o9NNRAcSbXDNyftRBXH+QwJ
        RTJj8cUaHvqsgpQHJG8idWw==
X-Received: by 2002:a05:6214:1250:b0:5bd:74a7:e6f0 with SMTP id r16-20020a056214125000b005bd74a7e6f0mr14502200qvv.20.1679835400645;
        Sun, 26 Mar 2023 05:56:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350bhx11T/RNLAJdDBA6Mssd67CsVxPgrDHm9hYyEZVFHfIDz4wjUNY5I3aS4EEt4hazRV+cDfA==
X-Received: by 2002:a05:6214:1250:b0:5bd:74a7:e6f0 with SMTP id r16-20020a056214125000b005bd74a7e6f0mr14502188qvv.20.1679835400391;
        Sun, 26 Mar 2023 05:56:40 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r80-20020a374453000000b007465ee178a3sm14628954qka.96.2023.03.26.05.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 05:56:40 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     song@kernel.org, nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] md/raid5: remove unused working_disks variable
Date:   Sun, 26 Mar 2023 08:56:37 -0400
Message-Id: <20230326125637.1352895-1-trix@redhat.com>
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
 drivers/md/raid5.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..2b1e78c46817 100644
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
@@ -7913,7 +7912,6 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 		}
 		if (test_bit(In_sync, &rdev->flags)) {
-			working_disks++;
 			continue;
 		}
 		/* This disc is not fully in-sync.  However if it
-- 
2.27.0

