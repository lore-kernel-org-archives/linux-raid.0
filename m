Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D854FC433ED
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 03:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDB7613DD
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 03:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEGDHC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 23:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhEGDHC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 23:07:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8596C061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 20:06:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g14so8454637edy.6
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 20:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+CVPUQdnkSzHHXCgIfB369vdW/w4Ee52WCi6TukX/Zw=;
        b=bcKv/jUWJwuCp0cC90N3CnO494+7jJZPwwC68ufo70euWQwE5rrtKC9vThd0DmCbPZ
         YjDX2QA75FEYW81pCgrowaMBBRAHTV9sSBtxO9bPgkc+xAZCEcVkJIxoK7vCl50sx+0u
         Of1jwdqynZZHJfyioVTk5RYNEIYGgERJf6iSXoySplAIPy6b7y1IpLfV9+d094pJ/VXz
         wypZI3ZSgOWfvuppjOMsfmGl8O5YOJuwSnWI6XlzfkJldjUVQ9TvliOky1kN88nZSM/b
         i1Ka/HKIGATqfH8UZXmgE1fq0H/RbpVvxBipyvKaptlrmiiMuK045rR7Rgm1zEuL4Yjg
         vSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+CVPUQdnkSzHHXCgIfB369vdW/w4Ee52WCi6TukX/Zw=;
        b=KG97HiH6RbGrqC7JULcG6TKoXztN1Y5VqG7Mv+wN8AleQYBRr3fUBCJ2U5qELaB8zZ
         U2eB0Sv9lR9nlPVGqIR4p5fKZ26bQIlGLqN0p0AQmBN4mNmFYXbDPy286bbltnoAKKBU
         uS97mPqeGACgop2xHEMhgEY+wgGv+oFlUlUeKs2L9SByKk1wq4OTkBC3/9LSjTQEVOFS
         K+H5N4CHCUh4ZOua1mKrwqF063vN2uEhhsDs+8uP1XI7+fTlA07dS/Zh7Uoy9krEbOEe
         GBF8+eCe/CVjU8ieWDgMxTLkMN07O0Dg4KeSNbRVhdPGwbFVAZ819IlVMOE9ZIo+Qgzm
         7pow==
X-Gm-Message-State: AOAM5332BKgQmAV8Jqf+s8ZxtFn6qbpDWpB28LCLZLC6tkoTRTIyiuuT
        2fH8oVOfVcyfyS4JyXtLJ/n25zcImX0XbHUFHLZegCnw3ylTViAf
X-Google-Smtp-Source: ABdhPJwbhUJy4YPCoOpLvrrKKyIsICIOSryiQuaP5j7t+75YZYmYbiGstqixTwYq3O6w0XgainU7Ebq+HHKf1uaWC50=
X-Received: by 2002:a05:6402:105a:: with SMTP id e26mr8770897edu.164.1620356760304;
 Thu, 06 May 2021 20:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net> <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
 <86A76859-3098-4AB8-9AE7-46FF54736B88@websitemanagers.com.au>
In-Reply-To: <86A76859-3098-4AB8-9AE7-46FF54736B88@websitemanagers.com.au>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 11:05:50 +0800
Message-ID: <CAC6SzH+YG7w6g7=JtRBdAmYNbCgg4AsN9BW6cPGA=Gs2Jwazdg@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc:     Phillip Susi <phill@thesusis.net>, Xiao Ni <xni@redhat.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Adam Goryachev <mailinglists@websitemanagers.com.au>
>
> Sounds like you want raid 6, you can lose any two drives....
> Regards
> Adam

I was using some ssd raid6. the performance and write amplification
are not so good.
Maybe it needs more tuning. but this time I want to try ssd raid10
since there will be no more four ssd disks.
