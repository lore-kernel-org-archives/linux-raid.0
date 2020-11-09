Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5248C2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F948206D8
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTmwq/xF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgKIS26 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgKIS26 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 13:28:58 -0500
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9CC7206D8
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604946538;
        bh=ZsX+e428boFEqOxL9OorejMQ9wIvouat9S88XfFO/7A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZTmwq/xF2xaDrwFNA5DnFsp/ft+MKZElY15EXUdOBNR7spIlGOggmtEdfPvwWZUVN
         vxGDQcGA4XV4RxISKd7a6r0fWwLeimbxB8QL4oTuTBEvtumyyRj/rGE/QMXaGI33z8
         pBpscM2bQY6N/QXqk3oVhi7IPPRBUiwJ4OY+9suo=
Received: by mail-lj1-f173.google.com with SMTP id r17so5939308ljg.5
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 10:28:57 -0800 (PST)
X-Gm-Message-State: AOAM533E48Xaza64ulVB049GYag+Q2M4460GZeXF3yiQ5Nv8CsYl0Nwn
        /vhSetWsPDN595ParlT+5CuYFgX55OYvYWM5OjE=
X-Google-Smtp-Source: ABdhPJzYPlaT4OzOWYE642eAszreOg91YUeKzUgEk0u8iMKoQjE9HrTzgRg5KKf5OUmBBIu0xwf211VFKGVrIfmCbxo=
X-Received: by 2002:a2e:3316:: with SMTP id d22mr1610676ljc.392.1604946536204;
 Mon, 09 Nov 2020 10:28:56 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6GqEU7BczF2tpgtEJoU5Fdh4M17N9cobhSMdVY4NPD3w@mail.gmail.com>
 <20201106222034.1304830-1-kvigor@gmail.com> <CAPhsuW5RAB8buLN9FxNX3cnJ8=5eqRpZH+FXL54FpZvjoK7x2w@mail.gmail.com>
 <CAFVaERqog8s80npb-w2g9He50=8D4-qYdCr9GicN_PU=Q5mt=Q@mail.gmail.com>
In-Reply-To: <CAFVaERqog8s80npb-w2g9He50=8D4-qYdCr9GicN_PU=Q5mt=Q@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 Nov 2020 10:28:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6UY6h=5b-dQ+fkzobVnWgpq7mQaVhTHx48UTU9zzJwZQ@mail.gmail.com>
Message-ID: <CAPhsuW6UY6h=5b-dQ+fkzobVnWgpq7mQaVhTHx48UTU9zzJwZQ@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid10: initialize r10_bio->read_slot before use.
To:     Kevin Vigor <kvigor@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 6, 2020 at 5:25 PM Kevin Vigor <kvigor@gmail.com> wrote:
>
> > How about we initialize read_slot to 0, and get rid of this check?
>
> That will definitely work properly since we memset the rdev to null in __=
make_request. But the read_slot is truly invalid until we call read_balance=
() successfully and it feels wrong to set it to a valid value even if it os=
 harmless by accident. So I prefer to give it an explicitly invalid value.
>
> But your solution saves one test in the issue path and a line of diff, so=
 I will happily change if you prefer the zero solution.

I think initialized to -1 is safer in long run.

Thanks for the fix! Applied to md-next.
