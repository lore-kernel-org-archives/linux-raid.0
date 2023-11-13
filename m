Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CFFC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 00:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjKMAle (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Nov 2023 19:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjKMAld (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Nov 2023 19:41:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0A9138
        for <linux-raid@vger.kernel.org>; Sun, 12 Nov 2023 16:41:30 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0820C433C9
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 00:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699836089;
        bh=yH3Hh52upDb4CeGCrcJdrPwY8XhjcKQgzU0FnunCluU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C7enJ15txBR0LFYk5NbaqSzJcVEpn2obYwZ9AkBNhNQ3iVcFLYM97OrIYdV303xr3
         F6Ho3I9C5OGtUptQqhVC5ft92Crj62+5C55oucIErYLYcWDcNIuXphcPPPfsX/uo7u
         /EePRi8b6300SVRg0v1scXL+iUvIOIN7KtfbqVNXhcrRNwf5rj5Z67I5b/hwdU5vlF
         f0UzYvajqs5D+zRqbRv56BqaGcWpwcKnSt3KLHYhUWhyLosm5GvbiDPuc0xCEKUJeM
         CWKuHzIvFNn1Wmslo1XdqnolewfcYDNkFyzfdaTJ9MylHQyLXYpgTC0GG7x1HYITnt
         Ewk5Z1+o43eKg==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2c501bd6ff1so53343931fa.3
        for <linux-raid@vger.kernel.org>; Sun, 12 Nov 2023 16:41:29 -0800 (PST)
X-Gm-Message-State: AOJu0YyVlN9AzBgubl7NdHcUyshLAouRBtRereIdTPH83OiVGRdZpOKY
        zxRGhPdxzlPSCK7hrBVSGBaJpKGXLbIltKqsGt0=
X-Google-Smtp-Source: AGHT+IGwNlzhHpbQS+NkSdfMAk8O8DpvcYFJVQxCnZx2b5pN2n11S1UaOavihDiEVxqaM51Z9rFnv7R8iU6pZRpnn2M=
X-Received: by 2002:a2e:1f11:0:b0:2c6:ecf7:16b2 with SMTP id
 f17-20020a2e1f11000000b002c6ecf716b2mr3441447ljf.17.1699836087906; Sun, 12
 Nov 2023 16:41:27 -0800 (PST)
MIME-Version: 1.0
References: <5727380.DvuYhMxLoT@bvd0> <ZU8ebDX5Tl1L4vMF@archie.me>
In-Reply-To: <ZU8ebDX5Tl1L4vMF@archie.me>
From:   Song Liu <song@kernel.org>
Date:   Sun, 12 Nov 2023 17:41:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5FweriE1zryRxXHwc4OjZ-A5vhKYubuhrhmM3R=d4f2Q@mail.gmail.com>
Message-ID: <CAPhsuW5FweriE1zryRxXHwc4OjZ-A5vhKYubuhrhmM3R=d4f2Q@mail.gmail.com>
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for the report!

I will look into this.

On Fri, Nov 10, 2023 at 11:25=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:
>
> On Sat, Nov 11, 2023 at 09:00:00AM +0900, Bhanu Victor DiCara wrote:
> > A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual=
 data.
> >
> >
> > #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
> > (The problem does not occur in the previous commit.)
> >
>
> regzbot dashboard shows that commit cc22b5407e9ca7 ("md: raid0: account
> for split bio in iostat accounting") should have fixed your regression.
> Can you try that commit?

6.6 kernel already included cc22b5407e9ca7. Also cc22b5407e9ca7 only
changes the behavior of raid0, so it shouldn't fix anything with raid5.

Thanks,
Song

>
> Thanks.
>
> --
> An old man doll... just what I always wanted! - Clara
