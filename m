Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FA8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 01:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8C4660F38
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 01:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJ1BDa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 21:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJ1BD3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Oct 2021 21:03:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737B3C061570;
        Wed, 27 Oct 2021 18:01:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so6592172pjl.2;
        Wed, 27 Oct 2021 18:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+zQD8CQaycNrdXa2NhAlfSk8bkMuLuQctVMZwAMb5o=;
        b=oJ+zSBHPinxWCKj93v1TqObCHmImdDl+iVeTO3ls/858ugBtndDUFuSJ0pgqQ8AOzm
         E+/TfN1Z6carxLC7YuefyE/UcAsl/LeUaWAoCFfYPovNpZLWD2vV0YKf20vvQbOafFsW
         RW8EKHNU9WvPEQiApp7/CQqpdTDqNZFy8ZCjuwInqa88rCPe6LPNKreeihMyW9010ehS
         /8HDBn7L1makPYc/dBtOR6Cy9W1yIyceO5riPMIsDl1Uv+PtV+X7nHKO4tIRiEYVp01W
         nxTd/EBXmZhrjJAjW0tmgF99w/78M92ZaBlPUBO2kT51jkxAR+iLRVbvS/DOib6MonZ3
         5b3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+zQD8CQaycNrdXa2NhAlfSk8bkMuLuQctVMZwAMb5o=;
        b=ZlVWyjLIqVbwThpCmPelG8KLgP99xI8dXQWHAnnJJRQVNlGkQeNu9MRWfesixWaKGw
         Pfvv1lUznjyxMjeOmABIzguqyyOebKv5mhVgSQy6siwD8Nxy5+mxzLIuhoXKhXoWT/sd
         zW/ttalMR9Uqtn9nUsmPy6uWeAx8czhkAlicjPcLo1kHRVHaS0CS8EsK3Q1lYiLx/PYP
         12bsAkkj/VO5BzuH63YyJoC0gADEC6ClA4u58JrrnAIiAAPxTOdKM9eA6yGk+91YdPqc
         G7IUrG/QQexCS1YTxDr5JS3qr9RUmgWeQCFN6Er1Kaok3xLfj0MNOfSr9nIGb5FNbn+C
         zpBA==
X-Gm-Message-State: AOAM531m6kxeGtvHFsXDgbgbzl+tWmtpQh9E/Niu3cj6qrz9L7YXEdMz
        qzc4Vq9Tvf3KXcYwPaKbHL8BZBVRGSw=
X-Google-Smtp-Source: ABdhPJzSYpIZ+33E+8PEAVvvZYtjRpm8RofSxaJx4otwP2iPfs4TZMTGuzOeMag6lff4YX7GC7mGkw==
X-Received: by 2002:a17:90b:3892:: with SMTP id mu18mr9469296pjb.102.1635382862984;
        Wed, 27 Oct 2021 18:01:02 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y9sm849287pjj.6.2021.10.27.18.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 18:01:02 -0700 (PDT)
From:   Yang Guang <cgel.zte@gmail.com>
X-Google-Original-From: Yang Guang <yang.guang5@zte.com.cn>
To:     Song Liu <song@kernel.org>
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] raid5-ppl: use swap() to make code cleaner
Date:   Thu, 28 Oct 2021 01:00:53 +0000
Message-Id: <20211028010053.7609-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Using swap() make it more readable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/md/raid5-ppl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 3ddc2aa0b530..4ab417915d7f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1081,7 +1081,7 @@ static int ppl_load_distributed(struct ppl_log *log)
 	struct ppl_conf *ppl_conf = log->ppl_conf;
 	struct md_rdev *rdev = log->rdev;
 	struct mddev *mddev = rdev->mddev;
-	struct page *page, *page2, *tmp;
+	struct page *page, *page2;
 	struct ppl_header *pplhdr = NULL, *prev_pplhdr = NULL;
 	u32 crc, crc_stored;
 	u32 signature;
@@ -1156,9 +1156,7 @@ static int ppl_load_distributed(struct ppl_log *log)
 		prev_pplhdr_offset = pplhdr_offset;
 		prev_pplhdr = pplhdr;
 
-		tmp = page;
-		page = page2;
-		page2 = tmp;
+		swap(page, page2);
 
 		/* calculate next potential ppl offset */
 		for (i = 0; i < le32_to_cpu(pplhdr->entries_count); i++)
-- 
2.30.2

