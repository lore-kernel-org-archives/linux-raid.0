Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A574C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 21:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiE3V4C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 17:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiE3V4A (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 17:56:00 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0007756439
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 14:55:59 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c19so18628142lfv.5
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 14:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=LTtdpZSnhYexp+NXY/ZErWR1WwpfDWZsniM3yKd8pdM=;
        b=Yk+/6Xrr7PgBpg2OMKht0Rqti++YmiijhLSLQVSqWO8B53QyuwG7xssvH6anfmN/Sl
         eYeheekc9hM/i+2T+6u1ri+uDiAb8YMF1VjxnHvC1Wt9d5w5JgnCM9SBIUmPh2UClgZJ
         X7Bw3RCv118cEEOuXI/a5ejSf2crsAVm3Y7L95SbZyzEbfN70ZChh+KdiMxEbKIvVp4f
         q3NeUyLrcE5oT8NR2zZUquSWzXbj57vyhjl38ll86QhScGVfti6+z0zUH313JBne/Z6o
         ragD7NFHC5CAToRTIUjyeNwg2JmBGl9Nowc8OfR8k3DLpqMrz8PzyuN6U4OSt70O3Iyd
         JV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LTtdpZSnhYexp+NXY/ZErWR1WwpfDWZsniM3yKd8pdM=;
        b=5Z4a/30W6pY/IWsw/Ag+9Ekr9DvODrdCwt2SNsUl637TCPZI8+KIPGCHxA6slrBhvg
         6jyElwduEi4ygb5sTZjSvsYoLEnlPYReqQOrObVPIQgilHQX6rddrzAIvHWGDYzU4dfO
         4QXYSPpcvWkNxsoJDlaF5F4WHfUqvmMUzP22adwF3Q+UT8OhMPWv5YS98qbJvt0heFbm
         wlyxW3OipLKglHr7Gf65gNoRkYdsyXiFuQrSdAthUTIi4wtYT2OZ7F3r+D4+/rFf68bE
         qxgaX8C4skM+ccIWYrER4LnNr5tzHI5K1ZfNHW5XablesOUvMRntfBV/8mry5+ozQDNT
         PaCQ==
X-Gm-Message-State: AOAM531aujCKektSKBSleo5YZXNAtfjFVtGZgEod3vZW9rDSw/8C760S
        IclNhk4HAm1q66Xt5m6yiDvTJFHR8RNLuZ42FiFxSISbkdw=
X-Google-Smtp-Source: ABdhPJx1eDibFbDiKYrg8QUaMl9RWhS1jigq2F8hUrQMEvFedv5layHXOpzZ1dbZLWOv35nLDRnnzP4VJxqz7ELbcls=
X-Received: by 2002:ac2:5f87:0:b0:478:545d:424d with SMTP id
 r7-20020ac25f87000000b00478545d424dmr36038448lfe.235.1653947758123; Mon, 30
 May 2022 14:55:58 -0700 (PDT)
MIME-Version: 1.0
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Mon, 30 May 2022 16:55:21 -0500
Message-ID: <CAPpdf5_QmoNvT+wsoy11S8cPCb2LepXNRHDAzcFGXTP9v9WWuw@mail.gmail.com>
Subject: raid array move
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings

I am investing in a new system.

The old system has a raid 10 array that I would like to put into the
new system.

The new system is going to add 2 M2 drives that I want to set up as raid 1
and this is for use for /EFI, /boot, /, /var, /usr and swap.
There are 2 2.5" SDDs that are going to be set up as raid 1 for /home.

The idea is to transfer the previously used drives from the old system
into the new system.

The question:
is it better to load the system and then add the hard drives

or

do I move the drives into the system and then install the system with
the drives at the same time.

(2 step process or 1 step process.)

(If further information is needed please advise.)

Regards

Aj
