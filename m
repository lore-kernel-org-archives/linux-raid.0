Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD32B17A58C;
	Thu, 15 Aug 2024 07:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723705715; cv=none; b=KCgdudXTT7uP3IMVulfPTjJACGXkkXawFEn4sEC0L2p0dzs4DhNyT1ntS2R2+qP032VA1+RBnI8IoFt0KQelpSFxCN+cxZvqlBd7fABqNsp3mp6xSiwJJsLrRD81xzqdngxDGpm2n53JZtSdlvSwqafEP1ETtMuEuqEhTom5UMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723705715; c=relaxed/simple;
	bh=/9uqUS0s/6ZQm25v7EIai0b2CJwdxYNNykgTWLpOogY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljnx8+AMfAIPxdMShBSg2x168itN55qfsGknDGdlxaLii0UIndqDxxdj8CBA2QDzPV0pq+Q+WNtm9FL3tW/EkRg4oHWwDMCdLhlyPmw5En8BfWBMHmQ4/AbtOgumr6jNqI0wJffPpj2U+jo9VwIWfsVehRqwadzzkMkzpxwfK0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBgng+Hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBgng+Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC95C4AF0C;
	Thu, 15 Aug 2024 07:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723705715;
	bh=/9uqUS0s/6ZQm25v7EIai0b2CJwdxYNNykgTWLpOogY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KBgng+HpGUDe3ZG6ya48Sx4+rb5azJFhJeyH9WRo4MH+LvJX6VMl4F4PedM/NHZZn
	 H0HXwzZrVSvZfehn9t5UbsXSFdHgWKU96icvFPHtyB62XR4wwppjjX388tl1blQTrt
	 Ll4vltxayXVHfkyfW5++kt6x7ZiyUCnC7h6dy9zLak3C8NApdxim4xb3jkHSm5UsbV
	 aOe1PliOeFjx/pRPNkDFKS/TqF9EboAMcJROD6B/eG8H0gNDpdlMvrMmXBpszWCxy8
	 XEA22byo9zgdepZVYt4J2RZg+vX/UcIdzXkzjaFlcNRAvjzP5SXLkyUMONt0Limo6d
	 sTeEFAGZR5fOg==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52f04b3cb33so1322792e87.0;
        Thu, 15 Aug 2024 00:08:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUsZCN08wwk6Xngg38W0HXHd64/o3r9e9dnSuTor7ZQgRePw8p40kg/dpc4P8afjEojIK0GxfJ29RCj7kM=@vger.kernel.org, AJvYcCWElxXZuex5lPi1aY3qGHuKes6M9NR1qAZ5dKtTZElVsjf6fQhMhMGcDRpHA/ia+rhhstUOTlrqFbjX+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxX/Y+IWcAvcnJY/yQ9wY1xshDyb+lVN8yFFdrRwAXgt4LAi0J
	pkT/pAJAQWZHHmHte53Y2dYv16iJN/H4IkusRU0B7M+guoJAVUQhaYN/fvweigOq6iuGoa0NFfq
	dFxUdhg376cshlZ3V0YNSshrM2LM=
X-Google-Smtp-Source: AGHT+IELSNKIy7QpKKCk7VRTCXhO6UgfddrL88r6A8GddsspIypFrufySYcVIuG40JRck9nK4kXv00x11g+is2H/98U=
X-Received: by 2002:a05:6512:308a:b0:52c:d5ac:d42 with SMTP id
 2adb3069b0e04-532eda67350mr4135791e87.9.1723705713460; Thu, 15 Aug 2024
 00:08:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240716025852.400259-1-nichen@iscas.ac.cn>
In-Reply-To: <20240716025852.400259-1-nichen@iscas.ac.cn>
From: Song Liu <song@kernel.org>
Date: Thu, 15 Aug 2024 00:08:21 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5vej0oOwU8kyJmhYK5FH+=S7aoKuqv8jKa-WYKZC4gbg@mail.gmail.com>
Message-ID: <CAPhsuW5vej0oOwU8kyJmhYK5FH+=S7aoKuqv8jKa-WYKZC4gbg@mail.gmail.com>
Subject: Re: [PATCH] md: convert comma to semicolon
To: Chen Ni <nichen@iscas.ac.cn>
Cc: yukuai3@huawei.com, neilb@suse.de, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 7:59=E2=80=AFPM Chen Ni <nichen@iscas.ac.cn> wrote:
>
> Replace a comma between expression statements by a semicolon.
>
> Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery bette=
r.")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Applied to md-6.12.

Thanks,
Song
> ---
>  drivers/md/raid10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2a9c4ee982e0..e55e020b5571 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2465,7 +2465,7 @@ static void fix_recovery_read_error(struct r10bio *=
r10_bio)
>                         s =3D PAGE_SIZE >> 9;
>
>                 rdev =3D conf->mirrors[dr].rdev;
> -               addr =3D r10_bio->devs[0].addr + sect,
> +               addr =3D r10_bio->devs[0].addr + sect;
>                 ok =3D sync_page_io(rdev,
>                                   addr,
>                                   s << 9,
> --
> 2.25.1
>
