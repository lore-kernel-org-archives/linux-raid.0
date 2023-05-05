Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD0AC77B75
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 15:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjEEPrp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 11:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjEEPro (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 11:47:44 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D198B59D8
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 08:47:41 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-55b7630a736so28188217b3.1
        for <linux-raid@vger.kernel.org>; Fri, 05 May 2023 08:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683301661; x=1685893661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PfXjde2Oi8l2RUpo54ZtE0qFDbF9EfkPv2241rXkkw=;
        b=BezMntnsPDxeHnSPeptds/Qv2IkBQMr++rIrjdX2aCXE5VbTWfJRlKbzkdrfZNqSKn
         m06HpDclPXUP/gUVw+Y098KmyOuyhMqpngNYm/rzrtQZ5RDVg5cMdUXH2zg4hYA27e7U
         ljUtq9S9inlAWT+uJuWfJidJuxxwz8zKl6rX8NgxXK27hrbOklLqsBM3zcceMv5q6bH8
         KslYBlmsKPevuZTcuiIxKmBZIRkLUoJ7hG2YXIVrBa6gxzjyWf5Sf9rWGaNOgc8XLLMR
         WFcgPzWuouZP03Iud9qjzA5MtEzryheYppnOXaduUEjcwxnPEJSlDi6pJq+SGkQwnvLs
         N3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683301661; x=1685893661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PfXjde2Oi8l2RUpo54ZtE0qFDbF9EfkPv2241rXkkw=;
        b=OkbD9e6VkG1Bx1Bn/Xt7/cq1egjq2Q4JsrjFvyZbtO6e2Dg7xLGwYz1G35aPk2Z2ls
         212sDK6+a12u0YiXYdi6iEB9+IJlQbCUlC5cYCh3Pyxa/YAT6g1xjQNBah6MxFQFylvk
         2ccyt7MkfPyBmPsD52/S786479mVCtqDJ8VqOAakZMFar8DToTgHk5nwH+hJopoac8ch
         r2QV/4cbqeP59vDC/X/y8Um1EcJjjaVeZs16Ac5TDdXXl1MrEXGZ3YjdEHFEg04iv/EV
         eKC8AgzoMIGodWdZAwrkl8HnzlSed8mWluVKzmjwfok1gBvTw0TZOd0Gi1LBWwb4aGZV
         JUCA==
X-Gm-Message-State: AC+VfDzCd3QBR59iF+TyvKPug60ilcIAhZbe9ZhT4ZJ/oPlU33GKeeN/
        JzAEnX/7gSjB1Bii1p0cMIVv3LWp4rwNZalcaIM=
X-Google-Smtp-Source: ACHHUZ4xI/3YCu3AQqEXiFpY/QGE8uWlKWV495ISSm3tKzvnclDvL7oN5qeYH/tVNP5SzizK7qBY3tMGNgp0kioE09U=
X-Received: by 2002:a25:ad08:0:b0:b9e:66f0:be9d with SMTP id
 y8-20020a25ad08000000b00b9e66f0be9dmr1635327ybi.61.1683301660961; Fri, 05 May
 2023 08:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com> <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com> <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
In-Reply-To: <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
From:   Jove <jovetoo@gmail.com>
Date:   Fri, 5 May 2023 17:47:29 +0200
Message-ID: <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai.

> Jove, As I understand this, if mdadm make progress without a blocked
> io, and reshape continues, it seems you can use this array without
> problem

I've had to do some sleuthing to figure out who was doing that array
access, I was already running a minimal FedoraCore image. I've
discovered that the culprit is the systemd-udevd daemon. I do not know
why it accesses the array but if I stop it and rename that executable
(it gets started automatically when the array is assembled) then the
reshape continues.

Now it is just a matter of time until the reshape is finished and I
can discover just how much data I still have :)

Thank you all for your help, I will send a last mail when I know more.

Best regards,

      Johan



On Fri, May 5, 2023 at 10:02=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/05/05 14:58, Wol =E5=86=99=E9=81=93:
> > On 05/05/2023 02:34, Yu Kuai wrote:
> >>> I have had one case in which mdadm didn't hang and in which the
> >>> reshape continued. Sadly, I was using sparse overlay files and the
> >>> filesystem could not handle the full 4x 4TB. I had to terminate the
> >>> reshape.
> >>
> >> This sounds like a dead end for now, normal io beyond reshape position
> >> must wait:
> >>
> >> raid5_make_request
> >>   make_stripe_request
> >>    ahead_of_reshape
> >>     wait_woken
> >
> > Not sure if I've got the wrong end of the stick, but if I've understood
> > correctly, that shouldn't be the case.
> >
> > Reshape takes place in a window. All io *beyond* the window is allowed
> > to proceed normally - that part of the array has not been reshaped so
> > the old parameters are used.
> >
> > All io *in front* of the window is allowed to proceed normally - that
> > part of the array has been reshaped so the new parameters are used.
> >
> > io *IN* the window is paused until the window has passed. This
> > interruption should be short and sweet.
>
> Yes, it's correct, and in this case reshape_safe should be the same as
> reshapge_progress, and I guess io is stuck because
> stripe_ahead_of_reshape() return true.
>
> So this deadlock happens when io is blocked because of reshape, and
> mddev_suspend() is waiting for this io to be done, in the meantime
> reshape can't start untill mddev_suspend() returns.
>
> Jove, As I understand this, if mdadm make progress without a blocked
> io, and reshape continues, it seems you can use this array without
> problem.
>
> Thanks,
> Kuai
> >
> > Cheers,
> > Wol
> >
> > .
> >
>
