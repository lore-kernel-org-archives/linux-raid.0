Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E953EC7EE22
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 22:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjDXWad (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjDXWaX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 18:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252AF6185
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F70B6204F
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F83C4339B
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682375421;
        bh=DDlRBnZdm/0L33gsMA5bSfU1FAb4SEkWVXh0SI0ajVE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u9ISjouFVc9JmOTspP9f+SIdbJVXMRJzZKHsV6lldaFG17ih/r384PJWI6o+dntbY
         pMAxNk1mH5z3t7sOXXeU/7Rb41ff0FLhsswtMts4ne02Ijy3VB0nAMUVs6QHt+HFD3
         j9SOaqoijG+K9svBfrG+jhS5RJM2f9fAHaYG5hCF624AF2RRIPDMqyp+8jxZ9g/qP7
         B5c1ByudNysGLmTEwBd4oTh9jbNGCQzv8VjOTvkKSPPMM3q0xSYB6XCmhfJc3Xmn8j
         9BLmTDJ53ocxc7FRL5ZK5kJwYk7Ls3KmC8V2TaSfDs3FGPmjr7IZ/ECGSEoxl+IwZH
         PWQgEiQF7TU2g==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2a8dd1489b0so47885011fa.3
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 15:30:21 -0700 (PDT)
X-Gm-Message-State: AAQBX9evpVuVqIPgWVkOQIJggYUCjFX+jat1YplClsjIrGkwTWZ59tnv
        z5LMxI0aC/ACsdML9/qH48O/Ixgl+HHMRSjXO5k=
X-Google-Smtp-Source: AKy350YZ+Q9CYpvl6QfzRnfRx+ZABnkBoAnnTdR9ww6+uGEuMXGSpU4bpv01JaQF/a2gpQtFQ6lanbB/HAuuCC56vlA=
X-Received: by 2002:ac2:5507:0:b0:4eb:1527:e2a7 with SMTP id
 j7-20020ac25507000000b004eb1527e2a7mr3589426lfk.45.1682375419975; Mon, 24 Apr
 2023 15:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230417171537.17899-1-jack@suse.cz> <9a1e2e05-72cd-aba2-b380-d0836d2e98dd@deltatee.com>
 <CAPhsuW76n5w7AJ5Ee6foGgm4U2FpRDfpMYhELS7=gJE5SeGwAA@mail.gmail.com>
 <20230420112613.l5wyzi7ran556pum@quack3> <c5830dd8-57c5-0d94-a48d-d85f154607e0@deltatee.com>
 <CAPhsuW5aaaTL1Ed-wKb82DKSSqg+ckC0MboaOLSUuaiGmTYTuA@mail.gmail.com>
 <e6343cab-01e3-77da-8380-137703344768@deltatee.com> <ZEYllY6ZHZX+q9ZC@infradead.org>
 <ad936a03-5f9e-7465-3565-7902069bd5fc@deltatee.com>
In-Reply-To: <ad936a03-5f9e-7465-3565-7902069bd5fc@deltatee.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Apr 2023 15:30:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Phg_Oy18YWH7vgUuywyW2F932Fvcw2FyiZZyqZb3ZCg@mail.gmail.com>
Message-ID: <CAPhsuW6Phg_Oy18YWH7vgUuywyW2F932Fvcw2FyiZZyqZb3ZCg@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-raid@vger.kernel.org, David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 24, 2023 at 8:41=E2=80=AFAM Logan Gunthorpe <logang@deltatee.co=
m> wrote:
>
>
>
> On 2023-04-24 00:45, Christoph Hellwig wrote:
> > On Thu, Apr 20, 2023 at 02:10:02PM -0600, Logan Gunthorpe wrote:
> >>> I am hoping to make raid5_make_request() a little faster for non-rota=
tional
> >>> devices. We may not easily observe a difference in performance, but t=
hings
> >>> add up. Does this make sense?
> >>
> >> I guess. But without a performance test that shows that it makes an
> >> improvement, I'm hesitant about that. It could also be that it helps a
> >> tiny bit for non-rotational disks, but we just don't know.
> >>
> >> Unfortunately, I don't have the time right now to do these performance
> >> tests.
> >
> > FYI, SSDs in general do prefer sequential write streams.  For most you
> > won't see a different in write performance itself, but it will help wit=
h
> > reducing GC overhead later on.

Yeah, this makes sense.

>
> Thanks. Yes, my colleague was able to run performance testing on this
> patch and didn't find any degradation with Jan's optimization turned on.
> So I don't think it's worth doing this only for rotational disks and
> Jan's original patch makes sense.

I will ship Jan's original patch.

Thanks,
Song
