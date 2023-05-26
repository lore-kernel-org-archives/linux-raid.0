Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA005C77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 21:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjEZVQK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 17:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjEZVQJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 17:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1EEAD
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 14:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2878265395
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 21:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF83C433D2
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685135767;
        bh=KpPDPCfXeZIqH2rI2ZZJEIZZ1rEE4pD6brQWl9N8wkw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kKJXYD+vKUBqLyGQBbpP4Z6of0F1H9gCJi9Ic/5iJCLvCZp/TbzFhoA5pnWXw9oYq
         rWGplOA4YaSTqdZeFZpea8MvoQwIg+bBm+ucOQr+hS5+Z+jnZ+Bn21M16Wn4voYHWx
         72F+3AuYxz+LgfB3FaMJlQZiQR25JHUoqjeSY1B8mWxyGXqY0BR+wEUTGCB7jVIlmf
         Lf53EwlIqAavp+FkQcbGrR8jFaoeiuzhigCLrGwRYX4EKFvKDxrtxUn4kb5hHRIOvL
         Dm45xFEUKrRwysL5NqoDPOk7bE7rOYUR/zem79bIA1C71nUA5GkQR93by82wr0hERV
         NV+gkBh4p56uw==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4f3b5881734so1370192e87.0
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 14:16:07 -0700 (PDT)
X-Gm-Message-State: AC+VfDxs4U5GH86TUMips8gnifEeXm9RDzuM9AQ+6+dyXBqDqTnaOS8D
        q+Yw34RPkd7VOP5AZ8zkk5NJ0Nwg8lVlR+QAh1g=
X-Google-Smtp-Source: ACHHUZ5DARERXcU4WvcJRtg0HA9Q4IxFiXHqQseNAGMEGK4Let8NpAb8aSX6nwNsiChSqpdW426MHU4y0GLH1Xz/Plo=
X-Received: by 2002:ac2:5e85:0:b0:4f3:a87f:a87b with SMTP id
 b5-20020ac25e85000000b004f3a87fa87bmr981915lfq.39.1685135765587; Fri, 26 May
 2023 14:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <3D58B70B-92D3-4355-A89D-0F6490448546@fb.com>
In-Reply-To: <3D58B70B-92D3-4355-A89D-0F6490448546@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 May 2023 14:15:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6V0dQkGov7rxhUhuj5sf38YNUmPoin0sxP3=MnYDdZKw@mail.gmail.com>
Message-ID: <CAPhsuW6V0dQkGov7rxhUhuj5sf38YNUmPoin0sxP3=MnYDdZKw@mail.gmail.com>
Subject: Re: [GIT PULL] md-fixes 20230524
To:     Song Liu <songliubraving@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 24, 2023 at 12:03=E2=80=AFPM Song Liu <songliubraving@meta.com>=
 wrote:
>
> Hi Jens,
>
> Please consider pulling the following change for md-fixes on top of your
> block-6.4 branch. This change fixes a raid5 regression since 5.12 kernels=
.
>
> Thanks,
> Song
>
>
>
> The following changes since commit 3eb96946f0be6bf447cbdf219aba22bc42672f=
92:
>
>   block: make bio_check_eod work for zero sized devices (2023-05-24 08:19=
:26 -0600)
>
> are available in the Git repository at:
>
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git tags=
/md-fixes-2023-05-24

Just realized that I forgot to update the repository address. Ut should be:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
tags/md-fixes-2023-05-24

I am sorry for this inconvenience.
Song


>
> for you to fetch changes up to 8557dc27126949c702bd3aafe8a7e0b7e4fcb44c:
>
>   md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk() =
(2023-05-24 10:44:19 -0700)
>
> ----------------------------------------------------------------
> Yu Kuai (1):
>       md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chun=
k()
>
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
