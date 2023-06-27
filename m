Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C93EB64D7
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jun 2023 00:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjF0AhY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Jun 2023 20:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjF0AhX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Jun 2023 20:37:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47587171A
        for <linux-raid@vger.kernel.org>; Mon, 26 Jun 2023 17:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05CE60FBC
        for <linux-raid@vger.kernel.org>; Tue, 27 Jun 2023 00:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412BDC433C9
        for <linux-raid@vger.kernel.org>; Tue, 27 Jun 2023 00:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687826241;
        bh=ve+BG8GwWygp4Xl+A26EcKCErfYV5NPqHBeY38lOvIM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o88uFeqlL1vHqvxXR69X6XBc10prvWUHvm3VYzxOUabMKRUGLk8IlCZqr66RGpig6
         AWxz7Cd1Wad08EZ/UHNfNQ4Rvyf+rg5q+rYf22TWr9fqJk6ZweRGUQsps7zjjjg/QK
         hileSIOcd26yJR+B/+RjwfYMiCjcwx715sUiuJ1hX4MJ7Ch9Vv5c5GmAdjx+M/DEAr
         lZU2VSslVdB+HHj8BrOzrYkppWkTle/aRmE1yFM1vLGQDwglX9pJBkYs1YCiQUymvK
         PaNAobkZ+uQATUqH28lwM/6hXX1WebRf3h0g7aWxS49SNwL/T+KcabSoxJS/8K0swb
         Nl++QE8vbp+AQ==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b69dcf45faso29140251fa.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Jun 2023 17:37:21 -0700 (PDT)
X-Gm-Message-State: AC+VfDwJk76fRRFvuuOEou5DVLKRMdX0pzfsJKwPJWC8Uwq9QSkN+UXp
        DbraCtvzt8iyzwMjQmE/acOzD9IJMtMKOeayOQA=
X-Google-Smtp-Source: ACHHUZ42cP52yavSxblfZn/vfrcmZfAE1MKYv0BQPwlYOZ1bt9UPG1sFef4wai9F3hR6B1lhT3Jd9VMAroOqa7Z0vaA=
X-Received: by 2002:a05:6512:3455:b0:4fb:7447:e71a with SMTP id
 j21-20020a056512345500b004fb7447e71amr2545987lfr.63.1687826239319; Mon, 26
 Jun 2023 17:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com> <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com> <20230626155143.GA4180@lst.de>
In-Reply-To: <20230626155143.GA4180@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 26 Jun 2023 17:37:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4PEK5Vu7G2KjF739Hbj-qZtVEwQ6x2WKw3frypX_bdLA@mail.gmail.com>
Message-ID: <CAPhsuW4PEK5Vu7G2KjF739Hbj-qZtVEwQ6x2WKw3frypX_bdLA@mail.gmail.com>
Subject: Re: [GIT PULL] md-next 20230622
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <songliubraving@meta.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Christoph,

On Mon, Jun 26, 2023 at 8:51=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Fri, Jun 23, 2023 at 03:08:52PM +0000, Song Liu wrote:
> > Please let me know if you need set #1 (deprecate file bitmap) to
> > unblock other work. Otherwise, we will delay it until 6.6.
>
> It was intended so that we don't have to make all of md depend on
> the new config option for buffers heads I plan to introduce.  So it's
> a bit of a pity that we won't have it for 6.5, but not a deal breaker.

Thanks for the confirmation!

Song
