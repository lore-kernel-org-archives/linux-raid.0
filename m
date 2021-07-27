Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1141DC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 21:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A8860F6E
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 21:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhG0Vwd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbhG0Vwd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jul 2021 17:52:33 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC82C061757
        for <linux-raid@vger.kernel.org>; Tue, 27 Jul 2021 14:52:31 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so341433wmq.2
        for <linux-raid@vger.kernel.org>; Tue, 27 Jul 2021 14:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s7gWrnL2PFCFx4qTba1oMpusxJ1Th9xTdHl6/niPx5s=;
        b=LRbCNmrOFv+HazPtU0tL8nlDSNAywyeKj9s0ZScx6jQ5SCxwlHzW4p9M/8Zg9bolJT
         8bzV0IQG0yATTb7gk3AAGPj/98lfZfgAXJQhrDYRdrljdSVMOqY2/EOeNhW5InivotYO
         gJYv3cNdL83i0iJcKNcmBeohBcK2GIv+i4z8JglAu0LEF4xB7JOjW7GDbEMiMNss/xCo
         UEjABfew7hAo8HQCzSIZZqoJHzlsIjr113TIDujTas/RSPD0yPCh1idZjDCAIGcYRbhz
         5j7DLmHyGTqDAoAx3IVxWs9g8a6beI7DitrMxMwZfdOAogGqKHnW0jHR5z3zU5DWHUGU
         iMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s7gWrnL2PFCFx4qTba1oMpusxJ1Th9xTdHl6/niPx5s=;
        b=DO3z3HP95DmD38uoNJSR7hDCXZJEEwollSeWuPSbVrAOFtyqxdxUzFsHL2n+QwRZ5m
         E1QELPtdVmk0n1MhMXhi6vx80EUOGR0F+OXbaPbChCskO+tLv5aQ/fKblAETaN1DaNJh
         PwWWaI+MEL7ayVVKYtTyfF8rQSd00H103gotWilEC+O0XwHnsSRTcwAKC7k63+MJkcug
         qj4eQzh5qXLeioIuyNcPWacqwhI9BFmeek1pOUboyNdvzzvNMd2mpQSL0GTjfxZhx+jM
         j2RFTNBli2h0Xc/JLsGkn7fqDWp9dfT8bl1xeyp5HKCBgChU9UslYZurxX/HjZM6W+hC
         xqtQ==
X-Gm-Message-State: AOAM533GWuKrLf2vLVwTIBZUgn27ylYAaotlzn4BA0LD6lCs4tQCfqtT
        G7KBDfuQPedtR+YEyQkvdlJmX0sdMR+W6GMM2KqIDcwhjhTZ/xoI
X-Google-Smtp-Source: ABdhPJw5h+n+OJcUGo7anJMYbo+6NYNveeQUD2ysSqgpDLcZCEdG5HUW+w4qGXTcIdYzRhRi5BKjjpgehhWgjkf7pDA=
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr21515463wmr.168.1627422750234;
 Tue, 27 Jul 2021 14:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 27 Jul 2021 15:52:14 -0600
Message-ID: <CAJCQCtSYAd+Kd7XUvY1pMADc5KanY6VdDnRVe1vOSfC6SAR_QQ@mail.gmail.com>
Subject: Re: Can't get RAID5/RAID6 NVMe randomread IOPS - AMD ROME what am I missing?????
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 27, 2021 at 2:40 PM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:
>
> [root@<server> <server>]# cat /etc/redhat-release
> Red Hat Enterprise Linux release 8.4 (Ootpa)
> [root@<server> <server>]# uname -r
> 4.18.0-305.el8.x86_64

I think you'll get a better response by opening a support ticket with
your distro. That's a distro kernel and upstream's have pretty much
let that kernel version set sail a long time ago, and are mainly
concerned with linux-next, mainline, and stable kernels. You could
retest with kernel-ml from elrepo.org, 5.13.5 is up there for a couple
days.


-- 
Chris Murphy
