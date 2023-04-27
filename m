Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AD7C77B73
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjD0Rpk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 13:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbjD0Rpi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 13:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C039949C9
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 10:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 445C063EC2
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 17:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03BCC4339C
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682617516;
        bh=cOqWvHGZXTJYnL3WDCS+axbyFi4vdTquH5zS8d4j9Tg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Bzk9kfr5o9G7JszjbM0dsBw3kBim0ex6PSC62vdepz7yXKGbehOiw7mpEwIkwE2Qn
         eLortiyB7mavKOz9OuMJaI6CEjv4vyS2b3GNbGlDeLd95v2OtLTc76U+Uk70GJPvFX
         g4IL7hYZq5DRCxtmABcpNlNSAIeFdo5dNIGlGM+4de+9wSC7XTtOfgJL3xggck0lXM
         P/b8nOn/Blqs0TtrTwpIUPE7T6Ev+1wMXIugqAyEHGSDrpZQFzKCOy0OpgX6rmRIi0
         djU/7oLWBHRlYFum03CcYlH1iI/qSdJALceAl+d+3shIAM8kIhCC1WoUzpTHT3T40A
         pV6nuhvwlmoNw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f0025f4686so3535023e87.3
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 10:45:16 -0700 (PDT)
X-Gm-Message-State: AC+VfDzjeiV68NGKbcfUqYUfXXje2JWSJkcVRHX4EDfKBdYtYQ5IEIoW
        rmrqNUXN37dEHn1lAM2SqPpZFZ4SmyZRiTPMd98=
X-Google-Smtp-Source: ACHHUZ6OWIOhMNiXzrFyEYdkXyxjdGRirItcqWk9CXqGYlTzaY1EAP8C/gyYJsPllxrz3jub4zhj6hIzjYFazlj+hW8=
X-Received: by 2002:a19:f714:0:b0:4ec:9f36:9b5c with SMTP id
 z20-20020a19f714000000b004ec9f369b5cmr893263lfe.68.1682617514554; Thu, 27 Apr
 2023 10:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230425011438.71046-1-jonathan.derrick@linux.dev>
 <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
 <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com> <5a4cba40-6f3a-e5dc-0398-4dd7489de9d8@huaweicloud.com>
In-Reply-To: <5a4cba40-6f3a-e5dc-0398-4dd7489de9d8@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 27 Apr 2023 10:45:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW68kkYW_F7u3RZyq+K9VOF1iCb3Y6c+xY_URS+_uXYMZw@mail.gmail.com>
Message-ID: <CAPhsuW68kkYW_F7u3RZyq+K9VOF1iCb3Y6c+xY_URS+_uXYMZw@mail.gmail.com>
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Jonathan Derrick <jonathan.derrick@linux.dev>,
        linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 27, 2023 at 2:35=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/04/27 1:58, Song Liu =E5=86=99=E9=81=93:
> > Hi Jonathan,
> >
> > On Tue, Apr 25, 2023 at 8:44=E2=80=AFPM Song Liu <song@kernel.org> wrot=
e:
> >>
> >> On Mon, Apr 24, 2023 at 6:16=E2=80=AFPM Jonathan Derrick
> >> <jonathan.derrick@linux.dev> wrote:
> >>>
> >>> Bitmap offset is allowed to be negative, indicating that bitmap prece=
des
> >>> metadata. Change the type back from sector_t to loff_t to satisfy
> >>> conditionals and calculations.
> >
> > This actually breaks the following tests from mdadm:
> >
> > 05r1-add-internalbitmap-v1a
>
> After a quick look of this test, I think the root cause is another
> patch:
>
> commit 8745faa95611 ("md: Use optimal I/O size for last bitmap page")
>
> This patch add a new helper bitmap_io_size(), which breaks the condition
> that 'negative value < 0'.
>
> And following patch should fix this problem:
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index adbe95e03852..b1b521837156 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -219,8 +219,9 @@ static unsigned int optimal_io_size(struct
> block_device *bdev,
>   }
>
>   static unsigned int bitmap_io_size(unsigned int io_size, unsigned int
> opt_size,
> -                                  sector_t start, sector_t boundary)
> +                                  loff_t start, loff_t boundary)
>   {
>
> > 05r1-internalbitmap-v1a
> > 05r1-remove-internalbitmap-v1a
> >
>
> The patch is not tested yet, and I don't have time to look other tests
> yet...

Thanks Kuai! This fixed the test.

I will add your Signed-off-by to the patch. Please let me know if you
prefer not to have it.

Song
