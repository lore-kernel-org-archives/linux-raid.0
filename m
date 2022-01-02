Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8B0C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jan 2022 00:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiABAD5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jan 2022 19:03:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiABAD5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jan 2022 19:03:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F6760C56
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694E4C36AEA
        for <linux-raid@vger.kernel.org>; Sun,  2 Jan 2022 00:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641081836;
        bh=3mBOXqOa1ALYQpkRg514rvxYoSjTHYhTB9g0LCX56js=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z8IprquoOoBQK0CQ/nbWwtoTzSMMUDZvRJy01QSYjR2DFssgX0EMaERk5w7FEMscA
         /M05uJHyFp7xbpUf6N3NN/Hh54cOv3jbki04q1gi1fgAtj04eVstDMBtiLZnnHXutA
         IO0BhP/ChxC4xtj9pVCQqMWWUMLm/al14JdsOgnu1FH+dk8Y63iUUjnXx3QrRhLTyU
         AJebNXkl3Rn7rPfWwz8NX/JDa6C8l21ie7UG2zAEf/7S3rfCAzrTYQQsVUCe0zqtpc
         uyfOgYA6yC8aBiIp1uEyowZKsy8AxZLDjXctbNsGdCEysG+wnK5rOF8fU5eL8w82si
         pR93OH8xFgnaA==
Received: by mail-yb1-f176.google.com with SMTP id 139so57779352ybd.3
        for <linux-raid@vger.kernel.org>; Sat, 01 Jan 2022 16:03:56 -0800 (PST)
X-Gm-Message-State: AOAM531UaIP3r0EdDrVr9FiWseKNcLGQzmKTzim7faIoOwmYfWdkaRHF
        mXQqqbmPrkmXwGup9dvCTmXUB62b8F9zMUImtHo=
X-Google-Smtp-Source: ABdhPJzRX5iQhOO90Yt9z6miDiKVYe4SKW2dztUqJAuEWXlxY6cwj0HaiPobxzawWO4/xaz/SZN1QEKX1q54T9z98nc=
X-Received: by 2002:a25:8e10:: with SMTP id p16mr38990382ybl.219.1641081835476;
 Sat, 01 Jan 2022 16:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20211229223600.29346-1-dmueller@suse.de>
In-Reply-To: <20211229223600.29346-1-dmueller@suse.de>
From:   Song Liu <song@kernel.org>
Date:   Sat, 1 Jan 2022 16:03:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6+kfUFoJNQVbTnWPaqPZECnwEUXf6q7FbSQpJGtMMsYg@mail.gmail.com>
Message-ID: <CAPhsuW6+kfUFoJNQVbTnWPaqPZECnwEUXf6q7FbSQpJGtMMsYg@mail.gmail.com>
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
To:     =?UTF-8?B?RGlyayBNw7xsbGVy?= <dmueller@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 29, 2021 at 2:36 PM Dirk M=C3=BCller <dmueller@suse.de> wrote:
>
> On x86_64, currently 3 variants of AVX512, 3 variants of AVX2
> and 3 variants of SSE2 are benchmarked on initialization, taking
> between 144-153 jiffies. Over a hardware pool of various generations
> of intel cpus I could not find a single case where SSE2 won over
> AVX2 or AVX512. There are cases where AVX2 wins over AVX512.
>
> By giving AVXx variants higher priority over SSE, we can generally
> skip 3 benchmarks which speeds this up by 33% - 50%, depending on
> whether AVX512 is available.
>
> Signed-off-by: Dirk M=C3=BCller <dmueller@suse.de>
> ---
>  include/linux/raid/pq.h | 2 +-
>  lib/raid6/algos.c       | 2 +-
>  lib/raid6/avx2.c        | 6 +++---
>  lib/raid6/avx512.c      | 6 +++---
>  4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 154e954b711d..d6e5a1feb947 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -81,7 +81,7 @@ struct raid6_calls {
>         void (*xor_syndrome)(int, int, int, size_t, void **);
>         int  (*valid)(void);    /* Returns 1 if this routine set is usabl=
e */
>         const char *name;       /* Name of this routine set */
> -       int prefer;             /* Has special performance attribute */
> +       int priority;           /* Relative priority ranking if non-zero =
*/

We need  more explanation/documentation about 0 vs. 1 vs. 2 priority.

>  };
>
>  /* Selected algorithm */
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 889033b7fc0d..d1e8ff837a32 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -151,7 +151,7 @@ static inline const struct raid6_calls *raid6_choose_=
gen(
>         const struct raid6_calls *best;
>
>         for (bestgenperf =3D 0, best =3D NULL, algo =3D raid6_algos; *alg=
o; algo++) {
> -               if (!best || (*algo)->prefer >=3D best->prefer) {
> +               if (!best || (*algo)->priority >=3D best->priority) {
>                         if ((*algo)->valid && !(*algo)->valid())

If the module load time is really critical, maybe we can run all
->valid() calls first and
find the highest valid priority. Then, we only run the benchmark for
these algorithms.

Does this make sense?

Thanks,
Song

>                                 continue;
>
> diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
> index f299476e1d76..31be496b8c81 100644
> --- a/lib/raid6/avx2.c
> +++ b/lib/raid6/avx2.c
> @@ -132,7 +132,7 @@ const struct raid6_calls raid6_avx2x1 =3D {
>         raid6_avx21_xor_syndrome,
>         raid6_have_avx2,
>         "avx2x1",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>
>  /*
> @@ -262,7 +262,7 @@ const struct raid6_calls raid6_avx2x2 =3D {
>         raid6_avx22_xor_syndrome,
>         raid6_have_avx2,
>         "avx2x2",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>
>  #ifdef CONFIG_X86_64
> @@ -465,6 +465,6 @@ const struct raid6_calls raid6_avx2x4 =3D {
>         raid6_avx24_xor_syndrome,
>         raid6_have_avx2,
>         "avx2x4",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>  #endif
> diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
> index bb684d144ee2..63ae197c3294 100644
> --- a/lib/raid6/avx512.c
> +++ b/lib/raid6/avx512.c
> @@ -162,7 +162,7 @@ const struct raid6_calls raid6_avx512x1 =3D {
>         raid6_avx5121_xor_syndrome,
>         raid6_have_avx512,
>         "avx512x1",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>
>  /*
> @@ -319,7 +319,7 @@ const struct raid6_calls raid6_avx512x2 =3D {
>         raid6_avx5122_xor_syndrome,
>         raid6_have_avx512,
>         "avx512x2",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>
>  #ifdef CONFIG_X86_64
> @@ -557,7 +557,7 @@ const struct raid6_calls raid6_avx512x4 =3D {
>         raid6_avx5124_xor_syndrome,
>         raid6_have_avx512,
>         "avx512x4",
> -       1                       /* Has cache hints */
> +       .priority =3D 2
>  };
>  #endif
>
> --
> 2.34.1
>
