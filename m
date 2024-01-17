Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720528694
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705535802; cv=none; b=MSrc2W6xXAgNGhqjtVIu6DFQoAd980+wcTEvScJBENa3LGhoQVBy/jeNc2JM/Flnd3EW1gDl151hZpKYsqNrxk+G10V6E98wDqE0gmP/MCdOtP2cfbdQzewwy6ceEPCRWGCxF1VJqG0zFVeMzOVYiiAjIOPGQR/F4XteHxpkqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705535802; c=relaxed/simple;
	bh=CntgxQaTxh0EgJQZSkevz0FGLV1FUcxwwWCbwLmDIFA=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=dmQNNEwpTtrOalHpifgR0HUUtgA93TLLPr3ao+C/7HxX94RIe7Ea45jnKjQ0ZGLPObyZUs4xnvOj0NMsrZjJBp6JWgEhLsv+rkp0TvgMl+0s03gteWzB601SrxUwnGFYkkPcUPhMImX8VWIVBpS3V1IxOa6wtWb9TdxM+lA5a1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwCQw/Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwCQw/Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B3BC43390
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705535801;
	bh=CntgxQaTxh0EgJQZSkevz0FGLV1FUcxwwWCbwLmDIFA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NwCQw/FjHhdLsAIp1Zv22WICcwvjnrYCobWz1W5LVCAuRq1e3g78KR1Lslw2zVWu3
	 UDjDVui6/8vMAryGsAYLTy8eLoshltIlNyF63vZIjiB2Zcag+aKegxf/X09adlAodh
	 e/EaSKrj9c22e5AYp9wIJ2v6zdpQCFdfFXS3NwabtAP5K6KWunJQYk4yx/9kluLg2W
	 Oyjs0tSs2RgFF+EiGyiOVQvpnR3gGcJ9qajpJFF9cd36gCnebVas0+L1by7mBhd6sS
	 LRwazS5hByxbNOtzru6LFDIsx3wb1f3ktmd5UIATbF9158yod4ztnMBzfQbCc/MdmI
	 zkvR1mHrz63cg==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2cdc1af60b2so45406611fa.1
        for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 15:56:41 -0800 (PST)
X-Gm-Message-State: AOJu0YwaKOSml+dpkfqPbz/PmdXX8R84EzI6U9fqYYqDSBiFMsu+xs7o
	qhvRMYtk0/y7hhYcF+MfiyeMLeQeEMP1dVwXNfSic98KJsh1iQfAPJDuIOtap/Eq5ozfTe7v0oI
	MCRuAWctJ7EckRMLA3hoZqDsn/Qc=
X-Google-Smtp-Source: AGHT+IFevecB3RKZJ082rjSepGH825X82msrGFOiERkUV6eFHKmnViXa2C1kjlzgGSRNjZ+s7Pu+Oeoq204euuGtsUo=
X-Received: by 2002:a2e:9d99:0:b0:2cc:a72c:9d with SMTP id c25-20020a2e9d99000000b002cca72c009dmr20135ljj.37.1705535799617;
 Wed, 17 Jan 2024 15:56:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <b725da99-d649-6f1d-af82-c3e482f7f6e@redhat.com>
In-Reply-To: <b725da99-d649-6f1d-af82-c3e482f7f6e@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jan 2024 15:56:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5xnJZWDg5XiD5-5z4312PUJipYq+H3q-V2A-N5+M7SzQ@mail.gmail.com>
Message-ID: <CAPhsuW5xnJZWDg5XiD5-5z4312PUJipYq+H3q-V2A-N5+M7SzQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] md: partially revert "md/raid6: use valid sector
 values to determine if an I/O should wait on the reshape"
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:22=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
[...]
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: c467e97f079f ("md/raid6: use valid sector values to determine if a=
n I/O should wait on the reshape")
> Cc: stable@vger.kernel.org      # v6.1+
>
> ---
>  drivers/md/raid5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/raid5.c
> +++ linux-2.6/drivers/md/raid5.c
> @@ -5851,7 +5851,7 @@ static bool stripe_ahead_of_reshape(stru
>                         continue;
>
>                 min_sector =3D min(min_sector, sh->dev[dd_idx].sector);
> -               max_sector =3D max(max_sector, sh->dev[dd_idx].sector);
> +               max_sector =3D min(max_sector, sh->dev[dd_idx].sector);

This looks wrong. max_sector was initialized to 0, so
min(max_sector, sh->dev[dd_idx].sector) will always be 0.

Did I miss/misread something here?

Thanks,
Song

>         }
>
>         spin_lock_irq(&conf->device_lock);
>
