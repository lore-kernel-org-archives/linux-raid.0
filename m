Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F881CE7A81
	for <linux-raid@archiver.kernel.org>; Fri, 22 Sep 2023 23:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjIVXJM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Sep 2023 19:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjIVXJL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Sep 2023 19:09:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C519A
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 16:09:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE4C433C8
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695424145;
        bh=Cj38s9axsTNyUNarkn92PiixZm6B6Ba88TAllYzf2mo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YkouT9avhG5gCxTKDij1UjstD2c0xn9CQPzrJdGLzxG+6Ui5FB/IaNvFeBAKr8DYP
         GkeSkf6rd9F/FNhwmPe+G4UMSBbKXpsejYfi7y4QQMs1e7JtPzuZCThOZbw8nK4Cvr
         w6bsQyUx4vfoksfIR3T4oAHK8xZE2M+/wTc/Q3s5eeceiTNd3k7o9AwADZAoHUA7Fh
         m2x721qyf3jylTJ3oi/KvWsFsmu2Q3hDLOBtnsDlKYKloLGEKs3P4vejnEcOIbWEpn
         XsFS4WRtWvXkqJ0MoLLkTmIhDrHGoSpMdwgezmJdpBdMyI6wK/Uztd2jq4Icve2Md5
         rjXgGncsik/+w==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2c124adf469so51283731fa.0
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 16:09:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YxB8djZOtDekxZNPlzwcz0K0dHSuvngiK0ta8v4AUJEcP34Abjg
        t8DsbX1o6dDcjW7FL0H4idCpoXu2+bp2Spg/mz4=
X-Google-Smtp-Source: AGHT+IEAb+xDxRN3HgexXJCyA3Nj9nD7JJYeVV5OIEdt78KHSlk6j9bbQtcn8PWQQkwDhlhYDV8R+2xAkkzxyA2TeGY=
X-Received: by 2002:a05:6512:3446:b0:4fb:9f93:365f with SMTP id
 j6-20020a056512344600b004fb9f93365fmr676218lfr.38.1695424143960; Fri, 22 Sep
 2023 16:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm> <b8f8cc10-8081-afe4-738b-376a1248ec05@ultracoder.org>
In-Reply-To: <b8f8cc10-8081-afe4-738b-376a1248ec05@ultracoder.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 22 Sep 2023 16:08:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Dvk4cgfqju=Oz1wdHeXtYdW--fbSq8r8xqQSsCpf81A@mail.gmail.com>
Message-ID: <CAPhsuW5Dvk4cgfqju=Oz1wdHeXtYdW--fbSq8r8xqQSsCpf81A@mail.gmail.com>
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
To:     Kirill Kirilenko <kirill@ultracoder.org>
Cc:     Mike Snitzer <snitzer@kernel.org>, Roman Mamedov <rm@romanrm.net>,
        Alasdair Kergon <agk@redhat.com>, heinzm@redhat.com,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi folks,

Thanks for the report. I will try to reproduce this issue next week.

Song

On Fri, Sep 22, 2023 at 9:25=E2=80=AFAM Kirill Kirilenko <kirill@ultracoder=
.org> wrote:
>
> On 22.09.2023 00:45 +0300, Mike Snitzer wrote:
> > Given your use of 'writemostly' I'm inferring you're using lvm2's
> > raid1 that uses MD raid1 code in terms of the dm-raid target.
>
> Yes, exactly.
>
> On 22.09.2023 00:45 +0300, Mike Snitzer wrote:
> > All said: hopefully someone more MD oriented can review your report
> > and help you further.
> Thank you. I don't need to send a new report to MD maintainers, do I?
>
> On 22.09.2023 01:03 +0300, Roman Mamedov wrote:
> > Maybe your system hasn't frozen too, just taking its time in processing=
 all
> > the tiny split requests.
> I don't think so, because the disk activity light is off. Let me clarify:
> if music was playing when the system froze, the last sound buffer begins
> to play cyclically.
