Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED312B171
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799802; cv=none; b=tcrDaW8O4DmvAWqb5xpup7xwQCs1BbGzzFVaMQuZVUFicW/s4AmlvkNg584RHzg6/N+1sukOKwAJlcQs2OO4hwWmiyqtOD6RzLFF2G+/5eLpoNpA3isLoQ6K9hV1ebJT6FCz3fJsQB0GCG3/zi/FrUrD/cpd4utn63dX00/gW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799802; c=relaxed/simple;
	bh=kK/U91Gb9WxUookDor9v/dgTnSUgGd0/hCcHXp4H670=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jV5lt5fspvgqScaxcyK/3+5XI0YY0dP4596a4HhodYi82WhPam6EZPLtt8SJk7yiEYOqrTYFw0CdaaAr/9OBf3x0FkxpIEZelGVTI98Wv/mUaQbMQG/8TzjPsDhiVHTuvqXjQIAQTUlBSdo1SvASMAv+LApveiqEocDLV0noeo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4Y/XMoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4Y/XMoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872A4C32782
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720799801;
	bh=kK/U91Gb9WxUookDor9v/dgTnSUgGd0/hCcHXp4H670=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=T4Y/XMoUGJOg5FrJ24jsrRpRojiyzS7X0WAJ1NcHcDh2lsvjVnlArP2g5Gd8vYMni
	 XwfkYOYC+VDm4XraF+xjpds5QeKbyiwUD3LtfFpvstb7d7C8uBP40HCTWMsUlrWmE+
	 sqyNrPkpu5mbwUhJwklD9WZ3eyLYnKfZvCGwej/Nubx/Kj6VSojSkOwLUgEEfP6mcD
	 DwcpctU4YlVkdQE5JoqvGVn82hKQMA5f1eDFo1YYlkk9d5t2IwwmD+ntUnsKtsJvt5
	 Fqakta6B/xHHC77yDDH4tf4rN/9ErBn7OQRMMvdh/LB7ABVmXxrcT0UMvMOwtuBbo2
	 NwpM2NZyjpcjA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52e976208f8so2449943e87.2
        for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 08:56:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXr/WZqy2J/xXli1aBSpAlsYEibnfRtHiPvSn7qm4CAzz27/nI9z/eN0OuWkHDMP/opia74E/tnunlyhE+iVk6//oprybKW2V9pdQ==
X-Gm-Message-State: AOJu0Yy76oPMALHIt5N9uM1lHZIsi2LQwaqP37d6v1kJ0QQq8EsNVb6T
	MO8OXDL1Xm3CYlszTd+C9yK8jo/jKF6mG2UgMDVVb1PgcXwZwt9/0TniQU3qPl4YuYL+LTzr2p2
	T8fLFhFrl2Sox0Itu8YKjch/SSh4=
X-Google-Smtp-Source: AGHT+IGboyDUt/4kYx3jXqMWGxoQ4u4GHxcINAzyYYdYPKostJ5O7e2RECFwrvtwJfwMeFKGSRTXzIkcAdDovgWQP88=
X-Received: by 2002:a05:6512:3d27:b0:52c:f3fa:86c with SMTP id
 2adb3069b0e04-52eb9994ac9mr9873132e87.18.1720799799949; Fri, 12 Jul 2024
 08:56:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7C787382-3238-4D49-92B1-ED09A4A59AD4@fb.com> <a2189c00-4bcf-4ded-9934-867819171a38@kernel.dk>
In-Reply-To: <a2189c00-4bcf-4ded-9934-867819171a38@kernel.dk>
From: Song Liu <song@kernel.org>
Date: Fri, 12 Jul 2024 23:56:27 +0800
X-Gmail-Original-Message-ID: <CAPhsuW4GacAMeBvLTkVmGFBT8kkFjQiFwa0O8NTkWEp1apdOcg@mail.gmail.com>
Message-ID: <CAPhsuW4GacAMeBvLTkVmGFBT8kkFjQiFwa0O8NTkWEp1apdOcg@mail.gmail.com>
Subject: Re: [GIT PULL] md-6.11 20240712
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <songliubraving@meta.com>, linux-raid <linux-raid@vger.kernel.org>, 
	=?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>, 
	Heming Zhao <heming.zhao@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>, 
	Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 11:44=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 7/12/24 9:41 AM, Song Liu wrote:
> > Hi Jens,
> >
> > Please consider pulling the following fixes for md-6.11 on top of your
> > for-6.11/block branch. Changes in this set are:
> >
> > 1. md-cluster fixes by Heming Zhao;
> > 2. raid1 fix by Mateusz Jo=C5=84czyk.
>
> I'll do this one inside the merge window, I already sent off the
> initial pull for 6.11. I've got other bits pending too, so it's
> fine, just won't go in with the initial changes.

Got it. Thanks for the information!

Song
