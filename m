Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED1C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 22:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54AF4613FA
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 22:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhDTWEe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbhDTWEe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Apr 2021 18:04:34 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CCBC06174A
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 15:04:02 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id gv2so10160787qvb.8
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 15:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=us-sios-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:from:date:subject:to:cc;
        bh=rXsIbRZ1/DLSIPLcgi8H36eWipFEKNECGcgKWBWNdNY=;
        b=k8jpd3BIcq1sv3W32CSXcF+QUWJRqKHZyt4i8mqmj2/5MfRT2YpSCicGX2pNmVxETy
         DRlUV3+QA9fni40XHZF3mc+djrfqN9TADh2sBoqcYEKe88ZdjUARZ8QSIzQRNeA8OUxA
         H/DhHjZszv9IuM6C4XMRW65YvMYQaaXtkidM2NXMn9m/1gx3t1NST8tXRTJex0czc8in
         o0xCujyODSGfhODYAo80RE0Bu61UY4lFUhb1hdO3CiaHwXD6Ox5Gr9ra12WKLD9FX+8G
         r9IR93tYodzSrIyI6+PiYbRvK9F5Ms5MuUcI9n6M3+sFnnY8j5i/DQl5JnN+EkrFldOz
         jMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:date:subject:to:cc;
        bh=rXsIbRZ1/DLSIPLcgi8H36eWipFEKNECGcgKWBWNdNY=;
        b=Q4ce0MYR4Jd30WuIOVZqEkVDknmjtsGo425PDx2M/acgb9SW/7vKq3+HcrU+c/oIDd
         J3KPOHZao5Ojd9Hgy/uYHrMzwVoTJYhkKZyw9ZQaa+rw+JJma6aHGJwAqYImiATOFdd1
         B3rHWSU51Q0tCfg/FNWFgQy/x+XwUSYB/H51o/S3YDawKaZZsnHDiWnMYWibqKWZ/Hit
         oH/ZjrY+SWcOoluDJiVcE8K2ftcnFsdaVhkiSNb+n9ByPR/Zz8dJDGN+zbat2+6lx5F7
         zIJbLJ34YmaZKIafy7msVF6HEYwPP0JKxeTkqkQarfuUtSsQklgap9QelKQ8XU7SYDqJ
         6juQ==
X-Gm-Message-State: AOAM532SF93VaNscF7nhtg5CMozJamYZ65uVGyaPM3Fj2eFa26WOWcdm
        DUiABAblVOzIBegeZljyiDFvoY1y1nKdMQ==
X-Google-Smtp-Source: ABdhPJwv63WIhFOJpNG1nIFVoDxhevCM/KKxlhc0KtMl0ngJ3Gt/XiFsL1eiFzPcQCn9/IH+C14xgw==
X-Received: by 2002:a0c:d80a:: with SMTP id h10mr29148898qvj.25.1618956240921;
        Tue, 20 Apr 2021 15:04:00 -0700 (PDT)
Received: from enceladus ([75.176.198.76])
        by smtp.gmail.com with ESMTPSA id d11sm67637qto.59.2021.04.20.15.03.59
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Apr 2021 15:04:00 -0700 (PDT)
Message-ID: <607f4fd0.1c69fb81.9f7e7.05ef@mx.google.com>
Received: by enceladus (sSMTP sendmail emulation); Tue, 20 Apr 2021 18:03:58 -0400
From:   Paul Clements <paul.clements@us.sios.com>
Date:   Thu, 15 Apr 2021 17:17:57 -0400
Subject: [PATCH] md/raid1: properly indicate failure when ending a failed
 write request
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch addresses a data corruption bug in raid1 arrays using bitmaps.
Without this fix, the bitmap bits for the failed I/O end up being cleared.

Since we are in the failure leg of raid1_end_write_request, the request
either needs to be retried (R1BIO_WriteError) or failed (R1BIO_Degraded).

Signed-off-by: Paul Clements <paul.clements@us.sios.com>

---
 drivers/md/raid1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d2378765dc15..ced076ba560e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -478,6 +478,8 @@ static void raid1_end_write_request(struct bio *bio)
 		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
 		else {
+			/* Fail the request */
+			set_bit(R1BIO_Degraded, &r1_bio->state);
 			/* Finished with this branch */
 			r1_bio->bios[mirror] = NULL;
 			to_put = bio;
-- 
2.17.1

