Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4691E16C6A8;
	Wed, 28 Aug 2024 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724889063; cv=none; b=rU+StTHGV9ZwdZ7OGmfF76FzyLv+TTQzZAOfE/cle9l4ggN67OS1F6uvxkZQdZH+oOFb+g/mdQtN4bx8N5NMx9fvMZ1RQ/v0F9Mc0sdTIXz0Ij6CVhbkWbUVNZWz7hqsowFvrm+IZrRZuAKmYN+mSxiBF1/bWmcIlb7xe4PXAZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724889063; c=relaxed/simple;
	bh=DRnNojKC7WQjxHFnDqN8dI3/mCF24t9OoDFKRIAPFjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djJkiBDEHb9rmS/HVXLctnRg90anrihEwHVyXzKT1QCx4AnQsz10S4ze7BIhUevNuy3sQ/+r9zZRdp3ao6D44jw1yqQ5B/iSASUqk3j6w5do4VGiKOm2Xu2Si89cd/1DCnm6im7ohDrtO71+0vK57GYycYafrH3GuDWdeKImAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+DatUe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+DatUe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA9BC4CEC0;
	Wed, 28 Aug 2024 23:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724889062;
	bh=DRnNojKC7WQjxHFnDqN8dI3/mCF24t9OoDFKRIAPFjs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=C+DatUe3Xp0SLwHMhVeIZszlk1dgWhl9IzIbGDo8YqzOAzK24JoQhKSrnxH1MFDto
	 +SnRGaxhpx2Np3fLt/P7cH1q0RQyLRLNSJtX6mH2njDZ1/zsJ/fWz+hwueNP9YjJwZ
	 n/cxTE9PJyr5T3a7fxz3CYkGxpr6JK0hvcQ3V7852dC9q/z+UlvodQiATLDZuKI0iS
	 9kuAZ8YybHLd5wXNaGzZR0pZph2K2ykqPAr0QsSDwpA9Ju/EXF9DKHYbMRrp8nrjk6
	 M7HsZbJ2sYQSB7rKdy8JCce0mtO8yB5q6dwq3S2FJs0bszPx7+ENeZMuGx4w5dXRZq
	 Bpb2ggQX7Cy+Q==
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-39d2cea1239so13545ab.3;
        Wed, 28 Aug 2024 16:51:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVSPbMSiaEGTeV4gMyjnd1XL8Y9oY2YQePm6JhzUprOKeeudKezC4dW5nKU1Gk8WQx2EHnsozbQq75vr+A=@vger.kernel.org, AJvYcCVn7ewor96eo7ZVeqlRyB1xCZqnYfebJtHC6mTQliSDYh3Czx2BVJwfAxjMaaIKR7Llu6fvjbrmiEYmSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/6b3it8MJl+j7otz5M0eUZbY6kKLlBPMHDnHz9zUN+CN12zkO
	Su6rFKKmUXc6C235zaLAi0B863V0kGiKdPxvz/DBjTBorxbxFV1CiZgxjv98q3w9IRuwliylUqv
	eY4qZVdjyDz8BlRxNfpO672P7cBo=
X-Google-Smtp-Source: AGHT+IGrJuaH17tmiyZTKvDH+tpaH2D60ekM3SgxgxpQN3HDEzAPFzCRg6/bpQ8/P0GqoLsMhM6zKEy92iJsUP85rnU=
X-Received: by 2002:a05:6e02:1e09:b0:39e:38f6:d006 with SMTP id
 e9e14a558f8ab-39f377e0c13mr16790535ab.9.1724889062269; Wed, 28 Aug 2024
 16:51:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
 <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com> <5efeec29-cf13-a872-292c-dd7737a02d68@huaweicloud.com>
In-Reply-To: <5efeec29-cf13-a872-292c-dd7737a02d68@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Wed, 28 Aug 2024 16:50:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7NrAHt78kb0Yz16HvgX1KhJPX4Jjt_D4-L5J7hTraX_A@mail.gmail.com>
Message-ID: <CAPhsuW7NrAHt78kb0Yz16HvgX1KhJPX4Jjt_D4-L5J7hTraX_A@mail.gmail.com>
Subject: Re: [PATCH md-6.12 v2 00/42] md/md-bitmap: introduce
 bitmap_operations and make structure internal
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, xni@redhat.com, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 6:15=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/08/28 4:32, Song Liu =E5=86=99=E9=81=93:
> > On Mon, Aug 26, 2024 at 12:50=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> > [...]
> >>
> >> And with this we can build bitmap as kernel module, but that's not
> >> our concern for now.
> >>
> >> This version was tested with mdadm tests. There are still few failed
> >> tests in my VM, howerver, it's the test itself need to be fixed and
> >> we're working on it.
> >
> > Do we have new test failures after this set? If so, which ones?
>
> No, there are new failures.

I assume you meant "there are _no_ new failures.

Applied the set to md-6.12 branch.

Thanks,
Song
