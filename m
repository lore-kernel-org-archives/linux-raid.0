Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7452115F41B;
	Tue, 27 Aug 2024 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724778613; cv=none; b=U+CQEVxWF2gJtgKO7TCTZUyAO8PWgblFMB8dAbeG86S5wca7oTUZUkdmV8fuBMSQJF+RUb9soWwYJ4IhkseekjtIsNuoa0R2Eovw4U13W71R7EZ9xIPr92ZPp88kfcxPbpJ44zi7hjmUqblkDrBugwoNrkvrAdqbaEiG20Izu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724778613; c=relaxed/simple;
	bh=/yYN24ZmWE1bMgHvCTd8EhmhAXDxt7CjMjdElVpgh8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QG6/kHOYcaZyIZ1aIyn6mopYxA+h8XlfWxdMmWhLjfCUCiuPggiryXmV5xDs/QcIl9iYOUru0CFfBH0R8PQPD0fm3KrQOViMKfzfp+BtImCbzHuiUfF+rXsrdk7HQV/OgMcweAj1UkVvh7dssLWhh26fZiLKEqCIdLVwHsqR9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJzuNJcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJzuNJcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8572C4DDF6;
	Tue, 27 Aug 2024 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724778612;
	bh=/yYN24ZmWE1bMgHvCTd8EhmhAXDxt7CjMjdElVpgh8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EJzuNJcdyapmo1faVpdzBcZqREHjhOQdNOSz13rOFdR3i45oCUOMzVlC+vek1yXUc
	 EKKC7v7dGjK/+7y3tN4yK3+QLiMDygupq5OtmcSnFmbanmV76tgvwyp30WYd8rMNgJ
	 AyAS4CKDjbtqlzf+NNMFROjcxiuQiE1pBmVJwK6xiJDfo1dwe6DyH6nQOe7FqbtXHC
	 z0RgEpvwkprqBdjdbRVCiOFRCVgNa1+B2IIcvd20RjVZ1bFtnYhZ0MklaD375qCRBZ
	 qikrCmi2nFgM+pm6BcYchlWrzW3ivza+cGYMkor9kkpScMOoePymaBIaiud3s6RXwV
	 8qeXsXBDaBusw==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39e6a1e0079so1600135ab.0;
        Tue, 27 Aug 2024 10:10:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCULaGwcA2H6Yn5Zpefgp8tzGHei5jlZKeSbdHdPk3mGb9keEoqWdsKxBdz6vKzFNSrhOww6BfnKP/X/v1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMWqb/M3+MiYO02BCQx4PgQl1OOPxbMph7TQ3lh4WAREPc+ua2
	cwVxx/iuyCxF2pCzT5FvHB62De61I33LyF5apVG+J1zswsNmgZ1irrO6EjXv6e73cESmgFXL7mK
	CL3LQvDbS8Oa7ojDkkpLPJ2B+dgk=
X-Google-Smtp-Source: AGHT+IEACKAm8gd9IfusHNODoBKsa0qU0YXMxZI57NHjrgFuZ61gHCxNHY6oxfDpY5p9uRNJiykdlUoGor97rS69P6o=
X-Received: by 2002:a05:6e02:1a2a:b0:39d:50c9:26ea with SMTP id
 e9e14a558f8ab-39e3c9c075amr170045615ab.19.1724778612266; Tue, 27 Aug 2024
 10:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801133008.459998-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240801133008.459998-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 27 Aug 2024 10:10:01 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6pKYcu5pN8PnQn_-d1ZT4PAtKHycFAs-3UfMueM1Lzhw@mail.gmail.com>
Message-ID: <CAPhsuW6pKYcu5pN8PnQn_-d1ZT4PAtKHycFAs-3UfMueM1Lzhw@mail.gmail.com>
Subject: Re: [PATCH -next] md/raid1: cleanup local variable 'b' from radi1_read_request()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 6:33=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> The local variable will only be used onced, in the error path that
> read_balance() failed to find a valid rdev to read. Since now the rdev
> is ensured can't be removed from conf while IO is still pending,
> remove the local variable and dereference rdev directly.
>
> Since we're here, also remove an extra empty line, and unnecessary
> type conversion from sector_t(u64) to unsigned long long.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.12. Thanks!
Song
