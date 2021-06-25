Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3430C2B9F4
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 22:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE1B611CA
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 22:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFYWL6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYWL5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 18:11:57 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD67C061574
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 15:09:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id w127so12977591oig.12
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 15:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ras0nJa1GpjekdzrqgqRtjaGMO8+G2JnJOEUaeB32rw=;
        b=AZQz9e3bC8H/TyQ7RcpstMWF2DDMgDlhrM58w4KDXLSGDuS/koK0OxbaAHd2DRLC2S
         iQU0mT7VHXArUKqKeSSGMOngDuAzvJEVY9tjB5pAf4bdEEu13fcunMjuAsyckrTN/ELl
         Q84byYUsy0QLP+HV0inilnupKbyq6e1zpUUjhZxnsvi9LqKgsnck0qvRjRwmfhBtwn6f
         UXpk6Q963YU2wyhPm/q+MFgswfNzIYTkRRR8tdLZ4Vl0XQK2mZ8QIlC8PX9FsZmJpBje
         FOoHNuBWoDMUlFTm+8HEpqbSy+Eq/skKMSQcnPU+jbQ1VhVRv1UWjXJULZ8VB+c/qppm
         ZFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ras0nJa1GpjekdzrqgqRtjaGMO8+G2JnJOEUaeB32rw=;
        b=ZqHI1yrTE0+ig2WyZDdum4qCt08V2pwyojytrFj4wXENX+PU7VQSmD2MZNilPRQcQ5
         NotwUGSW5h6r1Zaqljyrqb11DP1YwaXr02yR8+AGkNpEAB+dh1sH+M0psAQPAwnAb5Ej
         L3btDuq4taRylWMi9wPF6s4AmKrOXTTjKVrvuM8uq+bE27pzM609JZB/VuHIzMgxZgty
         dNDtkT7HCx5ws7goKl985UcjRgVHkAfbH418TZ6UvhVDzBCK1hMWI70LG0SXo3MvmhEv
         rIrPbjNpR1ISeA8Q8hUoURzy5jyqLdtuOeE37fSQL1941QBik+93ivgyOv+akXHHlnQl
         BGow==
X-Gm-Message-State: AOAM533LYWwLdHIesChGd1AIZwvwPV7TcuQG/2461OB6JKntXB1Kdrz0
        5A72ihQgKJXTfsqSOJ6oTjG/3GFui0DBOw==
X-Google-Smtp-Source: ABdhPJwVZV1NzHJxj3U8nEcwmkF2KDOgE3oM9CRb3oTH690DzsPkS6/p1RyKWmV8V2boQXlYyXNMRQ==
X-Received: by 2002:aca:4141:: with SMTP id o62mr12994388oia.42.1624658974838;
        Fri, 25 Jun 2021 15:09:34 -0700 (PDT)
Received: from [192.168.3.32] ([47.189.16.5])
        by smtp.googlemail.com with ESMTPSA id o20sm1539301ook.40.2021.06.25.15.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 15:09:34 -0700 (PDT)
Subject: Re: Question: RAID cabinet for home use
To:     Mark Wagner <carnildo@gmail.com>, John Stoffel <john@stoffel.org>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        antlists <antlists@youngman.org.uk>,
        Bill Hudacek <bill.hudacek@gmail.com>,
        mdraid <linux-raid@vger.kernel.org>
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
 <24787.28117.662584.586506@quad.stoffel.home>
 <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
 <CAAMCDedHYKqBDfTysU=-CtxRMVpftPK1+crewRM2yuTDDq653A@mail.gmail.com>
 <CAAMCDee-1J2DVQWPyqe-rZ-E=Ers3Msvdn8+KpFnRxeyQafXWg@mail.gmail.com>
 <24788.46596.805675.840409@quad.stoffel.home>
 <CAA04aRQErD-cG5KThbtHSCX9LvPJLQzdZ+Y+wK_Gv12JAPhkQg@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <e2a6a38b-e4d2-ce13-424c-a25bb5f99e3d@gmail.com>
Date:   Fri, 25 Jun 2021 17:09:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAA04aRQErD-cG5KThbtHSCX9LvPJLQzdZ+Y+wK_Gv12JAPhkQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/25/21 3:04 PM, Mark Wagner wrote:
> On Thu, Jun 24, 2021 at 9:43 AM John Stoffel <john@stoffel.org> wrote:
>>>>>>> "Roger" == Roger Heflin <rogerheflin@gmail.com> writes:
>> Roger> resending without html.  Lovely that you seem to have to disable html
>> Roger> on each reply.
>>
>> Roger>  I found an $80 rackmount case that has 2 sets of 3x5.25" bays and
>> Roger> would take 2 of the  4 into 3 3.5" hot swap bays (icy dock or athena
>> Roger> like devices).
>> Roger> https://www.newegg.com/black-istarusa-d-416/p/N82E16811165215
>>
>> This looks like an interesting case, lots and lots of drive bays...
>>
>> https://www.newegg.com/rosewill-rsv-l4500u-black/p/N82E16811147328?quicklink=true
>>
>> and it looks like it even has USB3 on the front.
> Looks like a USB3 update of the case I'm using.  It's basically a
> 9x5.25"-bay case with three 3x5.25" -> 5x3.5" adapters.  The adapters
> it comes with aren't hotswap capable, but it's easy to pull them out
> and replace them with ones that are.
>
Can we make it a desktop case? I mean, remove the dog ear extension for 
rack mounting?
BTW, there is also a hot swap bay version, but only has 12 bays.

https://www.newegg.com/rosewill-rsv-l4412u-black/p/11-147-330

Ramesh

Ramesh
