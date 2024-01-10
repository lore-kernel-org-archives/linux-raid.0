Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7834CB2C
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVi3541T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C834C433F1
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704915811;
	bh=PmjuRJKqxl0UQcGz/9qFjJ3JMpw1q+iIXOTpvKM9NRU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bVi3541TG+52dmd+aVtXikFhh8L0a1YqVCCgz/kahMxIWAymvZXc0gyIR7O2Brdf+
	 1f1iFdgH1qee+fNsD4XblOm06iSRXBHiln2YX5jVFfTgaNf3oal1HAztrk1Q+tqueI
	 h7Ts53hb71GQq+cdJeZJEXUrGa+LtlLmOWqxLSQIcJp6ir8Kke7Gr93Oa5n+1o1mxM
	 BPw65uCSplQ+x6D/JMRbSOzMCxz/i/drLXDkQxeuBn8d1izgdpfVycOejLZK4j480b
	 vKWqD0a8ICVC5IrQaeVyF3ZNvw1Ib0AJLhLGjWuxP76b0eOLMHHltelnSfqJlDhrPj
	 NRxkyfjfmjwig==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-50e80d14404so4887668e87.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 11:43:31 -0800 (PST)
X-Gm-Message-State: AOJu0Yzmw9OBUPsPnBE50Fp/kMhR2xFAFAVpGwKvrP2cfAZANhYNViSg
	iQmSjZspqF7cWaSyXrKtO+KiEHez93QwYT/GHY4=
X-Google-Smtp-Source: AGHT+IE1sHJhCYqVqnRRptveHA1C29GjHXcwEEoQ0qtdW/IA25GrFIJcLzAPoanaiOs+++koHhv0rKJFmMPJFyQM/rU=
X-Received: by 2002:a05:6512:3687:b0:50e:ab04:5675 with SMTP id
 d7-20020a056512368700b0050eab045675mr266097lfs.23.1704915809618; Wed, 10 Jan
 2024 11:43:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhsuW5YspxV-xhYdGF7HUVw=o_2PbJXMH45Y1fYRDymD8-Cqw@mail.gmail.com>
 <e6572896-39e3-44f3-b1a7-91dac1dc28ae@kernel.dk>
In-Reply-To: <e6572896-39e3-44f3-b1a7-91dac1dc28ae@kernel.dk>
From: Song Liu <song@kernel.org>
Date: Wed, 10 Jan 2024 11:43:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4A=vBTYKNOhcZbmiCBWbBZXyoK4-g1KunW1RWJno797w@mail.gmail.com>
Message-ID: <CAPhsuW4A=vBTYKNOhcZbmiCBWbBZXyoK4-g1KunW1RWJno797w@mail.gmail.com>
Subject: Re: Changes in md branch management
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>, 
	Yu Kuai <yukuai1@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 10, 2024 at 9:51=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/10/24 10:42 AM, Song Liu wrote:
> > In the past, we managed the md patches in two branches: md-next and md-=
fixes.
> > This approach has a few issues:
> > 1. It is not very clear which upstream version a patch will land in;
> > 2. Around the merge window, there is no good base for md-next.
> >
> > We will try to solve these issues with a new approach:
> > 1. We will use numbered branches like md-6.9. Patches applied to the nu=
mbered
> >    branches are planned to land in the numbered upstream release. Git c=
ommit
> >    hash in these numbered branches should be the same as their final ha=
sh.
> > 2. When there is no good base for the next numbered branch, which is us=
ually
> >    after previous rc7 and before the next rc2, accepted patches will
> > be applied to
> >    md-tmp branch. These patches are expected to be cherry-picked later =
to a
> >    numbered branch, so the git commit hash may change.
> >
> > Please let me know if you have comments and suggestions with this appro=
ach.
>
> Sounds pretty reasonable, maybe name md-tmp md-tmp-6.10 or whatever the
> case may be?

Yeah, this is a great idea.

>
> Outside of that, I like the idea of just having an md-6.9 branch. This
> can continue to roll forward post the merge window, as there really
> should only be md changes in there. Eg I can pull from that for both
> before-merge-window times and for fixes post the merge window. That one
> should never get rebased, you should just keep piling patches and fixes
> on top.

Yes, we shouldn't need to rebase any patches for the md-6.9 branch.

Thanks for the feedback!
Song
