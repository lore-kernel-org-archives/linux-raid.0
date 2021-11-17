Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADCDC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D08D61544
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhKQH0x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232792AbhKQH0x (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 02:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCC8A61544;
        Wed, 17 Nov 2021 07:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637133834;
        bh=GZZOJoaB2rZemxlLF0pucwz12KptrJbt1uNgr4ETHH4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C+Zle1bqBsXcevdIkK6O3Q7gWWsWwFg6TptMY82V0rMJW3B2vspOwVTIlGNfEZETd
         B7GrDOh3OdjQbYImspfe3iosRBDfzr2IHdQG8FazpZsphRaGL4l+Q0JbvlYIUavqfr
         XxeDWIb1W3a02b3hzHoy2P5MHaF6N97Q1x5zYy9Q5JrUSoVjnLAZSat2vRckuzarUX
         hPlkCHLQw1G9tcckC5A0W2jl5SoqwzcVpFXV0Etq6EYoR283nWfhGH9p/Sassa7k8+
         ymq7AgDu/1rZcRSOokxxtI1KWVlKmrJrwcjvmA9YGJI/km1IJjTNoA5xC6ZrP29ORA
         35ZDCx4aN4iyw==
Received: by mail-yb1-f181.google.com with SMTP id n2so265450yba.2;
        Tue, 16 Nov 2021 23:23:54 -0800 (PST)
X-Gm-Message-State: AOAM531Dye3f7J2Iwgh5oCtugHtKOfaMW+Nbn43/Z5HcHVlff9w12VEP
        ZX2KX6xVJbimLwy1clgHKQQWd+x2nPVKESVQF74=
X-Google-Smtp-Source: ABdhPJz3yN/F+ytDeSifn9XNMg2kO3mvX+WshDAM3C9Qeg2hRsZe8ZQzGzqBNnWImxh3L2NktrbvgslpbIbsf3sCHbU=
X-Received: by 2002:a25:324d:: with SMTP id y74mr15124707yby.526.1637133834160;
 Tue, 16 Nov 2021 23:23:54 -0800 (PST)
MIME-Version: 1.0
References: <20211116023526.7077-1-zhangyue1@kylinos.cn>
In-Reply-To: <20211116023526.7077-1-zhangyue1@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Tue, 16 Nov 2021 23:23:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7xJhRWv6N=-KJVd3+=zX1r5nxGguxe0kOC=Fk5JtXxVQ@mail.gmail.com>
Message-ID: <CAPhsuW7xJhRWv6N=-KJVd3+=zX1r5nxGguxe0kOC=Fk5JtXxVQ@mail.gmail.com>
Subject: Re: [PATCH] md: fix the problem that the pointer may be double free
To:     zhangyue <zhangyue1@kylinos.cn>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Nov 15, 2021 at 6:37 PM zhangyue <zhangyue1@kylinos.cn> wrote:
>
> int driver/md/md.c, if the function autorun_array() is called,
> the problem of double free may occur.
>
> in function autorun_array(), when the function do_md_run() returns an
> error, the function do_md_stop() will be called.
>
> The function do_md_run() called function md_run(), but in function
> md_run(), the pointer mddev->private may be freed.
>
> The function do_md_stop() called the function __md_stop(), but in
> function __md_stop(), the pointer mddev->private also will be freed
> without judging null.
>
> At this time, the pointer mddev->private will be double free, so it
> needs to be judged null or not.
>
> Signed-off-by: zhangyue <zhangyue1@kylinos.cn>

Applied to md-fixes. Thanks!

Song
