Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8B1C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 00:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6396E61246
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 00:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhESAPx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 20:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhESAPx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 20:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6430261353
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621383274;
        bh=bSKqk6lCu9aX4BMDO9WFzCXS8grKE+f7db04HBgYEt8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NAqLGuiTxx0b3bEJvSEe6mKQWvXGp6UWFrMAeBhOv2IgjlnCAukfYw7m7XX5WuGbD
         O+RoxScO/atJAnrZrfpKR3/qgsg1o7ipgRAnmfjG6uD9cZc0TuN8jv8vsDOmduM6JA
         4XdLCBu13PtEitp4tE6TLYg2Sgtg9zz7V3TEU962RrkfekP5whgvgH7fIn9KMKP77Q
         fgLcPsa2Srka4y/JGzrECM7mUBU6CNgE9f29VY4BEp7V5IO/JEYjNFSNMKeQRkGSxO
         LtNmNIv6t7IVyJ58VOcM1hIqh/X89KlKlz8cSaRmarLDb9DWKNzt/ukwTLF7IxypQq
         jiZMcuQGChxOA==
Received: by mail-lf1-f47.google.com with SMTP id z13so16384257lft.1
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 17:14:34 -0700 (PDT)
X-Gm-Message-State: AOAM531NaL/hKz34CcQUbJXiBAXLQl2u4czcrMXysQ81UwjYxaKmWcG5
        0nVl1jR4Sn1IYOn6VJz79Ejj22M2V7X/fqpiBS8=
X-Google-Smtp-Source: ABdhPJwyyAuNp54noh/vj9Pu2fDC7HT1RaIYV/1WNdT+g4ClU/XfUS61PALj9Hlh7SYbrCcEBP75dQ8ge3d9xm4cL+0=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr2782591lfn.261.1621383272710;
 Tue, 18 May 2021 17:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
In-Reply-To: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Tue, 18 May 2021 17:14:21 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7fDEZFw6_D31GRh6U9Kh0188NOkdh5s=PsvaSpGbB5vA@mail.gmail.com>
Message-ID: <CAPhsuW7fDEZFw6_D31GRh6U9Kh0188NOkdh5s=PsvaSpGbB5vA@mail.gmail.com>
Subject: Re: [PATCH 0/5] md: io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 17, 2021 at 10:33 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> Hi Song,
>
> Based on previous discussion, this set reverts current mechanism, then
> switches back to the v1 version from Artur.
>
> Also reuses the current clone infrastructer for mpath, raid1 and raid10.
>
> Thanks,
> Guoqing

Thanks Guoqing! Please address Christoph's feedback and send v2.

Song
