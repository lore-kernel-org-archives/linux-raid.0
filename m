Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065ADCDB47E
	for <linux-raid@archiver.kernel.org>; Wed, 18 Oct 2023 17:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjJRRyQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjJRRyP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Oct 2023 13:54:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05ABEA;
        Wed, 18 Oct 2023 10:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ED4C433C7;
        Wed, 18 Oct 2023 17:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697651653;
        bh=UMbYfhLFAk7mnzSPZbWqAxVN7HL/vxhltu6OsLTt8kY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Khz4QCLWvW5mEVSaoaEZVNnUzmZSX11yUaDkq4EO/rD+jmfhn/Z+uz6nmwvq0jZym
         QONMIg61LummTeSfM85rNwu659kBjZd689Wzvbu7w9zTIP6NRA22zaibfPa9W0BT6F
         tMiNb0GNzDaCxu/rUZezOwYHH5q1OExxhem6GOkaZNrfQmGohZlHfz/SwwwPUZ4Tx4
         /TBK8lvwOJNerOxcYselsxRb+sFd398qwFgkN6dHJFr09MftNg0aMnClBTZbFgVHFD
         IWcuINJ+ermXSTmKmnTgoSvoU5AgjlP0uEg29HeU4H3+oNYHSnMQEPH+yFG+pgUZSj
         1xiCLub5y4e5A==
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1c9b95943beso60227235ad.1;
        Wed, 18 Oct 2023 10:54:13 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyz4PfjT8k7lrrbWq6bkY78WjABow5J8wdyUjcPwpDyXSw3eXF8
        bwNfDgXU4TILHhh5tltvSAhwHHxIHlddPwCWdLg=
X-Google-Smtp-Source: AGHT+IHzFP/SWHcjsGV9qi52IfIK/oX7xpaS9D5bsOAhIQ6+BIWEsqvWuuojLLxWCJDUgCMtZ64ZbVMVL6JOL6jZOLE=
X-Received: by 2002:a17:902:d545:b0:1ca:884c:e48a with SMTP id
 z5-20020a170902d54500b001ca884ce48amr129950plf.0.1697651653220; Wed, 18 Oct
 2023 10:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20231016092439.493646-1-yukuai1@huaweicloud.com> <20231016092439.493646-3-yukuai1@huaweicloud.com>
In-Reply-To: <20231016092439.493646-3-yukuai1@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 18 Oct 2023 10:53:59 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4+bn41+LK1y_RmssmwpMML15=WVo6iTL76x8CATzKE3A@mail.gmail.com>
Message-ID: <CAPhsuW4+bn41+LK1y_RmssmwpMML15=WVo6iTL76x8CATzKE3A@mail.gmail.com>
Subject: Re: [PATCH -next 2/6] md: remove flag RemoveSynchronized
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Oct 15, 2023 at 6:28=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> rcu is not used correctly here, because synchronize_rcu() is called
> before replacing old value, for example:
>
> remove_and_add_spares   // other path
>  synchronize_rcu
>  // called before replacing old value
>  set_bit(RemoveSynchronized)
>                         rcu_read_lock()
>                         rdev =3D conf->mirros[].rdev
>  pers->hot_remove_disk
>   conf->mirros[].rdev =3D NULL;
>   if (!test_bit(RemoveSynchronized))
>    synchronize_rcu
>    /*
>     * won't be called, and won't wait
>     * for concurrent readers to be done.
>     /*
>                         // access rdev after remove_and_add_spares()
>                         rcu_read_unlock()

I am having a hard time following the description here. Please be more
specific about what issue we are fixing here.

Thanks,
Song

>
> Hence remove this flag and prepare to remove rcu protection to access
> rdev from 'conf'.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
[...]
