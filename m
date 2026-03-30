Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFEB37BE64
	for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 16:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774888864; cv=none; b=cCJ4fIg95gvCHCcwdGWO5R7IxjZu1UwDy/b2pqtwx/6g5ljDFPpg6jpMeXfD8VIWZRGF6LxQkKhZ89QLbEw3dY1vv7buV12DiuQIHOAd3d/W9RLXu0LylZzaFK43FyskWhhIaTO5UhkZc7wFfUteG2m88CsI0wzt4g4BQl2RzKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774888864; c=relaxed/simple;
	bh=dgqJmbMdDTsNPZEZ+a2xdA+lqEFJgMxpY5Wb+INrTAI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QBMh3mmkAM+AW3ceSGQwSHyFOzMqN5kJik2+vLZjzWPcfct7GL5dkeo4WnGD8HEWKDSBPD9wdJhhOg23WETSOsnoTAg2GehE/huyeZA5BKGA8WtsIDPnM5WxgoywgzHwdA4keg0VBmnb6ErJF4rH6JUs2BJoB24zObdh/382XeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ez/Yu5QI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ez/Yu5QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710C9C4AF09;
	Mon, 30 Mar 2026 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774888864;
	bh=dgqJmbMdDTsNPZEZ+a2xdA+lqEFJgMxpY5Wb+INrTAI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=ez/Yu5QIYVdsQJ7Eo0jvpDxiuSNQ7HIenljrii5lGQoKwp7ToOqXTirFUNR3xT1Rp
	 WEAsdDezSV+XpAQ6xxBGVYLrO4nbMhWdZ1uEkpPNd90SuqwGyTCeeM4HZ9iq4DEx7j
	 xfcH2hpnTjl/p9rcoY5iGSVgkv4P2oNGArIGT5U0HOUbBfjtDYG/NjJKTxLFKeFz4o
	 0xgQNu5MxFTJ3q2LtOIoYKTPHmUrovJYS+VQOx9h9oo4spoWOo0Xlm4iS9ocKzufMo
	 XypBva+agJJYk21iKkq84oaJmQsZKtdUYur8HXeM7IajpNRvzTNxebFIbhzfmhB98P
	 2+mxZ0FuWS/hA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 546B5F40084;
	Mon, 30 Mar 2026 12:41:03 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 30 Mar 2026 12:41:03 -0400
X-ME-Sender: <xms:n6fKad-kO--PvPfJxyC57tyvKJQyLOstTTqghxtmXDw6Nvasrpq_mw>
    <xme:n6fKachgqK1d46BUc47jqdVTDvQ9K2TKhKtrU2FmuZMmEj_jMZadwwvLg4Ka376J1
    Ofc5hl2Kd5fmg7bccxwdFbWxXFz7A_-TAJ6XAJNfzWXw1RSCYxldivE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelgeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeeuteeiudeigeekjedvheduieehteetgfdtuefghfejgffhfedtleehvdeh
    fffhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhope
    hmrghrkhdrrhhuthhlrghnugesrghrmhdrtghomhdprhgtphhtthhopehrohgsihhnrdhm
    uhhrphhhhiesrghrmhdrtghomhdprhgtphhtthhopeihuhhkuhgrihesfhhnnhgrshdrtg
    homhdprhgtphhtthhopeguvghmhigrnhhshhesghhmrghilhdrtghomhdprhgtphhtthho
    pehlihhnrghnuddvvdeshhhurgifvghirdgtohhmpdhrtghpthhtohepsghrohhonhhivg
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:n6fKaXM5GGKRJbs1w30rTYE1sggut0f6P6i5JFKSLhlNt2c3OOvSGw>
    <xmx:n6fKaVq7t9V7Mp7UxZWdpUzCFPsONcn7E6LJ_Fxb--74mghvVqpAUQ>
    <xmx:n6fKae7u_JvCE4Y5EwwCbvh-wsT2LM-AAR46GEihrF_tmebPNyxqbw>
    <xmx:n6fKadHWQ4HmrUvkty2odTEvoLyDimzJOK3dbCkIjJ3k8_wge-mZnw>
    <xmx:n6fKaQ3F-GJDV7fYU425Par-sXjRUqizEHrPrS4FZqVoD8EPtuSUQDbs>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0C925700065; Mon, 30 Mar 2026 12:41:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AB98H5nyYqoB
Date: Mon, 30 Mar 2026 18:39:49 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Demian Shulhan" <demyansh@gmail.com>,
 "Mark Rutland" <mark.rutland@arm.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "Song Liu" <song@kernel.org>,
 "Yu Kuai" <yukuai@fnnas.com>, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Brown" <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 robin.murphy@arm.com, "Li Nan" <linan122@huawei.com>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
In-Reply-To: 
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
References: <20260318150245.3080719-1-demyansh@gmail.com>
 <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for syndrome
 generation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Demian,

On Sun, 29 Mar 2026, at 15:01, Demian Shulhan wrote:
> I want to address the comment about the marginal 0.3% speedup on the
> 8-disk benchmark. While the pure memory bandwidth on a small array is
> indeed bottlenecked, it doesn't reveal the whole picture. I extracted
> the SVE and NEON implementations into a user-space benchmark to
> measure the actual hardware efficiency using perf stat, running on the
> same AWS Graviton3 (Neoverse-V1) instance.The results show a massive
> difference in CPU efficiency. For the same 8-disk workload, the svex4
> implementation requires about 35% fewer instructions and 46% fewer CPU
> cycles compared to neonx4 (7.58 billion instructions vs 11.62
> billion). This translates directly into significant energy savings and
> reduced pressure on the CPU frontend, which would leave more compute
> resources available for network and NVMe queues during an array
> rebuild.
>

I think the results are impressive, but I'd like to better understand
its implications on a real-world scenario. Is this code only a
bottleneck when rebuilding an array? Is it really that much more power
efficient, given that the registers (and ALU paths) are twice the size?
And given the I/O load of rebuilding a 24+ disk array, how much CPU
throughput can we make use of meaningfully in such a scenario?

Supporting SVE in the kernel primarily impacts the size of the per-task
buffers that we need to preserve/restore the context. Fortunately,
these are no longer allocated for the lifetime of the task, but
dynamically (by scoped_ksimd()), and so the main impediment has been
recently removed. But as Mark pointed out, there are other things to
take into account. Nonetheless, our position has always been that a
compelling use case could convince us that the additional complexity
of in-kernel SVE is justified.

> Furthermore, as Christoph suggested, I tested scalability on wider
> arrays since the default kernel benchmark is hardcoded to 8 disks,
> which doesn't give the unrolled SVE loop enough data to shine. On a
> 16-disk array, svex4 hits 15.1 GB/s compared to 8.0 GB/s for neonx4.
> On a 24-disk array, while neonx4 chokes and drops to 7.8 GB/s, svex4
> maintains a stable 15.0 GB/s =E2=80=94 effectively doubling the throug=
hput.

Does this mean the kernel benchmark is no longer fit for purpose? If
it cannot distinguish between implementations that differ in performance
by a factor of 2, I don't think we can rely on it to pick the optimal on=
e.

> I agree this patch should be put on hold for now. My intention is to
> leave these numbers here as evidence that implementing SVE context
> preservation in the kernel (the "good use case") is highly justifiable
> from both a power-efficiency and a wide-array throughput perspective
> for modern ARM64 hardware.
>

Could you please summarize the results? The output below seems to have
become mangled a bit. Please also include the command line, a link to
the test source, and the vector length of the implementation.



> Thanks again for your time and time and review!
>
> ---------------------------------------------------
> User space test results:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>     RAID6 SVE Benchmark Results (AWS Graviton3)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> Instance Details:
> Linux ip-172-31-87-234 6.8.0-1047-aws #50~22.04.1-Ubuntu SMP Thu Feb
> 19 20:49:25 UTC 2026 aarch64 aarch64 aarch64 GNU/Linux
> --------------------------------------------------
>
> [Test 1: Energy Efficiency / Instruction Count (8 disks)]
> Running baseline (neonx4)...
> algo=3Dneonx4 ndisks=3D8 iterations=3D1000000 time=3D2.681s MB/s=3D874=
1.36
>
> Running SVE (svex1)...
>
>  Performance counter stats for './raid6_bench neonx4 8 1000000':
>
>        11626717224      instructions                     #    1.67
> insn per cycle
>         6946699489      cycles
>          257013219      L1-dcache-load-misses
>
>        2.681213149 seconds time elapsed
>
>        2.676771000 seconds user
>        0.002000000 seconds sys
>
>
> algo=3Dsvex1 ndisks=3D8 iterations=3D1000000 time=3D1.688s MB/s=3D1388=
5.23
>
>  Performance counter stats for './raid6_bench svex1 8 1000000':
>
>        10527277490
> Running SVE unrolled x4 (svex4)...
>      instructions                     #    2.40  insn per cycle
>         4379539835      cycles
>          175695656      L1-dcache-load-misses
>
>        1.688852006 seconds time elapsed
>
>        1.687298000 seconds user
>        0.000999000 seconds sys
>
>
> algo=3Dsvex4 ndisks=3D8 iterations=3D1000000 time=3D1.445s MB/s=3D1621=
5.04
>
>  Performance counter stats for './raid6_bench svex4 8 1000000':
>
>         7587813392      instructions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> [Test 2: Scalability on Wide RAID Arrays (MB/s)]
> --- 16 Disks ---
>  #    2.02  insn per cycle
>         3748486131      cycles
>          213816184      L1-dcache-load-misses
>
>        1.446032415 seconds time elapsed
>
>        1.442412000 seconds user
>        0.002996000 seconds sys
>
>
> algo=3Dneonx4 ndisks=3D16 iterations=3D1000000 time=3D6.783s MB/s=3D80=
62.33
> algo=3Dsvex1 ndisks=3D16 iterations=3D1000000 time=3D4.912s MB/s=3D111=
32.90
> algo=3Dsvex4 ndisks=3D16 iterations=3D1000000 time=3D3.601s MB/s=3D151=
88.85
>
> --- 24 Disks ---
> algo=3Dneonx4 ndisks=3D24 iterations=3D1000000 time=3D11.011s MB/s=3D7=
805.02
> algo=3Dsvex1 ndisks=3D24 iterations=3D1000000 time=3D8.843s MB/s=3D971=
8.26
> algo=3Dsvex4 ndisks=3D24 iterations=3D1000000 time=3D5.719s MB/s=3D150=
26.92
>
> Extra tests:
> --- 48 Disks ---
> algo=3Dneonx4 ndisks=3D48 iterations=3D500000 time=3D11.826s MB/s=3D75=
97.25
> algo=3Dsvex4 ndisks=3D48 iterations=3D500000 time=3D5.808s MB/s=3D1546=
8.10
> --- 96 Disks ---
> algo=3Dneonx4 ndisks=3D96 iterations=3D200000 time=3D9.783s MB/s=3D750=
7.01
> algo=3Dsvex4 ndisks=3D96 iterations=3D200000 time=3D4.701s MB/s=3D1562=
1.17
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>

