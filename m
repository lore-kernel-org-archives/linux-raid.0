Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB3AC4363A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 07:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911A120665
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 07:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601883854;
	bh=sfcAq4S+fOBj3CxSLR+VJ3dm2GrpNVp78wUemLwqHFs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=APti5qEhzSYEVHFgkBPTiQ9UIOf9z5O53lrJhkLR9loP7fUaev1vFXqjszxVnZ3oo
	 jv7iuVNGnlrhIk6BUO/Nx2iwOw5rwhQlYh/kgcKA3gH7b6EimDR87BsoxB/GA/Aebx
	 rcTDmvOVNjhvON4WQrnJaWMZqkSDeJbATZXpD26s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgJEHoO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 03:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJEHoO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Oct 2020 03:44:14 -0400
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FD220665
        for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2020 07:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601883853;
        bh=sfcAq4S+fOBj3CxSLR+VJ3dm2GrpNVp78wUemLwqHFs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=riY8REX6BEBJ5mo8v8zg5Cu79bZbZPlIbg4Coh1nLdaF9Dya7GfrnKcTikAruXjx8
         rau7WQxaljhzIG1uwC0iMj/ZDcTBqkNa6jox3/O8dZ8sm4OWgL7lEg15afrs/uE91f
         zVdg7v13hB8XwnjQ7Jp00Uo6ayjDL7ZIQuIBSIpA=
Received: by mail-lf1-f52.google.com with SMTP id a9so286106lfc.7
        for <linux-raid@vger.kernel.org>; Mon, 05 Oct 2020 00:44:13 -0700 (PDT)
X-Gm-Message-State: AOAM533Y/kSrO2pcLLMNaIVPhDYKpg7J7gWxvDbUC8KAad4GY4eMHcKE
        cJTF6yV5nsa6YNdGIjrOGDxvHSHZzi2prYMzJzI=
X-Google-Smtp-Source: ABdhPJy03bW1CNXs28dswX94eDbFZjNplbfwpM7iIj0HN8ha4TzYaufM670zp6m0vRvrZ/9pDjf3MSIUpITIHe8eLgg=
X-Received: by 2002:a19:40c:: with SMTP id 12mr3365306lfe.193.1601883851674;
 Mon, 05 Oct 2020 00:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <1601741492-17696-1-git-send-email-heming.zhao@suse.com> <51da8823-aed1-dc45-d14e-3b30c8f88aa0@suse.com>
In-Reply-To: <51da8823-aed1-dc45-d14e-3b30c8f88aa0@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 5 Oct 2020 00:44:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6sWyJ60iEtY2yuFbKYwC6DN-ZaC2rOwo2OykWrHYidsw@mail.gmail.com>
Message-ID: <CAPhsuW6sWyJ60iEtY2yuFbKYwC6DN-ZaC2rOwo2OykWrHYidsw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [md/bitmap] md_bitmap_read_sb use wrong bitmap blocks
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Oct 3, 2020 at 9:26 AM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> very sorry for my mistake.
>
> the patch should be change from:
> ```
> -               sector_div(bm_blocks,
> +               DIV_ROUND_UP_SECTOR_T(bm_blocks,
>                            bitmap->mddev->bitmap_info.chunksize >> 9);
> ```
>
> to
> ```
> -               sector_div(bm_blocks,
> -                          bitmap->mddev->bitmap_info.chunksize >> 9);
> +               bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
> +                          (bitmap->mddev->bitmap_info.chunksize >> 9));
> ```
>
> If my patch would be accepted, I will send v2 patch including above lines.

Please send v2 of the patch. Please also CC Guoqing in v2.

Thanks,
Song
