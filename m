Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01810C001DC
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 10:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjG2KqS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 06:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjG2KqR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 06:46:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E8B95;
        Sat, 29 Jul 2023 03:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 038BF60B7D;
        Sat, 29 Jul 2023 10:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64486C433CA;
        Sat, 29 Jul 2023 10:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690627575;
        bh=uIUPZgsmAxOZJ+qYKGSLVlFQ5D0sC53OAgZo3RHracg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HDvm84GUoaRU7zCm7y/XF4JHmqGreddPG4Ml64p/4XVAkcbie/m4c/ZiV7kXnSuSp
         jDyrCAsoGzDKU4RsWe/90ZqcFVom4AKHUSXxSzf8vRZPZ4WPezbcaRkZMjqe0oUW32
         UPSduomp3OEKZIRauMRGUKrSh3Csfp5hGOKjgTUa6kcnugttvMSuztdDETVJ+EGEhT
         tC0ZJ4I5cMGeJfCICfhIYYuCVe1TjWb7qGhut0ePLFrougiBQUOPDvfAAr9sJpJ8ih
         nwGqz5O2S5ngdgH/yJhxofxpENXp0trmylEM6ELTrRL8wNHeagQnbMLncgtYZTa1hN
         rnEja4DvjChxA==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4fe28f92d8eso515510e87.1;
        Sat, 29 Jul 2023 03:46:15 -0700 (PDT)
X-Gm-Message-State: ABy/qLZB4jD5Vp49TlgSUHH1QV4K9tI8MfMi2nwlkmo7LsMAQj8TBKna
        nQEnhfGTlSSL0gPzipPGavSR87cCuHR3Y9LygBw=
X-Google-Smtp-Source: APBJJlHVDfcRslwcpWsg7VpyTtT9qutdiRBs0Bpx3o4fJiSNl/ayk27SWI/6tYnStFJTKNoID1W3o1vVku0x3PBG6GI=
X-Received: by 2002:a19:8c57:0:b0:4fd:faa3:2352 with SMTP id
 i23-20020a198c57000000b004fdfaa32352mr2948531lfj.14.1690627573425; Sat, 29
 Jul 2023 03:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_E2C71605D88087940237AA9A44CC8D436D06@qq.com>
 <ZK7Zy2U86znezl+a@infradead.org> <tencent_0EDE0D522DF8161358B80786820BAAA5C406@qq.com>
In-Reply-To: <tencent_0EDE0D522DF8161358B80786820BAAA5C406@qq.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 29 Jul 2023 18:46:01 +0800
X-Gmail-Original-Message-ID: <CAPhsuW54pW7As-A1G4H+OWALUh7_a5+-zkLXghTh6_JjcWZoMQ@mail.gmail.com>
Message-ID: <CAPhsuW54pW7As-A1G4H+OWALUh7_a5+-zkLXghTh6_JjcWZoMQ@mail.gmail.com>
Subject: Re: [PATCH] md: fix potential OOB in multipath_remove_disk()
To:     Zhang Shurong <zhang_shurong@foxmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jul 15, 2023 at 5:45=E2=80=AFPM Zhang Shurong <zhang_shurong@foxmai=
l.com> wrote:
>
> =E5=9C=A8 2023=E5=B9=B47=E6=9C=8813=E6=97=A5=E6=98=9F=E6=9C=9F=E5=9B=9B C=
ST =E4=B8=8A=E5=8D=8812:50:19=EF=BC=8CChristoph Hellwig =E5=86=99=E9=81=93=
=EF=BC=9A
> > On Thu, Jul 13, 2023 at 12:46:05AM +0800, Zhang Shurong wrote:
> > > If rddev->raid_disk is greater than mddev->raid_disks, there will be
> > > an out-of-bounds in multipath_remove_disk. We have already found
> > > similar reports as follows:
> > >
> > > 1) commit d17f744e883b ("md-raid10: fix KASAN warning")
> > > 2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_d=
isk")
> > >
> > > Fix this bug by checking whether the "number" variable is
> > > valid.
> >
> > I think it might just be time to finally dropped the deprecated md
> > multipath code instead..
> Should I write another patch to delete them?

Yes, please write a patch to delete the multipath code.

Thanks,
Song
