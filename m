Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542F5C77B7E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 22:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjDXWgx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjDXWgm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 18:36:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A827D8A4E
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 402DA629D9
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0372C4339B
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682375796;
        bh=xxPLM7naqOLqhqpz5Vc4Q9e3zmwgT4l1aOIA/hsLzuA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LcqO/EJ/D5g+DJ4E3SEZTNGVdXiLB2Ko6S6x1WZupkikWrHdO/xzIVpsRUOSbMiju
         XUxaGizTk34hoPMlbQJ5jI0NX2/vYJqok+L5TD3tpqSVPtHrGLrkABLs/7tb+pD2Lv
         bFgMctUSg+fVMSAyCGi5ET5o9S7EmWj0R1RbnRdKN4yzPX+HqKm+rAKcj9x0NKmMz7
         pFiv6u/ACW/0pOn4+1K3fpjyAt+NLAy+OUpwhg1RyAyoIiZ9jE/EZVobLImEdAlXrZ
         dvYW88darc2t9kdflD9hS/A6ZRX9c6Hf98Ws4ktdiCcEMfOKAzlzHyYpiZE2glwPkX
         sU5efiAoIEEfA==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4efeea05936so2166171e87.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:36:36 -0700 (PDT)
X-Gm-Message-State: AAQBX9d807fIAwazVAS/EKeSTrfG9qai0P8jLsH/ryO2GLTOycdrKxSJ
        qFWcDnnQJFjHnb+YTrFxiGer/w2zwb7+dwZlMuc=
X-Google-Smtp-Source: AKy350Ys3IP5f3cH/GvQvOAAhhrNEaHi6Ahgri1juh4OLNVgWrswvfQ5yqfz2oTvBYMVHqn3R49AyzO1N1oxGx3V4Xg=
X-Received: by 2002:ac2:5589:0:b0:4ea:e60a:2f5d with SMTP id
 v9-20020ac25589000000b004eae60a2f5dmr3467471lfg.40.1682375794657; Mon, 24 Apr
 2023 15:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230417171537.17899-1-jack@suse.cz> <ZEblloZgE0FxMNow@fisica.ufpr.br>
In-Reply-To: <ZEblloZgE0FxMNow@fisica.ufpr.br>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Apr 2023 15:36:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW60kiAbc2Z2SvJSjNo4kL0m26Aarjc4UuNV-AapAiebew@mail.gmail.com>
Message-ID: <CAPhsuW60kiAbc2Z2SvJSjNo4kL0m26Aarjc4UuNV-AapAiebew@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
To:     Carlos Carvalho <carlos@fisica.ufpr.br>
Cc:     Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 24, 2023 at 1:25=E2=80=AFPM Carlos Carvalho <carlos@fisica.ufpr=
.br> wrote:
>
> Jan Kara (jack@suse.cz) wrote on Mon, Apr 17, 2023 at 02:15:37PM -03:
> > Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed th=
e
> > order in which requests for underlying disks are created.
>
> In which version was this first applied?

7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") is in 6.0+ kernels.

>
> We've observed a large drop in disk performance since 4.* to the point th=
at
> 6.1.* is almost unusable for some tasks. For example, we have 2 backup
> machines, one using raid6/ext4 and another using zfs. The backup of a thi=
rd
> machine with a filesystem with ~25M inodes takes 6x-8x longer on the one =
using
> raid6/ext4 than on the one using zfs... This is during the rsync phase.
> Afterwards it removes old trees and the rm with raid6 takes eons even tho=
ugh
> the disks are not at all busy (as shown by sar). Running several rm in pa=
rallel
> speeds things up a lot, showing the problem is not in the disks.

I am hoping to look into raid performance soon. But I cannot promise anythi=
ng
at the moment.

Thanks,
Song
