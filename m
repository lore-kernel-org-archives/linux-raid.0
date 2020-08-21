Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159FFC433E1
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D323021734
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597986446;
	bh=zt39uJ5P85KjeakeHOCIMoGFGKxtIl+EbG3ZaiKxzEs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MWs2X4jvDRaV0gSr76qYBNGVbrJP1vUgVki/Ivd9UitsgUOALYgJim4j/MS4B8fC4
	 lMjL4LgKFmuBpwc+q6kNYuoandBLmY/dy172MjO3TGWerEKit/yDhBHfh9kxClR3fk
	 JuNggoFrxugMchGfwnhrEkyXOqVRNA2yMaf5Dhmk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgHUFH0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 01:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUFHZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Aug 2020 01:07:25 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA7021734
        for <linux-raid@vger.kernel.org>; Fri, 21 Aug 2020 05:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597986445;
        bh=zt39uJ5P85KjeakeHOCIMoGFGKxtIl+EbG3ZaiKxzEs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EORpXmCWM1lnFEen4P588aKaMG4oFGUYfBnvgC1yFiMq+/86PKGKXyJnr1MX0wNU4
         VdibkwKqwhyT4TgglLdTAaS388gNPNylAK+kdgnTWtOiR0i0U7faxLpfRtFf6T1m8V
         wIQg1Xmclc/hYLMVnfuK55gtuQY0IEOmMxCL1wG8=
Received: by mail-lf1-f50.google.com with SMTP id d2so317124lfj.1
        for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2020 22:07:24 -0700 (PDT)
X-Gm-Message-State: AOAM530PMebXeO/vVX7dn4ZhCEGiaOCQ+BEXzIcD880ypBblzn8/LYki
        Pc53sBVdMjMAhYdo3TOUk+JxY3HsH3fladVBAPE=
X-Google-Smtp-Source: ABdhPJwQRS78TDQzWVZJ3bFxMvVx/TQ6G9FKQ+RIhUUoWaE/C5CFzUNkQUaySfUU4psjqhChwVupw6vl9kBww5N8afg=
X-Received: by 2002:a05:6512:3087:: with SMTP id z7mr610469lfd.52.1597986442986;
 Thu, 20 Aug 2020 22:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200820132214.3749139-1-yuyufen@huawei.com> <CAPhsuW473fmPDanrHYwG6NxU3Ai7kd8oo6siKo4A4j1w-pi7rg@mail.gmail.com>
In-Reply-To: <CAPhsuW473fmPDanrHYwG6NxU3Ai7kd8oo6siKo4A4j1w-pi7rg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Aug 2020 22:07:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6+1_=HsYNWAT7mXvH4mVoh-XX9vDY8EPr1ko3ocRmYJg@mail.gmail.com>
Message-ID: <CAPhsuW6+1_=HsYNWAT7mXvH4mVoh-XX9vDY8EPr1ko3ocRmYJg@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Save memory for stripe_head buffer
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 20, 2020 at 10:04 PM Song Liu <song@kernel.org> wrote:
>
> On Thu, Aug 20, 2020 at 6:21 AM Yufen Yu <yuyufen@huawei.com> wrote:
> >
> [...]
> >
> >  Patch 8 ~ 10 actually implement shared page between multiple devices of
> >  stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
> >  system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.
> >
> >  We have run tests of mdadm for raid456 and test raid6test module.
> >  Not found obvious errors.
>
> Applied series to md-next.
>
> I noticed there is another case where we allocate page for
> sh->dev[i].orig_page in
> handle_stripe_dirtying(). This only happens with journal devices.
> Please run tests
> with journal device.

Btw, I only applied 02-10 to md-next. 01 is applied to md-fixes. It
should get to
md-next from upstream.

Thanks,
Song
