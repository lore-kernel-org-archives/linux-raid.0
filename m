Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B749BC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 22:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbiCHWcm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 17:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbiCHWcm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 17:32:42 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4655A091
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 14:31:45 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id u29so435484qtc.6
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 14:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xn4JVNJ9XJSEASkNzP9jMQe9Wm2OoN/zXpBrpdejF78=;
        b=Iq36GlN62w6w8a9u/tVHTFY8xQD2VKnBn0rwZvEO8P2/VkqJLKxwM1pjVky07wvUTm
         7HVXSQvYKwm8w/FGjpMzVBfpxH+ffXiBnWXf9VtLQbSLfjmhC4nqrICHSle1bIa2+jqi
         2OussmRFu6yJLlTatIAqpeqCRLYTujAZr7GRTLFfFa7SFFSPfsYlW/L7cXoUC1Vjh6dX
         ksHlcaaroqNs4Rc68/0tHFWYr7uPe6IF62AxyOj3nI0mwyNY+tzIq5Fhx59Kq+Gp29Iv
         NStn0kYTc5lcCSLsNYceBOSlLe9tmt6yjrNKW/dFYx8tR/tkkS7WazQmohpNzoTLlo3x
         qxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xn4JVNJ9XJSEASkNzP9jMQe9Wm2OoN/zXpBrpdejF78=;
        b=x1rxJAWrbWDhDxBdng7hl0uijuCVr4TyXzCnZwoAZRXyG0mkKvlmFG+omqX8SMMNuR
         6f1UMnFZViynTxlzjasC1VmX6jj0L03I5jiqiswAmoqRRATQkxkwTLUeZ8Opd5OSHI7c
         BJBOFAfRIYYG66j9gxQiXEI/a/loc8fCoonv84dn4IXTUY6qeV9KtRIcbG0hGsv+/Z1i
         KwvjmeRC9nvZ8OogAJ1dy83h/0H1kM6FqzyfnrzSzWtZ/SSUX0gPNEMAMf5J1IhFv/vN
         9rGqJPrRzjF8CTBmiTidhIFGUFbJD2cxJ90NpabGReeFbjj/KpQigAB4Dx2lOU4om227
         l6GQ==
X-Gm-Message-State: AOAM530Y+ssTt5EUX8mww8ggN2r1SLYLJeZli9QyoDEnzjHetZG0bxXz
        cSImYE+iqn16RPwhYIx8q6Ngbg8qVJbhyGBgEZzJM2Ja
X-Google-Smtp-Source: ABdhPJxpDEuRQPeBxijFR52biTLr9iDs6LEyVqWo/8cBwrS6LZrECiVnM04UOuK/hQseALmpcDqsb7OHUH8yXLUKvDc=
X-Received: by 2002:ac8:7e85:0:b0:2dd:fe84:6bac with SMTP id
 w5-20020ac87e85000000b002ddfe846bacmr15702906qtj.128.1646778704069; Tue, 08
 Mar 2022 14:31:44 -0800 (PST)
MIME-Version: 1.0
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com> <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
In-Reply-To: <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 8 Mar 2022 16:31:22 -0600
Message-ID: <CAAMCDefbLuK3sHbEsMgAXfA8fuDpXKAEWEgFhiX3a1CN70XiCg@mail.gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
To:     Song Liu <song@kernel.org>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I just looked at my raid6 check start/ends (before is 5.15.10-200
(fedora), after is 5.16-11-200 (fedora).
md14: 7disks before: 2hr20m, 2h19m, 2hr16m, 2h18m,2h34m, 2hr28m, 2h27m
  after: 5h6m, 4h50m.
md15: 7disk before: 3hr14m, after: 7hr24m, 6hr6m,7hr8m.
md17: 4disk before:  6hr11m, 6hr36m, 6hr27m, 6hr8m, 6hr16m   after:
8hr10m, 7hr, 5hr33m

So it appears to have affected the arrays with 4 disks significantly
less than my arrays with 7 disks.


.

On Tue, Mar 8, 2022 at 3:50 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Mar 7, 2022 at 10:21 AM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> >
> > I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> > One host with a 20 drive array went from 170MB/s to 11MB/s. Another host
> > with a 15 drive array went from 180MB/s to 43MB/s. In both cases the
> > arrays are almost completely idle. I can flip between the two kernels
> > with no other changes and observe the performance changes.
> >
> > Is this a known issue?
>
> I am not aware of this issue. Could you please share
>
>   mdadm --detail /dev/mdXXXX
>
> output of the array?
>
> Thanks,
> Song
