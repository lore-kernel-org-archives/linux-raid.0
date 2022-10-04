Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27252C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  4 Oct 2022 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJDJsc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Oct 2022 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJDJsN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Oct 2022 05:48:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40FA1C0
        for <linux-raid@vger.kernel.org>; Tue,  4 Oct 2022 02:45:48 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a26so27658777ejc.4
        for <linux-raid@vger.kernel.org>; Tue, 04 Oct 2022 02:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pZYPVUL/QSpSgeRCqfSco3hgUPige10agfu312NmJpU=;
        b=gsX0Fg7WWHQkD7Nk+24KkVFT8RpEct+Mfefdc+0pgyH56Qit8YnvtvnSJudj00JNqN
         nW3r+4kmn7azcFrUiurDUJL7ZPbWeqctmDs6LywDLemMhQVOXByPqYBHouX+xS5al4yE
         YOIZngS5dxWch0NwC82lp/zDlTZeZXkp0Jo2kM2sNvJWANmD/TQxOIgw6haGXsVwbXbN
         9fcKRFuQfsuUQ4dMBfVAmlbqxeNkpm7zcgIalSKoHR4V//hvjl6oX5OVT9tOi+eG1S+S
         /SOeXGTeBM4wOL1IRAh5+ot3mm4SeHfDpBELKjhDK41ZOTaM3xilZ27Fp80UVWUACK/3
         MlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZYPVUL/QSpSgeRCqfSco3hgUPige10agfu312NmJpU=;
        b=wP9gD+mfYITw5Ys0418yOqot+EbAmu0iyK6+OoTKr7Y1a7Coh00Xt39GegEwru6tmF
         MDn9I0FFgWHpbOE7g9L6SOZLpFmDmkABsD6fgYzKe1iAtpTqUtpAIr+5DktJ6De2sGaO
         Jw4OlYQP3iTFhDSp33iSsMDVA0/PRbYEv9uv2rPjO6E+GavmXIRaMmpc9AjpSjSjNmPm
         s8PJbTGrRGYBS7GdGWKMa3O4XNUjzCW3YJYiGxmv/PKVtGjkuGgyDIKEtJtxJG0aLv9R
         D5+IjEjs5RSZIu0T5lPnDTwNAQqzXt0tK/qU2lvC0JhB9t/1IcLhbHA+QNk3bVXq8Dk3
         kaug==
X-Gm-Message-State: ACrzQf0YsND+K+myEAHWwXyygK17nocfAr7V2McqIIrnBRrub75lUth1
        XoKu+oc4kZl/DkIwswr5VtUFfXpVFJGoWQ==
X-Google-Smtp-Source: AMsMyM4OeVOsM/KULdxyIu3jNN3nyYS1aGJm7QHUK4ptaYb1vbG7c5/afEtvU+oUK1OBQwP+QHwDJQ==
X-Received: by 2002:a17:906:8144:b0:78a:ef70:2171 with SMTP id z4-20020a170906814400b0078aef702171mr7678730ejw.95.1664876711687;
        Tue, 04 Oct 2022 02:45:11 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:1428:3700:4f35:4902:fc79:8669])
        by smtp.gmail.com with ESMTPSA id d2-20020a50ea82000000b00457cdb5cf76sm1347928edo.50.2022.10.04.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 02:45:10 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, stable@vger.kernel.org
Subject: [PATCH] md/bitmap: Avoid chunksize overflow
Date:   Tue,  4 Oct 2022 11:45:09 +0200
Message-Id: <20221004094509.44171-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When grow an array with bitmap to 4 TiB, the bitmap chunksize
will be
head /sys/block/md0/md/bitmap/chunksize <==
18446744071562067968

with 8 Tib, the chunksize is 4, which lead to assemble failure.
The root cause is due to left shift count >= width of type and overflow.

The fix is simple, do a type cast before shift, the bug is pretty old
since kernel 4.0 at least.

Cc: stable@vger.kernel.org
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..b4d7a606a9d8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2150,7 +2150,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
-- 
2.34.1

