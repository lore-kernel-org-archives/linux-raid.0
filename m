Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499423D63
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lt/J/DVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C88C433C9
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701197097;
	bh=UqTQM1vOuwdycPT7Z6WsK+9Jxqi47Jv3f5wGrMwFFlw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Lt/J/DVHhoW4ssnEtB9JtYUiIArHDoeWfPI1Kc/azEV50Zcc4+x1Fy/5C621G8zWW
	 KOjD8zAEnA0MIwTESlBTdIoNCRQIUM8YqBorFJ6SvrpDAHe2wrU3O571fqwHOPRabm
	 ps89ohJ1p9Kx3GSP2Ik1Zq46vZG+1+ywbmrcyn2tDBLYyIHIwnCF61gG7GZ+YApg+b
	 GfPyJdf5LHHQNIlpRgzOL0ZUIXGJmecGrkZ5umiGj2oXG6iNlzOYX3FJ+zrXui69sq
	 KMBlQasbMidRowjWuLcFDbofKmMLMCIBpdgVldRyd5aOju/IfXZ1xRAp7tec60+ToV
	 vwnaDsjYggaGA==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50bc395aa7fso30900e87.3
        for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 10:44:57 -0800 (PST)
X-Gm-Message-State: AOJu0YyZeRADQnmRhUuOWLcNIRnWuyTD4JIzvRlkHyjjOVl63T7ctNj6
	4fDAAyaa9etrpjJO9WlRn7K9UiC/zUYRHeZTKzM=
X-Google-Smtp-Source: AGHT+IFzpiV7VcNrvemWQ4pD5f4s8fG8sH9j7ZQ6FU7wKp66VSC33LCWKvkT7wj2X968RFoVhkfpFlUuAzrdtpBqLDY=
X-Received: by 2002:ac2:5e65:0:b0:50b:bb7d:e205 with SMTP id
 a5-20020ac25e65000000b0050bbb7de205mr1631603lfr.64.1701197095922; Tue, 28 Nov
 2023 10:44:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128181233.6187-1-djeffery@redhat.com>
In-Reply-To: <20231128181233.6187-1-djeffery@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 28 Nov 2023 10:44:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7V1H9xJ+ihC21B8S+cp4QZDz32a0YJPfELt=va3xpBZQ@mail.gmail.com>
Message-ID: <CAPhsuW7V1H9xJ+ihC21B8S+cp4QZDz32a0YJPfELt=va3xpBZQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid6: use valid sector values to determine if an I/O
 should wait on the reshape
To: David Jeffery <djeffery@redhat.com>
Cc: linux-raid@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David and Laurence,

On Tue, Nov 28, 2023 at 10:13=E2=80=AFAM David Jeffery <djeffery@redhat.com=
> wrote:
>
> During a reshape or a RAID6 array such as expanding by adding an addition=
al
> disk, I/Os to the region of the array which have not yet been reshaped ca=
n
> stall indefinitely. This is from errors in the stripe_ahead_of_reshape
> function causing md to think the I/O is to a region in the actively
> undergoing the reshape.
>
> stripe_ahead_of_reshape fails to account for the q disk having a sector
> value of 0. By not excluding the q disk from the for loop, raid6 will alw=
ays
> generate a min_sector value of 0, causing a return value which stalls.
>
> The function's max_sector calculation also uses min() when it should use
> max(), causing the max_sector value to always be 0. During a backwards
> rebuild this can cause the opposite problem where it allows I/O to advanc=
e
> when it should wait.
>
> Fixing these errors will allow safe I/O to advance in a timely manner and
> delay only I/O which is unsafe due to stripes in the middle of undergoing
> the reshape.
>
> Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for resh=
ape progress")
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>

Thanks for the fix!

Can we add a test to mdadm/tests to cover this case? (Not sure how reliable
the test will be).

Song

> ---
>  drivers/md/raid5.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc031d42f53b..26e1e8a5e941 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5892,11 +5892,11 @@ static bool stripe_ahead_of_reshape(struct mddev =
*mddev, struct r5conf *conf,
>         int dd_idx;
>
>         for (dd_idx =3D 0; dd_idx < sh->disks; dd_idx++) {
> -               if (dd_idx =3D=3D sh->pd_idx)
> +               if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
>                         continue;
>
>                 min_sector =3D min(min_sector, sh->dev[dd_idx].sector);
> -               max_sector =3D min(max_sector, sh->dev[dd_idx].sector);
> +               max_sector =3D max(max_sector, sh->dev[dd_idx].sector);
>         }
>
>         spin_lock_irq(&conf->device_lock);
> --
> 2.43.0
>
>
