Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF50B322DAF
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 02:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779329423; cv=none; b=rx6qlGL+Y9OkRwJgFQX7rveYuClCQx0TgTJkt6HJE4Nzvd5U9Y6gfulSqlVg28H3Aw1cC35KXcNVmvdOD0Sh1n2EvvEj3ygfBTtjfqR05Qk0+NNJUkMj1ilJ4fYCTNRLffpUwjsATNpULjmcX0BH8OGrjBYL6sZi7LrErh7x2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779329423; c=relaxed/simple;
	bh=eCM/KsjgvQjtD0/6RY50AQwFmdj+fBMZ3WgVIdrchsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p3oQBYy29m200cCmCxKAZ/0aRzLYIKU9P1qW2zYKq1PcnEvBA5OViuvYqxSkNXC8ATqUwv1lKKoSmwyMo1tEvlvcsKteAUnju1mbpN54DOphEiGhKmjDuJeuv1Fi0kUAQJFwPz+OTfbORy1JW2ai8L4rrPe/x7Fd3x4SMVyAhUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGj9SvcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGj9SvcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44241F00A3D
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 02:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779329421;
	bh=bqYaTbUqFf2++o3cGLQjA7/41h55AFv4bdRMdEYifi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aGj9SvcPMASFNYWOQuCtPYghx0gqIrZXdsHkPVhptfBW0snu3vZ1G8uiSKQmv/Fkj
	 M/hjft9Pll2Bf+iNE3YAVFe2kq2O9IEGgPJF34nBj97hWttfV7dxiCaGDtN66gQT2C
	 p3O9nXMbz1GRkGC5rZAsr0Snxc5uwoHukHMDYN4z/LyKQPc6ZOfg47MppKRnPsLke7
	 mpZWYP3qy7tbkqGdhuzBL62o1iDU+HcsmLEm06eHJrY2x5xWy6+hK6QrpgjgP5pRh8
	 GLQvBGpz8MRWxqoyY6tDSqQN4v4ZCyrxONBsHabn1VzB52BofQQzMAb0iMcDuFeblk
	 3ltZFpmcL+ReQ==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51306c9f2e1so67649141cf.0
        for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 19:10:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9CMA7B708DyuT+MUYSA7iUb0VotSAJXxZ2GnE9tgFD2WpxnXNiYn9HsN0SJT/0v/phIsxlSfy6cbxG@vger.kernel.org
X-Gm-Message-State: AOJu0YxFlMmkxWG3N/E4RCHC7DlEUW7rTI3R2GlFVPSUCZWFUi2Foqv1
	S+5Mt0pF9ve4zAR3SJOzjdRWutbPkRodXilt1vpTeaWKviD9+ynNx0L+0hL5Af5oq8HRSv4FXHe
	FUCIZe8di3HvHWGAzB6KAQSqTnGogbw==
X-Received: by 2002:a05:622a:488e:b0:50d:a088:b9cb with SMTP id
 d75a77b69052e-516c55e67afmr13352101cf.57.1779329421145; Wed, 20 May 2026
 19:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515093019.3436882-1-chencheng@fnnas.com>
In-Reply-To: <20260515093019.3436882-1-chencheng@fnnas.com>
From: Xiao Ni <xiao@kernel.org>
Date: Thu, 21 May 2026 10:10:08 +0800
X-Gmail-Original-Message-ID: <CAF-RUYXx6rG4A4kOwoW2oG+FkBGfQToyk91UBm6wruDyL7WaTg@mail.gmail.com>
X-Gm-Features: AVHnY4I_rYyRwBMlfMzS0LSINk2cIqoBBIWy_l4AC8xjQwgJfnNqOrXJx_vkx0A
Message-ID: <CAF-RUYXx6rG4A4kOwoW2oG+FkBGfQToyk91UBm6wruDyL7WaTg@mail.gmail.com>
Subject: Re: [PATCH] raid10_handle_discard() reuses r10bio objects from r10bio_pool.
To: Chen Cheng <chencheng@fnnas.com>
Cc: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 6:11=E2=80=AFPM Chen Cheng <chencheng@fnnas.com> wr=
ote:
>
> From: Chen Cheng <chencheng@fnnas.com>
>
> put_all_bios() always drops devs[i].bio, but it only drops
> devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
> r10bio that was previously used for a read, read_slot can still be
> non-negative, and discard cleanup can skip bio_put() on repl_bio.
>
> Reset read_slot to -1 when preparing an r10bio for discard so the
> replacement bio is always released correctly.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>  drivers/md/raid10.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 39085e7dd6d2..7dc2a5a127e8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1727,6 +1727,7 @@ static int raid10_handle_discard(struct mddev *mdde=
v, struct bio *bio)
>         r10_bio->mddev =3D mddev;
>         r10_bio->state =3D 0;
>         r10_bio->sectors =3D 0;
> +       r10_bio->read_slot =3D -1;
>         memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_dis=
ks);
>         wait_blocked_dev(mddev, r10_bio);
>
> --
> 2.54.0
>

Hi Chen

The title usually uses a format such as md/raid10: xxxx

This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>
