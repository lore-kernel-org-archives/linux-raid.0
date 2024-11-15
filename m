Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2890818F2FC
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 09:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662815; cv=none; b=H97MiVXTerWJoSfcuZY1LJAMj2QLkerMUjDVgk2EEd9sG/IiqHj0K2Kl+miMVaukHrN24ebD28nyzYU3dCzgfFmIn3Fs3d2Uj945g2wP41JhwJZPps/kVRQQsUofzxJCR8nMbrJC0JXCCxWjCP2AI7ZFrjGFEXQUA2DkSe+I3AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662815; c=relaxed/simple;
	bh=SnqacOCE+P/1qpGdUGKu4YvpCt8WAGQppyQv+ieB4VY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k5XVyylWmm/0TXxx+BY1MkMUC5c7ZTZTkaw/uzsM/LkqXbfQj0wqNNpERE7kyUoD1TtiGp5xh+uVFxEYi1Z+HVR9PORWpycrNofK9FbjIxe2J+dSiUURaxGu+KTAzwZbDKGmAa+I0O9rhU/ULVHdIgiWZSKqzZOd9Z0VqZXfiUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PxvpP4p2; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PxvpP4p2"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb584a8f81so15474891fa.3
        for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 01:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731662810; x=1732267610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIuB5rtYmXlUeZIpgK9aa2ZmaZDfoHJ3mg91aAJ96BI=;
        b=PxvpP4p2gbdvsQAwIfh0MrkLjFSpkPJ3h1Jy7Z1NhDqXMxlgbHSNy/q0ryXuDi4VkG
         o90hj5VEV4nNP1ClL4gIxIePpTxD+4EDBV75ohM8Ra3Q2NV0SnhxEApOSwJ5pb3kizSZ
         +p601DjF0H/62C3nN1bS4IK9OaIJQIYJSFybm6pbhjPjchtOL034J5yrrXYC3La7uecR
         Z901JqhRLMlLMLvK9NnN/YK3y5S6Dre357GiGW6zjfE+gegK4zhEVC+cMNLi6Y0++7QP
         MGrIP5uqhdhwNkMFD4ah20cgFXzr/z2G76fpc9XbgRhcIhVwWhwD7u2jAlEP9rwvj587
         YgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731662810; x=1732267610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIuB5rtYmXlUeZIpgK9aa2ZmaZDfoHJ3mg91aAJ96BI=;
        b=jaC+daPnqV1FRQfg590oq2YFxjvBWyRpxm4lFPtcj61uZUV3dKwFoP2vZUtl58dnlJ
         siWdL0GTYJodilNiftCsI1pYNyq9iPt0FHZsobrK+EPhuRjk96Xcz6oWZgoZM0f6diuB
         ETIUkGjF6PGT4uiog6sTFZJbQyX24+c95GoR/rkaMG0HILHLNh5XCjq73sEfFXzqx4Xq
         h5wmEqeMTDRsZ6QREtqUu5ziLkW5OilC1D/x7kGpKDV8wK/gbH4H/UPF/tQPkOT7BVCl
         +cQuHe/8vVwDlccaieJdVmp27PzqCqYOCfKu36HQWM+L75ZDhH+wpuQyjX0BFIs9ak8x
         uI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUKByRJTovv3scr9v458rctOBkYgCdZY4uGHjcj+9/3aDiGRE2blqemHI6vmciDOVSAHrI9lApzI9Rq@vger.kernel.org
X-Gm-Message-State: AOJu0YwN30cOoED7keDIBmjECgNcbGOTKB301PN24ldfPVJl4TdVGsvN
	KeyT2SNaD3jF8o+51pRP8zuBV1MvxVKUXWdV2Gz0xh0D//e04HVurE1jfQu6h6DPFOoYYU63eEl
	XZoklXsFMmAyOT8HzOuBgM5lTaR8/m89i7GtGXkWKhrzOqyr2
X-Google-Smtp-Source: AGHT+IGEgjIbEWhOVskms1PMebxiu2sjo8eOv+AzW+yIAwAAb30W536HaJrLmjfuZkyhB1srA6fPjDtavGIxAYPXH04=
X-Received: by 2002:a05:651c:411a:b0:2fb:5f9d:c287 with SMTP id
 38308e7fff4ca-2ff609b4bf8mr8266901fa.32.1731662810084; Fri, 15 Nov 2024
 01:26:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com> <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com> <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com> <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
 <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com> <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
 <6691be8d-994f-b219-213d-26557c258559@huaweicloud.com> <CAMGffE=BmZJB2orbrP6SiL=vSPz8E0JZT6OeFb7tNONCBepUEQ@mail.gmail.com>
In-Reply-To: <CAMGffE=BmZJB2orbrP6SiL=vSPz8E0JZT6OeFb7tNONCBepUEQ@mail.gmail.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Fri, 15 Nov 2024 10:26:37 +0100
Message-ID: <CAJpMwyiSsw2zr9-WYVkNJMrw8RU3Lpt-AvNHr30wor5+GpL2yg@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>
Cc: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>, Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 1:54=E2=80=AFPM Jinpu Wang <jinpu.wang@ionos.com> w=
rote:
>
> On Thu, Nov 14, 2024 at 1:19=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2024/11/14 18:27, Jinpu Wang =E5=86=99=E9=81=93:
> > > Do you want us to try the following change on top of the md/md-6.13
> > > branch without Xiao's patch and your fixup alone, or combine them all
> > > together?
> >
> > Combine them please, sorry that I forgot to mention it.
> >
> > And for md/md-6.13 there will be conflicts. So try v6.11 is better I
> > think.
> Thanks for clarification.
> I have to chery-pick the following 3 commits to apply clean on v6.11.5
>
> 6f039cc42f21 md/raid5: rename wait_for_overlap to wait_for_reshape
> 0e4aac736666 md/raid5: only add to wq if reshape is in progress
> e6a03207b925 md/raid5: use wait_on_bit() for R5_Overlap
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2868e2e20dea..6df5e9e65494 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5867,17 +5867,6 @@ static int add_all_stripe_bios(struct r5conf *conf=
,
>                         wait_on_bit(&dev->flags, R5_Overlap,
> TASK_UNINTERRUPTIBLE);
>                         return 0;
>                 }
> -       }
> -
> -       for (dd_idx =3D 0; dd_idx < sh->disks; dd_idx++) {
> -               struct r5dev *dev =3D &sh->dev[dd_idx];
> -
> -               if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> -                       continue;
> -
> -               if (dev->sector < ctx->first_sector ||
> -                   dev->sector >=3D ctx->last_sector)
> -                       continue;
>
>                 __add_stripe_bio(sh, bi, dd_idx, forwrite, previous);
>                 clear_bit((dev->sector - ctx->first_sector) >>
>
> Will report back the result.

Ran the above patches and changes, and there was no hang.

>
> >
> > >
> > > BTW: we hit similar hung since kernel 4.19.
> >
> > Good to know, I think Xiao's patch alone is fine for 4.19, the
> > BUG_ON() probabaly won't be triggered.
>
> Thx!
> >
> > Thanks,
> > Kuai
> >
> >
