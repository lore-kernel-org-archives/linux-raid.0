Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CBCEB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 19:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjFWTRO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 15:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjFWTRO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 15:17:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53E3E8
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 12:17:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-989d03eae11so118950866b.2
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 12:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687547831; x=1690139831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0h+9uqpnThW8xNc9HKtffDoqNR9WXMY3d/2wmRdmc3s=;
        b=hO0zwMjZMzKq4MhCNuxyYbTWDN9k3sjMF3WCvI0R2zrFWpqYbUBu2ktYVZN274uLMj
         zDYDZFZfpUzoNlzbPdLpTwqWTuPk8ecSOBYzctSvgoAE3xPvgNIU4h0L4BXRG983D5hY
         O9XDB6VrwHgk1fyYWZJLNTOzqse7Nx8h69zIUwTM7zpngNHlCejZ5ESNphT4oY14IjqI
         OslriCrOlfVm/mzkoLt3DhhZq0ykfaTAVMzo7xZegOSyblNrvd4TtdNEPwxj085oEl53
         dAZVvTYNwOJRswPSgDaMtajjI6mkyMt2YHAfl9ITYOQL0nald+f2fHJwIMhwfkkDYyPl
         NWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687547831; x=1690139831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0h+9uqpnThW8xNc9HKtffDoqNR9WXMY3d/2wmRdmc3s=;
        b=QtZ3XWGo9lJgH/dTbysK8SNRvlPLdt87zKrfnSN9y67zz+1OVwJ+Ay0/rzCo9SAe+q
         CUfo7GFUheCQBNzTCBqg3pw/ZVsC/f+gD8ABWTJMl6eq7/PRzlk/Vsq5+Hd/Kx1h+EYH
         qD6DXx+qAIujafU8oUR+lUAec68v29cx+u/GOnyMUu46/hgmIURn4TDPhWN1nhLmg+vl
         Mz8tru+DUby6AVW6jNb6TWIJIxahCvVX1cIhclBcPeCxLFocKr82Q7Ud1uokTmyYVCnS
         3i/K0E1Oxxo4xRt7MJ4b0dUd0hgKajq9X6K1spzoCmP9nj/nkMgvW9G1ZvNiCyuhlGFC
         PUVw==
X-Gm-Message-State: AC+VfDy3ufLBCQL2SgGFyirYg4GJh95tsbTlsu1zFekGswmnGERPufmU
        /KCaz+wiKPMNS94JYyLHOxtkt+vXEEGaAAWAoDk=
X-Google-Smtp-Source: ACHHUZ5/fKCcnAHiMKf6MksIvZmqgDJuktY0MvunKCqMH1MQUcN6bCeORAl1VcTYyqQ0v2KalbQug2fq56O9BF6Cnm0=
X-Received: by 2002:a17:907:9627:b0:988:3943:aaa4 with SMTP id
 gb39-20020a170907962700b009883943aaa4mr18637512ejc.29.1687547830962; Fri, 23
 Jun 2023 12:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com> <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com> <CAO2ABioUC9Wy=7FaPAP+AUmd5S-Xanj2d9JJYkqU4BL8DxW5Bg@mail.gmail.com>
 <b1252ee9-4309-a1a9-d2c4-3e278a3e70b6@huaweicloud.com> <CAO2ABioXHT9c4qPx5S4dKsMZLyE0xLGBzST5tSTu8YPmX4FxYQ@mail.gmail.com>
 <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com> <CAO2ABiqEoi4iB__b7KdYu_jQqmeB8joh5xurHNeXj9583mcjjA@mail.gmail.com>
 <1392b816-bdaf-da5f-acc8-b6677aa71e3b@huaweicloud.com> <CAO2ABiqkg7HobNvXRWrid36+uYwZ3yHqLmbft_FQwzD9-B7mRg@mail.gmail.com>
 <CAAMCDec_qt0wsfQ6d1CWc4e3hYtzXabw_sK9ChjMUSkA0cPxXg@mail.gmail.com> <d32a481b-4160-da34-8a1e-303c44d835f7@huaweicloud.com>
In-Reply-To: <d32a481b-4160-da34-8a1e-303c44d835f7@huaweicloud.com>
From:   David Gilmour <dgilmour76@gmail.com>
Date:   Fri, 23 Jun 2023 13:17:00 -0600
Message-ID: <CAO2ABipBVa3c6v72TG32Ggf+FX+Zm5B5cniNgP_PPvDyaS9OZA@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I wanted to provide an update on this thread. First of all thank you
for all the insights and recommendations. I finally found a way to
recover my data and wanted to pass what the fix was in the event
someone stumbles across this exact scenario. Summary below
 - I believe there is some kind of problem with kernel or module in
5.14.0-319.el9.x86_64 for my controller (ASMedia ASM1064 chipset)
which I believe was responsible for the drives attached to it
disappearing while my grow from raid 5 to raid 6 was taking place
 - After the above event (and rebooting) whenever I tried to assemble
the raid to kick off resuming the rebuild mdadm would hang as
previously described in this thread.
 - After Yu pointed me to a patch that might of bypass the issue I
decided to first boot the system on a rescue disk with an older kernel
(3.x) and mdadm version
 - Fortunately, my assemble succeeded and the grow resumed and the
slow rebuild of my 30TB array completed 17 days later
 - My ASMedia ASM1064 chipset controller was 100% stable for the 17
days of rebuild on the old kernel
 - As soon as I went back to my 5.14.0-319.el9.x86_64 kernel my
ASMedia ASM1064 controller started showing ata timeout errors and
drives disappearing again
 - I ended up just purchasing another controller with a different
chipset (Marvell 88SE9215) out of desperation and the system is
finally stable and my data is all intact!

Again thank you everyone for the help!

--David


On Mon, May 8, 2023 at 8:33=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/05/09 6:53, Roger Heflin =E5=86=99=E9=81=93:
> > On Mon, May 8, 2023 at 6:57=E2=80=AFAM David Gilmour <dgilmour76@gmail.=
com> wrote:
> >>
> >> Ok, well I'm willing to try anything at this point. Do you need
> >> anything from me for a patch? Here is my current kernel details:
> >
> > grep -i mdadm /etc/udev/rules.d/* /lib/udev/rules.d/*
> >
> > If you can find a udev rule that starts up the monitor then move that
> > rule out of the directory, so that on the next assemble try it does
> > not get started.
> >
> > If this is the recent bug that is being discussed then anything
> > accessing the array after the reshape will deadlock the array and the
> > reshape.
>
> It's not anything accessing the array, in fact, it's only the io accross
> reshape position can trigger the deadlock.
>
> I just posted a fix patch in the other thread by failing such io while
> reshape can't make progress. However, I'm not sure for now if this will
> break mdadm, for example, will mdadm must read something from array to
> make progress?
>
> Thanks,
> Kuai
> > .
> >
>
