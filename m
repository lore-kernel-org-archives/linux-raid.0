Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1D0C001DB
	for <linux-raid@archiver.kernel.org>; Sun, 13 Aug 2023 17:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjHMR5L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjHMR5K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 13 Aug 2023 13:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C2A10D;
        Sun, 13 Aug 2023 10:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897B460F75;
        Sun, 13 Aug 2023 17:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DB7C433C9;
        Sun, 13 Aug 2023 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691949431;
        bh=k5lD7vCeRXwPAKQRKx6H/8mU6AyZG6pRFYxxrUzGUFY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d8hgvqWMP9KJhO6evZJ7EiRTpe20swIMGOfy8NxJ2TV/uYI6r98uD4bvS+Uk0Qj/Q
         QLMvAMQjqEufCPjLpZvXjXc3ON7193u19+lKdgOo0wLS74RnhX4OP5I4r89ZLNSpCR
         uDR/EAfMixQ48IFwgm54qJzKZKi9pCvatPEVtiBcPDQI22d/H86NGL4WSBjB6GQIwM
         HMX1lrPqUXL1FYyyp/Sh6UJEU6oakgRU1CXHpmDnOBoRFUgLTrO0KDpD6V5GcbTVBs
         cxQiSEKPzyOXWgtMm20Aofm6DWOdpbuXFMW+cdVPuboXlvVrZ9hXZP7EOQQ/BNzgFE
         rjXtiPPNOiyCg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4fe0d5f719dso5876395e87.2;
        Sun, 13 Aug 2023 10:57:11 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw0i06V6Z747wfgzgVQL+Qs9JC9kf1wHKZuRO0Yf+PsISfKcP1s
        zpYhzmPzZjNvvrW7ECL4HzZ2ynHUuOiYSRwi2Jc=
X-Google-Smtp-Source: AGHT+IFC45xBypdazAR+t+jNSc9y+vXI+XuaBvQngfXKCFRqNc4wEehRJPJfv5Tjaqap6iaeRXFIEILnGSyHN7Fc0D0=
X-Received: by 2002:a05:6512:3b1:b0:4fe:589a:857d with SMTP id
 v17-20020a05651203b100b004fe589a857dmr4578778lfp.34.1691949429853; Sun, 13
 Aug 2023 10:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1691592775.git.heinzm@redhat.com>
In-Reply-To: <cover.1691592775.git.heinzm@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 13 Aug 2023 21:56:56 +0400
X-Gmail-Original-Message-ID: <CAPhsuW7Huk5aEzVwGjyjHQhZ88N+Fyprdwb3jZ+0oNyBc23TUw@mail.gmail.com>
Message-ID: <CAPhsuW7Huk5aEzVwGjyjHQhZ88N+Fyprdwb3jZ+0oNyBc23TUw@mail.gmail.com>
Subject: Re: [PATCH 0/3] md raid1: Fix writebehind/writemostly
To:     heinzm@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        ncroxon@redhat.com, xni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 10, 2023 at 4:12=E2=80=AFPM <heinzm@redhat.com> wrote:
>
> From: heinzm <heinzm@redhat.com>
>
> Writemostly was only respected if set on the first leg.
>
> Set on any other leg(s) but not on the first one did
> not enable writebehind at all.
>
> Fix changes the logic using the already defind bool writebehind.
>
> Whilst on this, also make first_clone a bool as write_behind for
> consistency and add an empty line.
>
> Patches pass the MD test suite.
>
> heinzm (3):
>   md raid1: allow writebehind to work on any leg device set WriteMostly

1/3 looks good. But please resend with your full name.

>   md raid1: make first_clone a bool
>   md raid1: add empty line

2/3 and 3/3 are not necessary. I would rather keep git-blame clean.

Thanks,
Song
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Tested-by: Xia Ni <xni@redhat.com>
>
>  drivers/md/raid1.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> --
> 2.41.0
>
