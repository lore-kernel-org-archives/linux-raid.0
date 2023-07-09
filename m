Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B783CEB64DC
	for <linux-raid@archiver.kernel.org>; Sun,  9 Jul 2023 10:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjGIKaI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Jul 2023 06:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjGIKaH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Jul 2023 06:30:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A66F4
        for <linux-raid@vger.kernel.org>; Sun,  9 Jul 2023 03:30:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b8ad8383faso25592395ad.0
        for <linux-raid@vger.kernel.org>; Sun, 09 Jul 2023 03:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688898604; x=1691490604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EYBcAwEj7igEpTtAnhLF8RYOAyJ4EXppRkByVjvQ1Zc=;
        b=HiXegT72DR1gfZUJGVqj7A13s9R8ezlsfnxSY5CmKQSlcXopytbzhlYSZ7VbIuoYY3
         duX18S+YKCfGji4NjM1b/r40tLNpNl1t0rjkN70SdLx2W63O2PpL1JF97VWzd82qV2US
         dK87FfUgGaCI9okQvi7jniJXxElctzd9/8QknO6tUburYpq8o12NESQgELEbOlFK01Br
         UarJeS8KIoBDjQM+9LF6kGMris/+nwL+f0A7EE5V4967eX9LlOyjaZnaj+8RfPSECZwg
         62dxnn99s9mftidxqIe3Q6ODO/97tbtLvSq+cmxaXo2FCWXJ64042xZeGwIqwzHlYAJp
         oiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688898604; x=1691490604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EYBcAwEj7igEpTtAnhLF8RYOAyJ4EXppRkByVjvQ1Zc=;
        b=ETToTH/ju2w5FgNwEQSc5F8LDuzpUl4Z4gb+2sn1T3I0wY/qjQ6iwt585SgIY+Rg4P
         Pdu1wTysQTkQRB7kdtyFxJxah5s8f1Zr9YosFsn/O3Iekknjxngqu2fwCBj/v3shorrf
         6pCTdGf/1sAf5AirNT/AF/LfhqeQojnSiXctzXVjLZ98v3QwBBF757D7TCiOGj/KDGVy
         YBpAN45xTHPF3l8uEDhAh1l4K7w3l8+Gg3VspAzvjDrlfRQHXGZvSCpLw4MkrjKQh9mQ
         RgZ0MHYmVDVvI84KnltfmzD7PlRmILQU2LVBZhIRD9ukKyqSS0jVfpaXOUe3hBvKERhT
         IGxw==
X-Gm-Message-State: ABy/qLYmid8MJ/rvGZEIl/1swILmIYDGXwQo5owzezD501lSV3SMl7V4
        eF55Ck0jWzsQ96i2Bwz0bJZcng==
X-Google-Smtp-Source: APBJJlFv3XIptUN3LmIwP69GusJtKZlekr8ku0h3rVfR4qp3UkRIDad4HA29O3mZsjPLIefIzRa30w==
X-Received: by 2002:a17:903:2584:b0:1b8:5fb4:1c82 with SMTP id jb4-20020a170903258400b001b85fb41c82mr9761964plb.50.1688898603899;
        Sun, 09 Jul 2023 03:30:03 -0700 (PDT)
Received: from localhost.localdomain ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170902eb5300b001b9be2e2b3esm4479140pli.277.2023.07.09.03.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 03:30:03 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
X-Google-Original-From: Xueshi Hu <hubachelar@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v2 0/3] md/raid1: don't change mempool if in-flight r1bio exists
Date:   Sun,  9 Jul 2023 18:29:53 +0800
Message-Id: <20230709102956.1716708-1-hubachelar@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Xueshi Hu <xueshi.hu@smartx.com>

All the r1bio should be freed before raid1_reshape() changes the
mempool. However, freeze_array() doesn't guarantee there's no r1bio,
as some r1bio maybe queued. Also, in raid1_write_request() and
handle_read_error(), kernel shall not allow_barrier() before the r1bio is
properly handled.

Changes in v2:
	- fix the problem one by one instead of calling
	blk_mq_freeze_queue() as suggested by Yu Kuai

Xueshi Hu (3):
  md/raid1: gave up reshape in case there's queued io
  md/raid1: free old r1bio before retry write
  md/raid1: keep holding the barrier in handle_read_error()

 drivers/md/raid1.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

-- 
2.40.1

