Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C3BC433FE
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 17:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbhLIRE6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241886AbhLIREx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 12:04:53 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B16C061D7E
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 09:01:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n26so5989397pff.3
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 09:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=Ud3lKXQYKGOuzl+KkRdHcKl/sXgpbsziWKn26STUYzg=;
        b=c3npZUsjDLfM1VYqRItcNvvTHz3xeZ8zRQ59gFrvN+6dtEXOwCPRuAuYPZohbDMUgd
         RV0si7L/Oi0aMvmnzELYdRVm+a8ga7sHiG5wmfHQ/24rQ3p4K0VS0Vxq9zfJ4LFlZUPr
         WLjCk/pjEyOIss/x9PZ8Ikou5mRGqN3zjIA00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ud3lKXQYKGOuzl+KkRdHcKl/sXgpbsziWKn26STUYzg=;
        b=t1beg4jhAqnPvAaVXKelbVTBS9ATdfD2Cwh/6QpygwLFrAeKa4fqmiEUqqb1cEJPD5
         yvfAwP6B9OpUGm3VM6FdyRLFo/JzvJmUbJIga8A8QGlZxsU2/SiJSEDTw0h54HD6NvIJ
         TndspPDSWIsmfd8OJY4i4EzWo2BxXzsH8iTjkqUDiIODyDGbJogQr732tg/JGvWubDOu
         +QgJL8UXI7fMax+fevRr5qcCSuM2lvRdH90bTKNsMzgMM1tKGHBMNGp7XDXw+eo599HN
         p+m9OnixAliP5iSG5wwkVUJGoLBPF5zqPieSLu+WyaytyUh4xKFrKv/AvNaGZwDFSceg
         H4Ug==
X-Gm-Message-State: AOAM533DmCC3WCCwj39XaZaC/5vljFTGknb1vh6lOCQfnrtpAmicUnTi
        zdF15qUC6p7KWuYyAv+yF0ucnw/j76HaFQ==
X-Google-Smtp-Source: ABdhPJzDuOmsGtRjkhCkZ1huSj/3A+OMnfQVIBbp/tQDXmcczCfWmHpj/MnaX82QGaiO4dFz9BiH4g==
X-Received: by 2002:a63:703:: with SMTP id 3mr18091251pgh.128.1639069276724;
        Thu, 09 Dec 2021 09:01:16 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id i2sm259678pfg.90.2021.12.09.09.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:01:16 -0800 (PST)
Message-ID: <565a8e4b-7817-53e4-dcd3-b2320afbaecd@digitalocean.com>
Date:   Thu, 9 Dec 2021 10:01:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW7=r4AmCqG3M0hU=fps6a-Zu9KF_RnyNf815d=43wTv5A@mail.gmail.com>
 <f8c2a2bc-a885-8254-2b39-fc0c969ac70d@digitalocean.com>
 <CAPhsuW54EJOfAXrE-zVie561n+aF-+jvQz1152rqj=kU5Fk5ug@mail.gmail.com>
 <9fb2e648-9a6e-c4c0-4fe9-3e2a92ecd8d6@digitalocean.com>
 <CAPhsuW5cfy1+9YOT2620KycBN0juQN1ZKUewygqxK21BqQAyxg@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW5cfy1+9YOT2620KycBN0juQN1ZKUewygqxK21BqQAyxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/9/21 9:59 AM, Song Liu wrote:
> On Thu, Dec 9, 2021 at 8:53 AM Vishal Verma <vverma@digitalocean.com> wrote:
> [...]
>>> Song
>>>
>>> Hi Song,
>>> Did you get chance to look into this? It looks like I am bit stuck here. The other option I am thinking is if we just add a flag for enabling nowait and enable it by default for raid1?
>>>
> I am sorry for the delay. I will look into this and get back to you
> early next week (or sooner).
>
> Song
>
>
> Np, thanks!
