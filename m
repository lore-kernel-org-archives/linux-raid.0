Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C86C433F5
	for <linux-raid@archiver.kernel.org>; Sat,  1 Jan 2022 23:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiAAXtd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jan 2022 18:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiAAXtd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jan 2022 18:49:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C88C061574
        for <linux-raid@vger.kernel.org>; Sat,  1 Jan 2022 15:49:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2A6ACE091F
        for <linux-raid@vger.kernel.org>; Sat,  1 Jan 2022 23:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8E3C36AEA
        for <linux-raid@vger.kernel.org>; Sat,  1 Jan 2022 23:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641080969;
        bh=Kg0l4QOkb0N1l1b71GQMzSgEmwnqLdz6DXspOjH05tg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b/F1qQEuZl0+n9xtBr/hOS9mb79dktFlGOkaZZpUaSTGIvOSCGkgE+xg0JmeJHKwb
         lWpLTwnI/HptNIDdwxcGKAR4dcbYc4ud+ic6AqjmxL4K2DsOk8NQI6mVwpwAbItU69
         v1yU/dWqcz6VPTqDghBN8qoOix3dBNHdP2kIirYZUv4xsa1+oi/utt0PBwFFTWQeUH
         5ccx5IPeuBrI2D4sUIBHRtn6eqQWvzti2J2gQuezj7ZCL2hkuUGgAr3PhYF1BtSv7r
         xCAcC4WBk4WkcFcYdefNl4UTc9sAEbfOH2k5MqjNCspC7kwrpy/1tUhNYhAL9w+2zS
         /Umb9vv6J9bUQ==
Received: by mail-yb1-f172.google.com with SMTP id d201so65383856ybc.7
        for <linux-raid@vger.kernel.org>; Sat, 01 Jan 2022 15:49:29 -0800 (PST)
X-Gm-Message-State: AOAM532ngZzG3N8KLOimWgUDN0eH6Q4V4ISR6RU+87ej6MS+Xn2EBAe7
        tvTddYdE27F9jz+zCSfMSTDdD6904U5Jj7yeg0Y=
X-Google-Smtp-Source: ABdhPJypYpdF0N1gJWAsMg6d2GmNA2L0VoFG6X8FQAAWy8z99daMX2Xkl7oQOnvzjMXZBRvzp76/Z2KraYT8EkGAcXU=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr52134464ybq.47.1641080968213;
 Sat, 01 Jan 2022 15:49:28 -0800 (PST)
MIME-Version: 1.0
References: <20211229223407.11647-1-dmueller@suse.de>
In-Reply-To: <20211229223407.11647-1-dmueller@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Sat, 1 Jan 2022 15:49:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7N-_v7ivE6SXphgXiA4An0kruF+W25QrFhO15fkUZYfg@mail.gmail.com>
Message-ID: <CAPhsuW7N-_v7ivE6SXphgXiA4An0kruF+W25QrFhO15fkUZYfg@mail.gmail.com>
Subject: Re: [PATCH] Skip benchmarking of non-best xor_syndrome functions
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 29, 2021 at 2:34 PM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> In commit fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
> a xor_syndrome() has been added for optimized syndrome calculation and
> being added also to to the raid6_choose_gen() function. However, the
> result of the xor_syndrome() benchmarking was intentionally discarded
> and did not influence the choice.
>
> We can optimize raid6_choose_gen() without changing its behavior by
> only benchmarking the chosen xor_syndrome() variant and printing it
> output, rather than benchmarking also the ones that are discarded and
> never influence the outcome.
>
> For x86_64, this removes 8 out of 18 benchmark loops which each take
> 16 jiffies, so up to 160 jiffies saved on module load (640ms on a 250HZ
> kernel).

How critical is 160 (or 128?) jiffies saving here? I think some users use t=
hese
information from dmesg, which shows an overview of all these algorithms:

[   21.629694] raid6: avx2x4   gen() 18081 MB/s
[   21.799692] raid6: avx2x4   xor()  8568 MB/s
[   21.969692] raid6: avx2x2   gen() 15060 MB/s
[   22.139792] raid6: avx2x2   xor()  9665 MB/s
[   22.309718] raid6: avx2x1   gen()  9223 MB/s
[   22.479691] raid6: avx2x1   xor()  6809 MB/s
[   22.649691] raid6: sse2x4   gen()  9647 MB/s
[   22.819691] raid6: sse2x4   xor()  6229 MB/s
[   22.989690] raid6: sse2x2   gen()  7276 MB/s
[   23.159690] raid6: sse2x2   xor()  5400 MB/s
[   23.329761] raid6: sse2x1   gen()  4734 MB/s
[   23.499693] raid6: sse2x1   xor()  3565 MB/s
[   23.500225] raid6: using algorithm avx2x4 gen() 18081 MB/s
[   23.500886] raid6: .... xor() 8568 MB/s, rmw enabled

If it is critical for some use cases, maybe we can gate the change with a
CONFIG?

Thanks,
Song



[...]
