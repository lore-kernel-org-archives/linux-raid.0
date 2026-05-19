Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F43DFC67
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178328; cv=none; b=nP3aKFxP/fegRSvSEIBFLj1Moxzk+41VFSuO01oayIvZeboI5WIy6daKVRoVj3Aoe3+PpOOJR0woouvnKitxQQOSuVnexUdFbtAMxQ1aUm+rxmEFhlw4Mxg/r7xLQDio6J0V2FVj9oOpRumHPFkGECPNfhQvpTqcF+pZNkAzGus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178328; c=relaxed/simple;
	bh=VcNfN1Pnu4900jOAuUKzawF2h+SQNsk/K42BGQrmElU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uNefphYG5M8e5NnCpSAseYlwhLVM0J8VZ4xdijJA1G+dOPR8DqFepBbuflftMAPvyJLLp+ijolDJrwGkBxsYAf7/KD4xXkmWrwayg0RU9w3Tl99aZQc/bsq/IZ+1DCrxVx00kIatW1buDgieI8axhlbdjsj5wcU9r1skKOxkVP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NB7NAYCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NB7NAYCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7BC2BCC6
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 08:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779178327;
	bh=VcNfN1Pnu4900jOAuUKzawF2h+SQNsk/K42BGQrmElU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NB7NAYCFHf6ruI62op+e7icyp1metQZTDLzcP6Nbj0i9lB6hWfNtNHFd6YieGoksk
	 nLgAVmMIjRIaWF8YMvm18mLLMvnMKkCp67xGPdeQrVHmMwhDXlDcc70mfc2p118cUo
	 B2j6Hm7Va3l3brOBknRDtMAM6MSj4tManI2U6ADBXm5KDnPA5jSWHraD+54zp9Gme/
	 QDk19Cu2BLJlpBX+3nd1WkfSY6CdD2Efl9DVbdEjmT8efBwCod643XgdU6cwr9wBvF
	 AWiFk7jtwLONyJvq1iecMmvwdL+4FcpUJDiMASsxTv3EsTDrnKPXZz8+VZ5vwvNCEh
	 rANac1Olxl+fg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-90d13fa59e8so342345985a.2
        for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 01:12:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9PWx1+wg5GUFfOWT7tyjYDS34rwbXvPgVDKgknI3SFN7yG5zDr/DLFhRm/Z8qQqNRiLOKNzMK6Fp/P@vger.kernel.org
X-Gm-Message-State: AOJu0YwV8Zs7eNUuCGXfW580OZulOw/x1LCJ+hYXvJNB4cQsA6I/VvK+
	haXBQYur4vyl5ZEgHf4gUYDEM4pdiVehzfaVq6fSDdzZh/Wfu44ainB3jhH1OIzAAl2bs2BLWHu
	gLiccFvUubJ4CH2TosCoRgnjkwDJXSw==
X-Received: by 2002:a05:622a:480b:b0:50e:df54:c36d with SMTP id
 d75a77b69052e-5165a057fd4mr268574231cf.18.1779178326790; Tue, 19 May 2026
 01:12:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-3-abd.masalkhi@gmail.com>
In-Reply-To: <20260501114652.590037-3-abd.masalkhi@gmail.com>
From: Xiao Ni <xiao@kernel.org>
Date: Tue, 19 May 2026 16:11:54 +0800
X-Gmail-Original-Message-ID: <CAF-RUYUsppiHu0v2gZCRYLoHRCPqJbtiass07EJJUmaLD6oz1Q@mail.gmail.com>
X-Gm-Features: AVHnY4IJa5UNF1IGQMJdIz8Hf719LHivN_VXlqR5jvulTZhEU2JRAAvyFjq96Xw
Message-ID: <CAF-RUYUsppiHu0v2gZCRYLoHRCPqJbtiass07EJJUmaLD6oz1Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, xni@redhat.com, neilb@suse.com, 
	shli@fb.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 7:48=E2=80=AFPM Abd-Alrhman Masalkhi
<abd.masalkhi@gmail.com> wrote:
>
> Detect the error path using md_cloned_bio() instead of relying
> on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
> NULL or -1 after splitting and resubmitting a failed bio.
>
> As a result, the error path may not be recognized and memory
> allocations can incorrectly use GFP_NOIO instead of
> (GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
> memory pressure.
>
> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> This patch depends on patch 1.
>
> Changes in v2:
>  - New patch.
> ---
>  drivers/md/raid1.c  | 13 ++++++++++---
>  drivers/md/raid10.c | 20 ++++++++++++++------
>  2 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index cc9914bd15c1..c52ecd38c163 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>         bool r1bio_existed =3D !!r1_bio;
>
>         /*
> -        * If r1_bio is set, we are blocking the raid1d thread
> -        * so there is a tiny risk of deadlock.  So ask for
> +        * An md cloned bio indicates we are in the error path.
> +        * This is more reliable than checking r1_bio, which might
> +        * be NULL even in the error path if a failed bio was split.
> +        */
> +       bool err_path =3D md_cloned_bio(mddev, bio);
> +
> +       /*
> +        * If we are in the error path, we are blocking the raid1d
> +        * thread so there is a tiny risk of deadlock.  So ask for
>          * emergency memory if needed.
>          */
> -       gfp_t gfp =3D r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
> +       gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;

Hi

This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>
>
>         /*
>          * Still need barrier for READ in case that whole
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3a591e60a144..8c6fc398260e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>         char b[BDEVNAME_SIZE];
>         int slot =3D r10_bio->read_slot;
>         struct md_rdev *err_rdev =3D NULL;
> -       gfp_t gfp =3D GFP_NOIO;
> +
> +       /*
> +        * An md cloned bio indicates we are in the error path.
> +        * This is more reliable than checking slot, which might
> +        * be -1 even in the error path if a failed bio was split.
> +        */
> +       bool err_path =3D md_cloned_bio(mddev, bio);
> +
> +       /*
> +        * If we are in the error path, we are blocking the raid10d
> +        * thread so there is a tiny risk of deadlock.  So ask for
> +        * emergency memory if needed.
> +        */
> +       gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>
>         if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
>                 /*
> @@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>                  * we lose the device name in error messages.
>                  */
>                 int disk;
> -               /*
> -                * As we are blocking raid10, it is a little safer to
> -                * use __GFP_HIGH.
> -                */
> -               gfp =3D GFP_NOIO | __GFP_HIGH;
>
>                 disk =3D r10_bio->devs[slot].devnum;
>                 err_rdev =3D conf->mirrors[disk].rdev;
> --
> 2.43.0
>
>
