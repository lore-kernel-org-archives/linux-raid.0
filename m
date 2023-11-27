Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9822DF91
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 23:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTiw86ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C009DC433CB
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701127318;
	bh=oKnbllMAAkvDXG82wUF7zT+BWof1jpVZ8QZinnczaYs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oTiw86ouiTMYQydjde7CdoYnNKKimoHRa3f43FHOboOVkWrvcp+D9wI8UfOXPO1JZ
	 gsWZeQpK04gVTLjyZGPJpvudJmxS1SZ13nO7+nllISXhbEr2st85WSudDTTiUcvb4u
	 tvmfyvf9jqyt0UKib2oaEB69vBaPoBOcaqn79UzGc4Edtq5ul+x9MkAfB8tg6Wfl/2
	 Y4NupJc5aHbVQ05xWaeIAB6/g75otRHygjA1q91GEPovAGY0YXPgDslP1t0Ya1sPrG
	 4hGCKceQBPIGXVe41aAoH4nVemaQjpFl9UPiFisQngCHwmSnzwksICWsU2cxYWJftl
	 D45ASkBGONgYQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50bb8ff22e6so133191e87.0
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 15:21:58 -0800 (PST)
X-Gm-Message-State: AOJu0YxEyI9j8T5oEbf+kG8ftwflvlAueXH9xUIHJBPbrIyeClqnrUuN
	5c3PbMeB6xHCNJ2tJcDcpDJl/wtr2t6I/4lNzeE=
X-Google-Smtp-Source: AGHT+IED/ZyWGYphlId7pgY4uu3pWt1mkRInttKypH4wykvGVGx825T5pNEMuUgCvWonJkAjZrxkFyS6oV1/Gj/G4lA=
X-Received: by 2002:a05:6512:31c6:b0:50a:6fb8:a0c0 with SMTP id
 j6-20020a05651231c600b0050a6fb8a0c0mr4699007lfe.19.1701127316941; Mon, 27 Nov
 2023 15:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
 <ZWQ63SpjIE4bc+pi@infradead.org> <20231127042148.3b9bee3f@peluse-desk5>
In-Reply-To: <20231127042148.3b9bee3f@peluse-desk5>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 15:21:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7Rnf+tyYN=9pKg6avSi8=ab-XnGW0-O2AxdpMTiBFdKw@mail.gmail.com>
Message-ID: <CAPhsuW7Rnf+tyYN=9pKg6avSi8=ab-XnGW0-O2AxdpMTiBFdKw@mail.gmail.com>
Subject: Re: [RFC] md/raid5: optimize RAID5 performance.
To: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yiming Xu <teddyxym@outlook.com>, linux-raid@vger.kernel.org, 
	paul.e.luse@intel.com, firnyee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 4:21=E2=80=AFAM Paul E Luse <paul.e.luse@linux.inte=
l.com> wrote:
>
> On Sun, 26 Nov 2023 22:44:45 -0800
> Christoph Hellwig <hch@infradead.org> wrote:
>
> > Hi Shushu,
> >
> > the work certainly looks interesting!
> >
> > However:
> >
> > > Optimized by using fine-grained locks, customized data structures,
> > > and scattered address space. Achieves significant improvements in
> > > both throughput and latency.
> >
> > this is a lot of work for a single Linux patch, we usually do that
> > work pice by pice instead of complete rewrite, and for such
> > signigicant changes the commit logs also tend to be a bit extensive.
> >
> > I'm also not quite sure what scattered address spaces are - I bet
> > reading the paper (I plan to get to that) would explain it, but it
> > also helps to explain the idea in the commit message.
> >
> > That's my high level nitpicking for now, I'll try to read the paper
> > and the patch in detail and come back later.
> >
> >
>
> For sure the paper provides a lot more context. Is there more
> performance data avialble, like a general sweep of various IO sizes,
> patterns and queue depths?  ALso, what kind of data integrity testing
> has been done?

Echo comments from Christoph and Paul. Also, please run
./scripts/checkpatch.pl on the patches before sending. It will catch a lot
of issues. Please also clean up the code before sending the patches.
Something like the following should not be included in the patch.

+       // new_bmclocks =3D kcalloc(num_bmclocks, sizeof(*new_bmclocks),
GFP_KERNEL);

Thanks,
Song
