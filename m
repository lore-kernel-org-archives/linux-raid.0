Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BABBC00140
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 10:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiHEKGi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiHEKGh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 06:06:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9147B6715E
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 03:06:36 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id o22so2720936edc.10
        for <linux-raid@vger.kernel.org>; Fri, 05 Aug 2022 03:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=2Nvxo5qXuobDV2MK+2hopUCdKoWqYOZODw81A6GIbaA=;
        b=ccgyWBtWHMHpG2rhFmraPuRS+Ngv2nYFsKypIjwIYjxQgi9ThpefgPo8+hJiwU0HfB
         zCZ2EOxuVlrcMQnCntuAXS+uSogGuSx5xlbJ/VODd+Z1gWqPkMdnFOXgnziapmSKTNNd
         GZ/pArvxy3hQGRBjIe9PLP6e0R3NyDyY9pzl+3kAJFvlBEPrdoB4U8uiW/HsW3Hz69XZ
         mJR6Vuo1vnXZd5q7SRFBNt3e1clwghk3Mc6UYx8ewBaNfFTzVF4yA0ARx8SrNB1B2jir
         19T/Buj1qcnXIPFi9zmWVi6As0jy/tpBFVciIhbBHkl1ewhPp2ItMFkpduWy65UUIWDi
         /r1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=2Nvxo5qXuobDV2MK+2hopUCdKoWqYOZODw81A6GIbaA=;
        b=RB9QQlu0sv+7bMLU6JrfVeo9VuqQM6iukOiFFR65/Pbr85NOgCKfQSmBnf7F+Ff+5B
         8uFrb50qlj5v5W8nFILgZ/ZhfFNVO/WVp4BcqwJlsvlY6uwtcaQ1feND5gcTuwtvX9ZY
         8KBv9j9E8BXS2dSdbdTYKn106VTfZ47cdKhsf9QExVVOc/Z048o5rH7ERatRfeGGJ8n7
         JEGtO+UCFMllJgBZh+cjSbEJ1e4OEZ6hAa7QgnyLIxvIRGwohO/ccwLCsTAzm5dh07OL
         RS48x61q1KKk6xpv85Aezk5szohdqNskHkZhypN4/3bp82k7Dsc2y+D3PgPHzazY5LBa
         vFVQ==
X-Gm-Message-State: ACgBeo2Iy4vqVz3O1PjjmyI9Coq4tbr4R4lz0F2gSi+QhMsVxQM+HxpC
        ifpqec+28vj9Jd+jNLd3WmKoIjV5Leg=
X-Google-Smtp-Source: AA6agR71L2rwv4D733ED6S8c6G5ruujdYfk1zA45Vy9etl7RmDrcT7UK9pIzvFVcjx74Vy/wrFEmyQ==
X-Received: by 2002:a05:6402:2741:b0:434:fe8a:1f96 with SMTP id z1-20020a056402274100b00434fe8a1f96mr6033430edd.331.1659693994638;
        Fri, 05 Aug 2022 03:06:34 -0700 (PDT)
Received: from localhost-live.home.oldium.net (smtp.home.oldium.net. [77.48.26.242])
        by smtp.gmail.com with ESMTPSA id ca11-20020a170906a3cb00b007308812ce89sm1369206ejb.168.2022.08.05.03.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 03:06:34 -0700 (PDT)
From:   =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Subject: [PATCH 0/1] enable Intel Alderlake RST VMD configuration
Date:   Fri,  5 Aug 2022 12:05:44 +0200
Message-Id: <20220805100545.9369-1-oldium.pro@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I was testing RAID 0 on my Dell Precision 3570 with Intel i7-1255U
Alderlake processor. The mdadm tool did not work initially (the
RAID was not recognised), but I was able to get the RAID working when
I simply set IMSM_NO_PLATFORM=1. Then I tracked the issue down to UEFI
variables and discovered that the platform newly uses the 'RstVmdV'
name. This exactly same variable was used in recent patch series called
"mdadm-CI for-jes/20220728", so I updated the code to recognise the new
variable name also for VMD controller case. I then verified the change
by first running it in a debugger and then by putting it to initrd on
Fedora 36 (kernel 5.17). The startup was fine, the RAID 0 was correctly
setup.

I based my work on top of "mdadm-CI for-jes/20220728" patch series,
it is required in order to apply the patch.

Regards,
Oldrich.

Oldřich Jedlička (1):
  mdadm: enable Intel Alderlake RST VMD configuration

 platform-intel.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
2.37.1

