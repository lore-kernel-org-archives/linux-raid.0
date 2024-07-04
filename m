Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30413E024;
	Thu,  4 Jul 2024 07:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076780; cv=none; b=GsA05AMLfXmdNLawEO13TWn4BTj+OreoAM0oCCFIRh4RneZuS5r8gzu/5awq6tHm24G8GvDRcm/96r2Dgpzq9cMwEiT7/mjs/HqcZkaPM3PAdgHinxxTFJGznCCt+Ia54ENHzi7v1ghXCbCAzKNe34sUOGZRq19HDoFXzDzZIM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076780; c=relaxed/simple;
	bh=eQja1fLxAv1f9SgFUIb9Pfd4QJ0VBgTRl8pVuhbzKVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JgsUuoLeaqUdj+AZMzGxJrdys/u6DPbeI1k5D6kuNetr1WmNm7LPnu/bHVDQO+cgaTyMHEnu8D6RhvuQqlCwsw2R9xDqsGan6jbsFCrjTERpNc+A3Vn+gGmH5bNUBKh6bBkG6w3xyf4OH/YEoTVL1P5Aoy5ffIZb54ZyaVQXaIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcbL9JA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcbL9JA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C2EC32781;
	Thu,  4 Jul 2024 07:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720076779;
	bh=eQja1fLxAv1f9SgFUIb9Pfd4QJ0VBgTRl8pVuhbzKVY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hcbL9JA2VKRektr+G1rksSYrGywbBlDWdmwHNCPj+ErRX/5kMH9pVETlPJQ6i+WeZ
	 Y47YdHiJA/mck4ZjRKqPYTBA+Zu2LUMP1O8qN2a38CGHdK34PhssCUc+MpSFAIcLRS
	 9+8tH6j/tOjxPP04nLOxrhzcqjl7KDMP+tNPkL8682wbKnXVJXc3gLULWMrraAtBHL
	 5dTpIjx5OvBhAk/mdvXRYk1XCsxe8t9tYVrmk/QOQ/HwlqafPz1irX6JYR+j/qOe2R
	 Qfe6gCHB3YAPD67/V/dLiksM8aStGZjLPY9UZy4+Apn3alk6N2EzcPXJuWTmgHvzJ6
	 1FuZUfBy+MKcQ==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52e9a550e9fso1236628e87.0;
        Thu, 04 Jul 2024 00:06:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUSb/hFz2YSTJDipUW2ETwtHlNtQZj5apbBY/HS13yarcpU4KtZBEgFDk4ShKVGFqNT6s+KOAURptT6dkSP+j4/8eRPaYGX200wW4gqKZZ4Q7PNwltmfX47fTHI9mMs4sGnl8T439IF6w==
X-Gm-Message-State: AOJu0YyuUj2+ss9DEi6xtLjksOItAhQ+BYJ3WOzY3K3YPXodgPMh1ZA7
	/70tfwn1Gz8n1qaiT9QyJFM/rQN9VDcX2IfO00yscSVc1ypE67zvE4yvOJ2MFdcn4jHeF4Yyr+C
	vqeRS3ZjqiiBL97I+JjCZXtalXV8=
X-Google-Smtp-Source: AGHT+IF5qtPztYOuqUtiBA+EILwCIXKWWBw3R6CDfVGEfYhL3dlISUQZPeTdWUDOFp0IzSHws13+XXpfaExzo4ZeRrI=
X-Received: by 2002:a05:6512:509:b0:52e:9558:167c with SMTP id
 2adb3069b0e04-52ea0de3c18mr146112e87.10.1720076778068; Thu, 04 Jul 2024
 00:06:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240615085143.1648223-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240615085143.1648223-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 4 Jul 2024 15:06:05 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5_29Y0TCz3bUU_g5QtjdLK7+qu3cYuy9XG1OikpMcZkA@mail.gmail.com>
Message-ID: <CAPhsuW5_29Y0TCz3bUU_g5QtjdLK7+qu3cYuy9XG1OikpMcZkA@mail.gmail.com>
Subject: Re: [PATCH -next] md/raid5: fix spares errors about rcu usage
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2024 at 4:52=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> As commit ad8606702f26 ("md/raid5: remove rcu protection to access rdev
> from conf") explains, rcu protection can be removed, however, there are
> three places left, there won't be any real problems.
>
> drivers/md/raid5.c:8071:24: error: incompatible types in comparison expre=
ssion (different address spaces):
> drivers/md/raid5.c:8071:24:    struct md_rdev [noderef] __rcu *
> drivers/md/raid5.c:8071:24:    struct md_rdev *
> drivers/md/raid5.c:7569:25: error: incompatible types in comparison expre=
ssion (different address spaces):
> drivers/md/raid5.c:7569:25:    struct md_rdev [noderef] __rcu *
> drivers/md/raid5.c:7569:25:    struct md_rdev *
> drivers/md/raid5.c:7573:25: error: incompatible types in comparison expre=
ssion (different address spaces):
> drivers/md/raid5.c:7573:25:    struct md_rdev [noderef] __rcu *
> drivers/md/raid5.c:7573:25:    struct md_rdev *
>
> Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from=
 conf")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.11. Thanks!

Song
