Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF46EB64D8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 07:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbjFPHF0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbjFPHEt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 03:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BF32702;
        Fri, 16 Jun 2023 00:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B1262D80;
        Fri, 16 Jun 2023 07:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2C3C433C8;
        Fri, 16 Jun 2023 07:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686899048;
        bh=4KijB58FD/utAidUARnCXp0GEQshK43RRFgWQurzuuM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uy0B7DiZwAGBrmxywQNk2pnvWSvFfHQLl4+PeIMfqCi4QfH8xUxQOECcEDeJzHxtR
         8MdJbStE19EvRgLj723MlFku4CUDTJuCF+VD2JrM5Vljfk5+1DZSOlL7Cis69I+9Tk
         gD2Gwci7BEoAPHYA7GKl01keafP/jVDjbVyZkNlb3gRu2YZUU4nVPbl3+qLKC1IonY
         qP9O1HHvOFo6YVTrUh66AdyRzjPTToBVF9oLWtI1q2LosEDLd5TWhyiCBRGaMYW9Tg
         Z1cw0tGhoLCi0HLkF9MowYUiD2B1IpH05zv+BRXMuesA6T454xQwMrX1P12oYPPonb
         aeJp9BDQ4IgwA==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b41e700103so3768171fa.2;
        Fri, 16 Jun 2023 00:04:08 -0700 (PDT)
X-Gm-Message-State: AC+VfDwDpfItZiRFoiNbri/fwIEl9fuI8145X/GCIlbGsOP5ibjRlR63
        M55B06mYD5/MBSqz3qSEPxrs/92W1I8k36kuXCU=
X-Google-Smtp-Source: ACHHUZ7L6gVX3PHQMfCR6c51it2riuiygFzCH2EaPFnUUzlseRMRoQEKMaZpX0YxYkiN1RFsRfJcj3McNjp4bmGF+wE=
X-Received: by 2002:a05:651c:224:b0:2ad:bdb7:b4c3 with SMTP id
 z4-20020a05651c022400b002adbdb7b4c3mr1060544ljn.22.1686899046834; Fri, 16 Jun
 2023 00:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230614084740.1493969-1-linan666@huaweicloud.com> <5c6ff37b-4285-f62a-c910-67401b0b9c1f@huaweicloud.com>
In-Reply-To: <5c6ff37b-4285-f62a-c910-67401b0b9c1f@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 16 Jun 2023 00:03:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW54rgL-b3e-oGPsxAdd4FAJ-eEFTcpkZRi8dNxsuAheow@mail.gmail.com>
Message-ID: <CAPhsuW54rgL-b3e-oGPsxAdd4FAJ-eEFTcpkZRi8dNxsuAheow@mail.gmail.com>
Subject: Re: [PATCH 0/3] md/raid10: record rdev/replacement in r10bio
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linan666@huaweicloud.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        linan122@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 14, 2023 at 8:31=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/06/14 16:47, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> > From: Li Nan <linan122@huawei.com>
> >
> > Replacement can replace rdev during replacement io pending.
> > mirror->rdev/replacement might be changed during io pending. Get rdev f=
rom
> > it is risky. This patch series record rdev/replacement in r10bio, and g=
et
> > rdev from r10bio to fix bugs in normal write. And I want to do
> > this for each io type later.
>
> I personally don't like this, do things by half. I'm good with this
> approch for raid10, but can you send a new version to use this for all
> io?

Agreed. Please send the fix for all types.

Thanks,
Song
