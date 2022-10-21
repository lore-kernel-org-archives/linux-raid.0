Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E55C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 16:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJUQCJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 12:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJUQCC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 12:02:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72D26550D
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 09:01:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a3so5743946wrt.0
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 09:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mx9qH7Rc6WzeuhvmewDopyzBiPpSRi8S+hJSdo5Hpkk=;
        b=hRdvQAGQVp9O+PXJE7EicWSqkYo7QlWC09r0s2K2MWrIv1z92qcaFksfS2vO5B97ij
         UoacnpEEOBBfdAFaHdQ5vAXGP/vQvLmBh6zQdDbB4dB+9AMTft/uzxoeXLikTx66JLvI
         LCgVf+0DHqmNiK5GwULcilLewfPRIN2q81wNsavf0tE+GayGCu/llsXRanvw+q5Hvwl9
         9qg2bo5Vto8zXVCVA+3PIRZboKjfXusmo3QKJ6Hcx8E/FHGQjmEKVGxRSpNBn0bKPnXe
         sTfUgskUp6daKd0k0xJhZdM0iMR3pnn9oo6PGJDXVUy+NG31pc9mMk5KsKQL0IbT49yt
         qWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mx9qH7Rc6WzeuhvmewDopyzBiPpSRi8S+hJSdo5Hpkk=;
        b=yxTOMJqtgpWqirx5V3F39jKgK4eXX0OpMhEQVWUimaWBVskLYrL9BI5XFo3RdkmK+B
         zbLWE0b8+Q0aYc43+cM1qcACw5d7OicBjw9JZjuq3GaaIQbX2AnFp7HW2agn7p+rrstk
         d1rKxmM9buASolQJOPNW1S1SL6JC5de/vMwF0q/JHAxjVOt5xldtAKsbI+VHAeFOrW3t
         3VPiDC9kfFDI783GvlBLv7ABtYff5HSx2M0PZcqjOv7yJIP7CE2LLnYuy4Me4qU/VncG
         fpmanXQ8kqG76e34e7yywX0FKUUh6gIH6j/k82wDDz851YF8C4EIqH0z1d150unoXgul
         eR2w==
X-Gm-Message-State: ACrzQf2enZP/AEGkvBPv1m9mplCe47KHlCu4GxEr027pVYcrMNced9RS
        rRaV9MmW6jbieaY+z9QzY8QkqWVJ9/nrV6r7DG5KkF4B
X-Google-Smtp-Source: AMsMyM7GwD0/bhfkdAtkell9JOzLAG6JDjVTs7uqmOK1K91T2mCEmCKqT7TozeedhC3VItmNIZjWoafFabywj7b9uYs=
X-Received: by 2002:a5d:47c5:0:b0:22e:655e:f258 with SMTP id
 o5-20020a5d47c5000000b0022e655ef258mr12159943wrc.569.1666368113338; Fri, 21
 Oct 2022 09:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net> <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
 <20221021001405.2uapizqtsj3wxptb@bitfolk.com> <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
 <20221021105107.nhihftkjck74jg6i@bitfolk.com> <CAAMCDec5k2AvTik6SA_3c48pfH+VxAi9cRb4Qj-xpcAAcOpp0g@mail.gmail.com>
 <20221021152433.jeylw7ynkn4iczyj@bitfolk.com>
In-Reply-To: <20221021152433.jeylw7ynkn4iczyj@bitfolk.com>
From:   Umang Agarwalla <umangagarwalla111@gmail.com>
Date:   Fri, 21 Oct 2022 21:31:18 +0530
Message-ID: <CAEQ-dADD=F0-ivtYr1zpahCkXhNJWmv+sxxvX_Seag791MTQkg@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     linux-raid@vger.kernel.org
Cc:     Roger Heflin <rogerheflin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Andy,Roger,Pascal,All

Thanks a lot for your suggestions, yes indeed they are 8 actual HDDs
in a Dell Server made into a near=2 layout Raid10 array.

I will try out all the options you mentioned. My major concern was how
to benchmark this over a longer period of time.
I am not very much into performance testing, and hence wanted to have
some resources to understand how to benchmark this correctly with good
data points to present a case to the application owners.
So will continuous capture of sar and iostat be fine enough to give us
detailed data around it?
I would try out both the ways which you all suggested, manually mark a
drive failed to make it go into a degraded state.
I will also read more on dm-dust

Thanks,
Umang


On Fri, Oct 21, 2022 at 8:59 PM Andy Smith <andy@strugglers.net> wrote:
>
> Hello,
>
> On Fri, Oct 21, 2022 at 06:51:41AM -0500, Roger Heflin wrote:
> > The original poster needs to get sar or iostat stat to see what the
> > actual io rates are, but if they don't understand what the spinning
> > disk array can do fully redundant and with a disk failed it is not
> > unlikely that the IO load is higher than a can be sustained with a
> > single disk failed.
>
> Though OP is using RAID-10 not RAID-1, and with more than 2 devices
> IIRC. OP wants to check the performance and I agree they should do
> that for both the normal case and the degraded case, but what are we
> expecting *in theory*? For RAID-10 on 4 devices we wouldn't expect
> much performance hit would we? Since a read is striped across 2
> devices and there's a mirror of each so it'll read from the good
> half of the mirror for each read IO.
>
> --
> https://bitfolk.com/ -- No-nonsense VPS hosting
