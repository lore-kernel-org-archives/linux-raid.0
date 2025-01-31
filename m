Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D11465AE
	for <linux-raid@vger.kernel.org>; Fri, 31 Jan 2025 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738349122; cv=none; b=E5O9ncmMShUuTR2P3lM953lzFlzJBwx0Uz2pRJtEQ+DPdLGIIDc9UH2AmatAXhWpiqQQTtEEKclK5n+SwNDESutwxTLNK0+5syHoqA6PBv6OUI4HkmHYrpjTSQHX8y6pBqWLaawIewyIxq6u17d5ZHeqFAr7Rf9Fr3S/JsK4KSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738349122; c=relaxed/simple;
	bh=7Gcj349xoGFsk243B4V0q+Sw7wCTTG570EbvILOgtHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+h80SpgQ2ajCVf19n3G6l3NX1mdRSrfbGgtoAxxqTkXUIM3TCS8tHYW4VdnL7bpfmslyv8KMBHP1biLcN7jrhRP4R/jNOXPUSX5hjX9iDw3yA2RVF3ZSYmnzp/eg+5BTDp+3jwm8klBVXKSuaLkMjCKuwKdQdqifB68hRoMLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obzvss9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obzvss9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627CBC4CEE3
	for <linux-raid@vger.kernel.org>; Fri, 31 Jan 2025 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738349121;
	bh=7Gcj349xoGFsk243B4V0q+Sw7wCTTG570EbvILOgtHw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=obzvss9W0n1Wq98qR6Y0XT9kWkEYXjS4XhJukKRFy+cJtkBT1QIZ4blFEG4ja7uyV
	 dynY+BmCdMSWdfiaUDq5LwcFzujza7SOx+Z6iQ0m7xjuSQblMQdA+nj6eLZG1zTPn9
	 3VXi6O9ytN7E119w63DQPQzD0ZW5mG9C7yqbvPt9IDFbSLuEP2672+L0KRkhkhlSD8
	 EsBhkQ/xXZKtxfLq8RI1vXM7ltKIm5sEaFkQafYtIJoqNcLwSG1arMrTPfSkTIUFmg
	 yIqCEsgvF60ITCZIa1/LL2ij+1Jb0L+DN07LPASwk0w+j6OFk0GBwe+joE+p6VswAq
	 aliMmi9eR4LfQ==
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a7dd54af4bso5615315ab.2
        for <linux-raid@vger.kernel.org>; Fri, 31 Jan 2025 10:45:21 -0800 (PST)
X-Gm-Message-State: AOJu0YwFG0XLSIfnR8SfMLJg1R71UE1WDl8ZdToNuA1VHomkB66Roiqt
	f7wX/I6t6njYiA49+ZBaUonT+naGjKRJaYsGIR2L2vKumawIuhaymrtDnM+ZA1xO3QSW8IgaYsC
	4Q4I3CPyvtGPHwdALt0sMmcfVdds=
X-Google-Smtp-Source: AGHT+IHLEmx6bdWVuMRXvVjQv1wo2wcuWaV8CPkUGq9Fha0PacSKPWorNvB1mtGf1JKFFm5d9LNd6g5EI0IL6LF0Ufs=
X-Received: by 2002:a05:6e02:13a1:b0:3cf:b012:9f9d with SMTP id
 e9e14a558f8ab-3cffe406acdmr90328875ab.14.1738349120792; Fri, 31 Jan 2025
 10:45:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250129225636.2667932-1-bvanassche@acm.org>
In-Reply-To: <20250129225636.2667932-1-bvanassche@acm.org>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Jan 2025 10:45:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW78=-NYAw6nSif7U7hFJytREjO9xyKZVROYvAYjRTefHQ@mail.gmail.com>
X-Gm-Features: AWEUYZl5uYQkkudCwtNKl1YkKTSs0FFOS7nKXMUOEzU2KxbK8EyuawN9sXMJmHI
Message-ID: <CAPhsuW78=-NYAw6nSif7U7hFJytREjO9xyKZVROYvAYjRTefHQ@mail.gmail.com>
Subject: Re: [PATCH] md: Fix linear_set_limits()
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>, 
	Coly Li <colyli@kernel.org>, Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 2:57=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> queue_limits_cancel_update() must only be called if
> queue_limits_start_update() is called first. Remove the
> queue_limits_cancel_update() call from linear_set_limits() because
> there is no corresponding queue_limits_start_update() call.
>
> This bug was discovered by annotating all mutex operations with clang
> thread-safety attributes and by building the kernel with clang and
> -Wthread-safety.
>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Coly Li <colyli@kernel.org>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 127186cfb184 ("md: reintroduce md-linear")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Applied to md-6.14 branch.

Thanks for the fix!
Song
