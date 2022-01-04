Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DEBC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 17:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiADR2y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jan 2022 12:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiADR2y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jan 2022 12:28:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7229AC061761
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 09:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 324B2B810A0
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 17:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0475C36AED
        for <linux-raid@vger.kernel.org>; Tue,  4 Jan 2022 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641317331;
        bh=T8UEnZWCNzSMET7KgsV3aQwOEh+hJLUmc17TKwdXsQw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E9gjB9vGP7zzTk45u1iL7ewCi38uo9oqKcIb0EaodKj0+i4IYYw87K2gX/+NPYj0G
         t7b6T78Y33U0HdFWTtXmY1Zr9zzaPFbLVhrom8vkgObP4HuEu8imk5JOjgHH309jv+
         hGoihckIHPjnQfQBFUBRXroPgcHRw6mlfoZSV2Pnc0x6txVYZ7E/GZqMSBmsj5pQou
         5XlP9QdWTannfRQqOP5FQK4e7Z9OaD36DB7ZH1h3AgJc4aDpuSdAKyZTcdalVerqQj
         rq39KY4CEVKBkl1xLrQFOYQRkj/nuM42seiX2JgpF6odKWWbo3QNxVtih7Yn0LY6zy
         jERN+rJlvHRLg==
Received: by mail-yb1-f176.google.com with SMTP id o185so82975786ybo.12
        for <linux-raid@vger.kernel.org>; Tue, 04 Jan 2022 09:28:50 -0800 (PST)
X-Gm-Message-State: AOAM533VLLwCWwO9q/5lJYkNiXg9E9UyHfpsKwi3Ao0p/67NC3MM/DYo
        v5oQ3j3uulVozLMd7SL+aUbW1rmzrqlpqDjIAEw=
X-Google-Smtp-Source: ABdhPJw/rGYwqV8iTrBrSAMeTnwm+AQGnKTX60a848/hEopI4Xx41sKVPJdjVrIJlYx6sijsD5bBLgQaXIj6MZR842M=
X-Received: by 2002:a25:8e10:: with SMTP id p16mr52855472ybl.219.1641317330074;
 Tue, 04 Jan 2022 09:28:50 -0800 (PST)
MIME-Version: 1.0
References: <20211229223600.29346-1-dmueller@suse.de> <CAPhsuW6+kfUFoJNQVbTnWPaqPZECnwEUXf6q7FbSQpJGtMMsYg@mail.gmail.com>
 <4023010.WmdfGTY597@magnolia>
In-Reply-To: <4023010.WmdfGTY597@magnolia>
From:   Song Liu <song@kernel.org>
Date:   Tue, 4 Jan 2022 09:28:39 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ThAK78JNfVZ0P8W1vKm2nWk7kYm350WFdSzBwcR3-ZQ@mail.gmail.com>
Message-ID: <CAPhsuW5ThAK78JNfVZ0P8W1vKm2nWk7kYm350WFdSzBwcR3-ZQ@mail.gmail.com>
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 3, 2022 at 8:28 AM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> On Sonntag, 2. Januar 2022 01:03:44 CET Song Liu wrote:
>
> > We need  more explanation/documentation about 0 vs. 1 vs. 2 priority.
>
> In the commit message? in the code? this is basically a copy&paste of the=
 same
> concept and code from a few lines below the diff, struct raid6_recov_call=
s
> which works the same way and currently has no documentation at all.
>
> want me to add to both then?

I guess we only need something like:

  .priority =3D 2   /* avx is always faster than sse */

>
> > >                         if ((*algo)->valid && !(*algo)->valid())
> >
> > If the module load time is really critical, maybe we can run all
> > ->valid() calls first and
> > find the highest valid priority. Then, we only run the benchmark for
> > these algorithms.
>
> thats exactly what the code always did. previously all x86_64 specific
> implementations (be it SSE1/SSE2/AVX2/AVX512) all had the same priority l=
evel
> 1, over the default priority level 0 for the implemented-in-C int*.c rout=
ines.
> with this change, we have one more level p refering AVX* over the rest, s=
o
> that we skip testing SSE1/SSE2 (similary to how the integer implementatio=
ns
> have always been skipped before).
>
> > Does this make sense?
>
> the valid call is not probing anything by itself. it just iterates over a
> small array of functions and stops executing benchmarks for those that ha=
ve
> lower priority ranks.
>
> so there isn't really a lot of cycles to win by changing the execution or=
der
> here. I would assume it will actually slow things down as we have to stor=
e the
> valid() result for the 2nd iteration.

Let's keep this part as-is then.

Thanks,
Song
