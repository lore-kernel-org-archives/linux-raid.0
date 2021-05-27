Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656F9C4707F
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 14:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4684761248
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 14:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhE0OLm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 May 2021 10:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhE0OLl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 May 2021 10:11:41 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C82C061574
        for <linux-raid@vger.kernel.org>; Thu, 27 May 2021 07:10:08 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 82so713539qki.8
        for <linux-raid@vger.kernel.org>; Thu, 27 May 2021 07:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rtbhouse.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XYP27hIqxJdhOEUW0+LHHK2wm1I4It0ZQOmm3vAmBU4=;
        b=dwyrqlIJR5pMh4hK8Mvz13JoRS3AZgZfNMug9zy58x4z9CLOYqY9maxpfXNdLyD4Mg
         dislximTrjpCpqiGLaERmk96NMnMzdO0P8LHUXXQ575otlYGp0s7SUErRE1UK++CsaUV
         Q2du/oiPQWl8IA/OT2iZKE6nNwp74C8rZdcl6wJL+Yel+W+eVtIe1s2GQ3sTpTkSed9f
         jNJ0paoZdfz6ROYxjW2BfUoqy6IcexUPDTr0eNARMZrgqFF76Accq62lFWk5hwTOx2o2
         VUXA9+P9bDkhInP8s1tH5+wvXRglGVLPZeJlAtZtHJjpjzLkX9GirUc7CH7ql2Ed8n8r
         HFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XYP27hIqxJdhOEUW0+LHHK2wm1I4It0ZQOmm3vAmBU4=;
        b=F7koaq+akcOnDbXSbzdwhNm9tXvK0jpHtJF6XosFea7LsxrIQjBTyTrVkSPnbRsZgc
         c2bLPd3EaCLRVD7i5PWFJRGWcRsMe0rLI7AYHdS8UYTtqTCcxVCGSUFyxABrfE6lcBo5
         QhTSYSRoI2FsIcBi9MNsxdglGbcjSwzdP+fTlIB0qxPR9i/eeuIbeQTJgXUuAbrEoubj
         hAdVg8e/BrDWwP+vLnfERJLx0ZJZWekvBWORR97gHeN/tcPVvFPgS0j0Nf3LgNvGdkuX
         KXob09gwX8Ifj4+YSEUycPPSmHAGkGeABfI4r6GobhWdghSa6BtQkn2Ksx7fZC6kzZAn
         jmVA==
X-Gm-Message-State: AOAM5314xtqha8ngzAkHHfi37bkgBthsdJNqWql5qPWQRV9OB7FmkLlk
        nWrIsoqDlMjlQ7BeQlHPtolzmI9wBeEPCBK0j36qPw==
X-Google-Smtp-Source: ABdhPJzgOxf5zzqJn6LqXlPC7thtrihsRvybCka9BHxBQWjdA88uHZpIwWWZ2K+mgieGTDrvjzT+l4ovp9jNMtte2m8=
X-Received: by 2002:a37:a387:: with SMTP id m129mr3637821qke.248.1622124607473;
 Thu, 27 May 2021 07:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn> <CAPhsuW7FuNz_stvmvPSYsSypDxJadFEUFZ6Bq1U517EK7N25Og@mail.gmail.com>
In-Reply-To: <CAPhsuW7FuNz_stvmvPSYsSypDxJadFEUFZ6Bq1U517EK7N25Og@mail.gmail.com>
From:   =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Date:   Thu, 27 May 2021 16:09:51 +0200
Message-ID: <CADLTsw3sbcODQYQKvA0dTBqw2sEuqKzoosPt0vwzD3j36HZQPA@mail.gmail.com>
Subject: Re: [PATCH V2 0/7] md: io stats accounting
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 24 May 2021 at 08:04, Song Liu <song@kernel.org> wrote:
>
> On Thu, May 20, 2021 at 5:56 PM Guoqing Jiang <jgq516@gmail.com> wrote:
> >
> > V2 changes:
> >
> > 1. add accounting_bio to md_personality.
> > 2. cleanup in case bioset_integrity_create fails.
> > 3. use bio_end_io_acct.
> > 4. remove patch for enable io accounting for multipath.
> > 5. add one patch to rename print_msg.
> > 6. add one patch to deprecate linear, multipath and faulty.
> >
> > Artur Paszkiewicz (1):
> >   md: the latest try for improve io stats accounting
> >
> > Guoqing Jiang (6):
> >   md: revert io stats accounting
> >   md: add accounting_bio for raid0 and raid5
> >   md/raid1: rename print_msg with r1bio_existed
> >   md/raid1: enable io accounting
> >   md/raid10: enable io accounting
> >   md: mark some personalities as deprecated
>
> Thanks Guoqing! This version looks great to me. No need to send v3 for
> those two minor comments.
>
> Artur and Christoph, could you please share your comments on this version
> and/or reply with your Reviewed-by tag?
>
> Pawel, could you please run your tests with this set? Note that, the test=
 should
> be run after setting
>    echo 1 > /sys/block/mdXXX/queue/iostats

I've been testing this patchset for a while (with md iostats enabled)
and no double fault occurred.

Thanks!
Pawe=C5=82 Wiejacha

> Thanks,
> Song
>
> >
