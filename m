Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1111E8FDAF
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 20:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjJCUOr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjJCUOq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 16:14:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3583B9E
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 13:14:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EAEC433C8
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 20:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696364082;
        bh=Zx/ce1R7FWNf0WAEOYV0Rz6ets+fUSycMhCz+VSGID0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sI/QR744usbr3RmjsML+qZPUAWBE6ccsrraZcRMIM4FZ05p4lz/KOCX2N9DC4Yw12
         gxYF6/MIJX8IkCiaNwo9UhPVBYPLfccVVy5QsrKItU05/hlpEcDi05v1id/3og+14q
         FYUwRf8wN39C0inflFQoLhXYN3ESw3dsHTJzleT4U31OHV0vqrym7A7zXlrynB9Ah2
         AHoK8/goUROuEQPA11K2Bz81e70B/qdpeZpAXVgO0qoi81+U6QYVDszQ6pLQzK2lgM
         BZCLcIN0ckRTo57tzIo2L7Vgv5UQmRGKgWvF5k7rO8QruIb65vach3qiMFYr13PgUi
         0a/9u6MeZJs7A==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4066692ad35so13334275e9.1
        for <linux-raid@vger.kernel.org>; Tue, 03 Oct 2023 13:14:42 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy5lTv1uyR8oFECGjyxrGsKb0YLDJY6EHYsjCZu4DPaFkFJoRDD
        XEqCLH+UqGHUqhPqjP9pZL8F6PL3TVzTQERNxy8=
X-Google-Smtp-Source: AGHT+IHHXg1ju8TRR3m/6zyi28sZZ+qJPGk/tnOutq59dUpRzdk5ROBODLmKmgoo7Ne5KMyYH6vHnNSgRsBQHwFSFOw=
X-Received: by 2002:a7b:c8c8:0:b0:401:906b:7e9d with SMTP id
 f8-20020a7bc8c8000000b00401906b7e9dmr443483wml.18.1696364081150; Tue, 03 Oct
 2023 13:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20231002183422.13047-1-djeffery@redhat.com> <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
 <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com> <CA+-xHTH+59y5iqkVSTA=0fRK4RgPYp=Bm10rcbH0_fk6NZQ+TQ@mail.gmail.com>
In-Reply-To: <CA+-xHTH+59y5iqkVSTA=0fRK4RgPYp=Bm10rcbH0_fk6NZQ+TQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 3 Oct 2023 13:14:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5-kFu2EoFRCdJHc+M6aBgUGA40WYgZ2=6BDNh9+jiPRA@mail.gmail.com>
Message-ID: <CAPhsuW5-kFu2EoFRCdJHc+M6aBgUGA40WYgZ2=6BDNh9+jiPRA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: release batch_last before waiting for another stripe_head
To:     David Jeffery <djeffery@redhat.com>
Cc:     John Pittman <jpittman@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi David,

On Tue, Oct 3, 2023 at 11:50=E2=80=AFAM David Jeffery <djeffery@redhat.com>=
 wrote:
>
> On Tue, Oct 3, 2023 at 2:48=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > Thanks for the fix! I applied it to md-fixes.
> >
> > Question: How easy/difficult is it to reproduce this issue?
> >
>
> Hello,
>
> One customer system could trigger it reliably and confirmed the fix,
> but I haven't had any success recreating it with synthetic workloads
> on a test system.

Thanks for the information!

Song
