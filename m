Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B7AEB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 07:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjGSHKL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjGSHKF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 03:10:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22408A4
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:03 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3463de183b0so37776355ab.2
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689750602; x=1690355402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cz5JRgN+VfrEH3wYRTcWLfx4Kr4jBeCAC9PM0jXb9sM=;
        b=wz3m6T7JMIIvw5SXtfc0HpljRHlQmrrJJ0cnBFMSVk5PL6b48zxtVfiDCZWq0REPJj
         mLnjPgxShwoa+tCOIn8f8zZPT9et2tMPjbuPhakmHELJ49rFIxbqaUjH42Tp8WrFkS1J
         3XigJLWts/tUlabGaqRZWaWG7F/A2x+P75FGD19/VP2RP++VMnDWJoMBFxpeV0HjX7TW
         avMOWUXJqTirv+yRTjf7reGBCDB0t0rfEA3if8nOMUtjPd4pi6j4biTuusVlvVp5TUaf
         B2USWWT1GIaROLIZw3O/JHx4JTRi0YgfYZe9c3SpuW8paWeveAW7RUDheFadA2h24Lw/
         wqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689750602; x=1690355402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cz5JRgN+VfrEH3wYRTcWLfx4Kr4jBeCAC9PM0jXb9sM=;
        b=IAcehuXyogCU+FArasAzcbOIwzL9TdVC3G0d/KtcF5dHB9w3hwglmxMqd+VlGpWG4w
         BbGx0RL6pH5B1mzOmOa/c6xPRHEUq0i5nuLE8AeLkZyW4SAP1K3mVosAaAXs1W5C+elC
         OxpACTTIdPcj/q7+J8pDr4ml7yWFOC7DlAAOu5ilcdkE0w+LlZHZWfCdqDLvJwM9uP0P
         fre9n6oono+Xjp2B7vGs8f4mLXfBvzA2LZuJ0hkC/osuiZUYXMIDlT+0N1zZVh2EqFVS
         N/6DnSGbHf5Opo5cS9UBpom34NT4GYKkt306fXZ77Fy7uT3gNQQASvSQU6CH/dPDXlGW
         2Y9g==
X-Gm-Message-State: ABy/qLZLaHlST4irHCvgK7+2v9Rm5FHJlycvz0I9nUupQpfne586HC/g
        L4gujzYdiyI1KCNZ3O/wacHeb876KJ73RvdHow71IAjURkc=
X-Google-Smtp-Source: APBJJlEXwozvFnJWW4gfXlPMwaekjsvGVVBERIv6eabEYQBtFeo7xhTjCsd1lYD3yHSAYn+rHceIww==
X-Received: by 2002:a05:6e02:b26:b0:345:dcc1:a1c4 with SMTP id e6-20020a056e020b2600b00345dcc1a1c4mr5660609ilu.4.1689750602413;
        Wed, 19 Jul 2023 00:10:02 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id 11-20020a17090a194b00b002639c4f81cesm667453pjh.3.2023.07.19.00.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:10:02 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
        Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v3 0/3] don't change mempool if in-flight r1bio exists
Date:   Wed, 19 Jul 2023 15:09:51 +0800
Message-Id: <20230719070954.3084379-1-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All the r1bio should be freed before raid1_reshape() changes the
mempool. However, freeze_array() doesn't guarantee there's no r1bio,
as some r1bio maybe queued. Also, in raid1_write_request(), 
handle_read_error() and raid_end_bio_io() , kernel shall not 
allow_barrier() before the r1bio is properly handled.

-> v2:
	- fix the problem one by one instead of calling
	blk_mq_freeze_queue() as suggested by Yu Kuai
-> v3:
	- add freeze_array_totally() to replace freeze_array() instead
	  of gave up in raid1_reshape()
	- add a missed fix in raid_end_bio_io()
	- add a small check at the start of raid1_reshape()


Xueshi Hu (3):
  md/raid1: freeze array more strictly when reshape
  md/raid1: don't allow_barrier() before r1bio got freed
  md/raid1: check array size before reshape

 drivers/md/raid1.c | 59 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 11 deletions(-)

-- 
2.40.1

