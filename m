Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11368C77B75
	for <linux-raid@archiver.kernel.org>; Sun,  7 May 2023 11:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjEGLa1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 May 2023 07:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjEGLa0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 May 2023 07:30:26 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D5E100EC
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 04:30:21 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-55c939fb24dso30866347b3.2
        for <linux-raid@vger.kernel.org>; Sun, 07 May 2023 04:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683459020; x=1686051020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vfuWu+BE08lwOpJfLUhEyAPQtfAevus+h5BnDoVzZw=;
        b=MSHXyNM+GThRXfE04B/7mHH6C9o9Az3KKVBEiWD2WULkHOzgj2luEVDFFeGSk2GbaT
         XTPxsn21QQAg91x9x/yCX5EJxv4Rg3dI/L7I58o3WEUZBDGawPnqsB7CJ/kUu2bZsDE3
         bf+RrUo8kAkYnS1vaGFd5T6mb9s/P7/ACnYZaCAXKGnI/bzpniKEd4gNXvhrJsGqPB1W
         ymqFxF/FKNLfUC2jzybvJGZG4ySWpx3D0g7ihKo3vDfNsz37YI3PS6o3ArczL1FHE3sw
         rHR/SazHH+gW4KxIyEe1A0uQYPtjOsD1QsmqQm3umkBWwZa/aUY0ByM4Jf1IVVk1m9p3
         omLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683459020; x=1686051020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vfuWu+BE08lwOpJfLUhEyAPQtfAevus+h5BnDoVzZw=;
        b=QaZi81mqln1DO/h3nPzJZkzZwWKja25HEvhyuOwEc+/530ZUjlBnwxe1f4qL9YBX7j
         IpInORquXF41fP6xRxd+59UxijreFQuWS0R+EQfo/4624KriAX2Q1MOCg+CGBiJDD0hG
         cb3w8kKFXTJE3+OY4Zm1+djFK/o7aSmUbKCQW3ka2UP/50GO3WbU2pUOKL98nMQuX5nj
         8HPmj/RHbmYcYfVJk17YIY4pK01g7FDUQOVKtR7qxnvabm+WXbn+X8BKlpOJpKty67u7
         t0ap0K0JuzNVxwSL81NL8bdxNR0T9KqZZD+ZQx/7dMcTUof5Fd2WJf0hqf1xYtmYXoQS
         YhCA==
X-Gm-Message-State: AC+VfDwi43hpdRaqSzbllFmDj1kw3Xk5iNWcb3F2rt+YTWzKjvSmAKcc
        N42oBdYF/151Mr/0a2BZFhnjB74nsZBNRRd6+wU=
X-Google-Smtp-Source: ACHHUZ5CHNCDhgRJdr6EY29BXypqdIqWkPJu4ZKDQMMpfPiEbtRIv5hqk6AamHIb3AX5IvKGQSk4Ckz+mDNl9z3Qiac=
X-Received: by 2002:a25:3291:0:b0:b92:3bfb:bbcc with SMTP id
 y139-20020a253291000000b00b923bfbbbccmr7291622yby.10.1683459020307; Sun, 07
 May 2023 04:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com> <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com> <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com> <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com> <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
 <90efe591-999e-93b4-5c52-440fe4aff161@youngman.org.uk>
In-Reply-To: <90efe591-999e-93b4-5c52-440fe4aff161@youngman.org.uk>
From:   Jove <jovetoo@gmail.com>
Date:   Sun, 7 May 2023 13:30:09 +0200
Message-ID: <CAFig2csM8XUskCGGMUqSv0kXw6eXRacxLr5yNMyQggTvWOanUA@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Wol <antlists@youngman.org.uk>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

> I wouldn't think it necessary to scrap the array, but if you've backed
> it up and are happier doing so ...

Not particularly. I have taken backups and I am reshaping it to 5 raid
devices and if it works, I'll keep it.

> As for the "invalid backup" problem, you should never have given it a
> backup in the first place, and (while I don't know the code) I very much
> expect it ignored the option completely.

I don't know, Wol. I added the option because the wiki recommended it.
All I know is that when I tried to resume the reshape without the
option or without the --invalid-backup option, mdadm complained it
could not restore the critical section and refused to assemble the
array.

> Once an array goes through reshapes, it can be a lot harder to work
> out the layout if you have to rescue the array by recreating it.

I am no longer going to rely on the array alone to keep my data safe.
Should this array ever fail again, there will be backups to recover
from.

Thanks,

    Johan



On Sat, May 6, 2023 at 11:59=E2=80=AFPM Wol <antlists@youngman.org.uk> wrot=
e:
>
> On 06/05/2023 14:07, Jove wrote:
> > Hi Kuai,
> >
> > Just to confirm, the array seems fine after the reshape. Copying files =
now.
> >
> > Would it be best if I scrap this array and create a new one or is this
> > array safe to use in the long term? It had to use the --invalid-backup
> > flag to get it to reshape, so there might be corruption before that
> > resume point?
> >
> > I have to do a reshape anyway, to 5 raid devices.
> >
> I wouldn't think it necessary to scrap the array, but if you've backed
> it up and are happier doing so ...
>
> AIUI it was an external program squeezing in where it shouldn't that
> (quite literally) threw a spanner in the works and jammed things up. The
> array itself should be perfectly okay.
>
> As for the "invalid backup" problem, you should never have given it a
> backup in the first place, and (while I don't know the code) I very much
> expect it ignored the option completely. You have superblock 1.2, which
> has a chunk of space "reserved for internal use", one of which is to
> provide this backup.
>
> The only real good reason I can think of for scrapping and recreating
> the array is that it will give you a clean array, with ALL THE CURRENT
> DEFAULTS. This is important if anything goes wrong in future, if you
> have an array with a known creation date, that has not been "messed
> about" with since, it's easier to recover if you're really stupid and
> damage it and lose your records of the layout. Once an array goes
> through reshapes, it can be a lot harder to work out the layout if you
> have to rescue the array by recreating it.
>
> Cheers,
> Wol
