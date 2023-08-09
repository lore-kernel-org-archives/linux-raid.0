Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A795AEB64DD
	for <linux-raid@archiver.kernel.org>; Wed,  9 Aug 2023 13:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjHINX1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Aug 2023 09:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjHINX0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Aug 2023 09:23:26 -0400
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01022F1
        for <linux-raid@vger.kernel.org>; Wed,  9 Aug 2023 06:23:25 -0700 (PDT)
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-56c4457c82eso4506424eaf.0
        for <linux-raid@vger.kernel.org>; Wed, 09 Aug 2023 06:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691587405; x=1692192205;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ejRL/AIVkJmSSvHsTVXbMbs+3cAK33dHTATA70GnFWM=;
        b=DGf9fLRI3ygtrWK6VxeAJYuGt8KBxv/JJYYzSXim5br7IuHMArZtPeYRBiwdoeG+q0
         DA13MjdwCXVYaIYoUmPMuZNEvwafrZZjw+wrMQo9vTc0Lswfr3qJoR42xgw2NBT54cbE
         y3zKDLPqhxZjI5apW5Zk5nrbnn1qYBQL6ygTUPWdAufImWacfOqsmITpKk/kUgVp3EjH
         5JK4Q38vJADyzAPmqI877v8hs4L8s7/WajFSNOVNu/detItyDJwU2QwwetOrc8If6ui7
         KVsmU3qgx94It/ZVz3Ld/7SwbmiRrlU8vWNZsS+rVkf6UgDCVAQNB8uJZyvwENFYsR9s
         CHVw==
X-Gm-Message-State: AOJu0Yxujy2A5DFSVpOwREme9ly4GNiWxB0coZtQkdvdYsq0MB9rx9CE
        TsSy3cGMc2dQXgnkM4BDp43V9xRmQQo1bg==
X-Google-Smtp-Source: AGHT+IFkK+gv1Ib/b0vx78TKSz7LftN9XJHB+q0QPFkW660wrFnz3fzfNMx4aTFkUTZYiBgK0xi9Aw==
X-Received: by 2002:a05:6808:10c:b0:3a7:624f:c212 with SMTP id b12-20020a056808010c00b003a7624fc212mr2358675oie.58.1691587405076;
        Wed, 09 Aug 2023 06:23:25 -0700 (PDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com. [209.85.216.47])
        by smtp.gmail.com with ESMTPSA id p23-20020a17090adf9700b00267b7c5d232sm1426936pjv.48.2023.08.09.06.23.24
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 06:23:24 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2685bcd046eso3582262a91.3
        for <linux-raid@vger.kernel.org>; Wed, 09 Aug 2023 06:23:24 -0700 (PDT)
X-Received: by 2002:a17:90a:6507:b0:268:3f2d:66e4 with SMTP id
 i7-20020a17090a650700b002683f2d66e4mr1819970pjj.37.1691587404697; Wed, 09 Aug
 2023 06:23:24 -0700 (PDT)
MIME-Version: 1.0
From:   Gilson Urbano Ferreira Dias <hello@gilsonurbano.com>
Date:   Wed, 9 Aug 2023 15:22:47 +0200
X-Gmail-Original-Message-ID: <CAAC0G-C-h_+c5n5egDEmTOz-OgNCN8-5-6fmbyksJfS3jp2yow@mail.gmail.com>
Message-ID: <CAAC0G-C-h_+c5n5egDEmTOz-OgNCN8-5-6fmbyksJfS3jp2yow@mail.gmail.com>
Subject: md mdcheck/checkarray degrading server
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We have an automatic check using checkarray being performed every
Sunday of the month at 12:57 pm, but it is degrading the server, e.g.
loadavg increases from ~5 to ~100 in minutes and makes the server
unusable.

From the Linux Raid mailing list and the internet, we found similar issues:

- Configure speed of checkarray in mdadm?
https://marc.info/?l=linux-raid&m=124138136430340&w=2
checking md device parity (forced resync) - is it necessary?
https://marc.info/?l=linux-raid&m=115744679317060&w=2
- Importance of checkarray:
https://serverfault.com/questions/199096/linux-software-raid-runs-checkarray-on-the-first-sunday-of-the-month-why
- mdcheck: slow system issues:
https://marc.info/?l=linux-raid&m=158557483523833&w=2
- MDADM CONSISTENCY CHECKS: https://wmbuck.net/blog/?p=825 (Similar issue)

And some suggested lowering the value in
'/sys/block/md127/md/sync_speed_max'. There is also some discussion
about disabling mdcheck/checkrarray https://serverfault.com/a/199125.

Given the information above, I would like to ask:
1 - What is the importance of mdcheck/checkarray in RAID 1 configuration?
2 - What are the risks of disabling this functionality?
3 - Does a decrease in sync_speed_max reduce performance degradation,
and how does this change affect the overall system?

Note: Debian-based OS
Note: Server is running on RAID 1.
Note: The same level of degradation seen in checkarray was seen using mdcheck.

Thanks for considering my questions,

Gilson Urbano
