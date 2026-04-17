Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D124D3BD225
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776437008; cv=none; b=VG7qBCDzU+UWE/juHxulp6cyD3S4tSjlv1Oaq3TdhTCActRAVkpMCEUvLfM2X1JQ/bjtfunTlnc9Pnvs8ieuJq1V6iKrPtFM4L8VadxRfCq01J5fGTdSP1sFr6nudiPPEgloLcN3Uw8lEjkOSteYOHdtEYfOkB3z+sFVMTBzSMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776437008; c=relaxed/simple;
	bh=ibwfIFnUUlarXWt/Vd+yl4IfzjwO5SQSWOvdj5rO59o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=C1oKAuRQhhpRbnv3fH2jrA1RtB303OKiyzS5lw3N/hoKKWUHZ7W0HC/yZYxMMLHZQtk+VyFgHONQHgDCFUWduoXpg9ngyfU/qs1jp7S561Txaw9u6wPXK54jkzzl3CcDu4uO19nBRa3K3x/ZJXIteqwdLxUWJtM8CFq+VRj6TCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bl0et/Px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bl0et/Px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13F1C2BCB0;
	Fri, 17 Apr 2026 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776437008;
	bh=ibwfIFnUUlarXWt/Vd+yl4IfzjwO5SQSWOvdj5rO59o=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=bl0et/Px8pJXMVYohkGsLalYpIg6KeNK6FKl2fXKNA4s3MOwTvQR3kmz380HGDoLy
	 cXFghKjGvykoVKwg6HYj9YJR9mCYoY6o+wa9OjqYjcQ3hpSA9jEdJ1Ts0Wv5PisScn
	 OxtS1EpCayaR/JVmHLE3MxVV1cyeSlXY9qQvFO9BRr7AFb7NficY3H9htgbpSQRlWB
	 YvzfYDi0Yipy2S0Fh5j+kC+i6pAg/smHfQhn4ZFCsT/T1YTrzyQe62eDNPOsnj2Vjx
	 OyFXKEB4YFUoeM2Bp0ub7cHP3A+kycuny+lrGUK/kbJyH6B7sC+JzUxbZFcBfTrNNX
	 FUBleyHyX171Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C1901F40074;
	Fri, 17 Apr 2026 10:43:26 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 17 Apr 2026 10:43:26 -0400
X-ME-Sender: <xms:DkfiaXTbkpP5A8w4pdzr8XrAoDf0lvatJs9502j3293KdgJwHFSZfw>
    <xme:DkfiaTl8MIkb9Ui3AkHYOl7ClQfdk6seyVPhcsMTn82F7bcjnTGS-PEFUukvR4uHi
    P7EKpN1PvFR9ERtBVKxjhIIRvwYGt4Egk2Gv6uDa9g_2FJImIRx0Bc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehtdduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohepmh
    grrhhkrdhruhhtlhgrnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhhosghinhdrmhhu
    rhhphhihsegrrhhmrdgtohhmpdhrtghpthhtohephihukhhurghisehfnhhnrghsrdgtoh
    hmpdhrtghpthhtohepuggvmhihrghnshhhsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    lhhinhgrnhduvddvsehhuhgrfigvihdrtghomhdprhgtphhtthhopegsrhhoohhnihgvse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepfihilhhlsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:DkfiaaBNfkHHowV89EbpEv0UcFRqubvCBzSkUDnoyuf0llcCiuydPg>
    <xmx:DkfiaYPAyklSFCAv3ZZM04805p7q1L-ufnUb3xjINtEwPH1wnm7oAA>
    <xmx:DkfiaWP3hG587E8ctgsmXbZd9_8JKmFSpd8i9R4wVzWoyFnVqF5EnQ>
    <xmx:DkfiaaKOpJ4OFsQJTe55ckgSSEwzuvTNep34MDZvZvAZgDCGTmKx1w>
    <xmx:DkfiaQrP-Hzi17D6vFpiJmrydcZ2YswO-z5ScYHlZ1VpO4M74xB76OfG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 90D9E700065; Fri, 17 Apr 2026 10:43:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 17 Apr 2026 16:43:06 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Robin Murphy" <robin.murphy@arm.com>,
 "Demian Shulhan" <demyansh@gmail.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "Mark Rutland" <mark.rutland@arm.com>,
 "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>,
 "Will Deacon" <will@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Brown" <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 "Li Nan" <linan122@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <c9362db6-1fef-4e70-9525-29b2936f4887@app.fastmail.com>
In-Reply-To: <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
References: <20260318150245.3080719-1-demyansh@gmail.com>
 <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
 <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
 <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
 <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for syndrome
 generation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 16 Apr 2026, at 18:26, Robin Murphy wrote:
> On 16/04/2026 3:59 pm, Demian Shulhan wrote:
>> Hi Ard!
...
>>> OK, so the takeaway here is that SVE is only worth the hassle if the
>>> vector length is at least 256 bits. This is not entirely surprising,
>>> but given that Graviton4 went back to 128 bit vectors from 256, I
>>> wonder what the future expectation is here.
>>
>> I agree. The results from the SnapRAID tests are not as impressive as
>> I hoped, and the fact that Neoverse-V2 went back to 128-bit is a red
>> flag. It suggests that wide SVE registers might not be a priority in
>> future architecture versions.
>
> If you look at the Neoverse V1 software optimisation guide[1], the SVE
> instructions generally have half the throughput of their ASIMD
> equivalents (i.e. presumably the vector pipes are still only 128 bits
> wide and SVE is just using them in pairs), so indeed the total
> instruction count is largely meaningless - IPC might be somewhat more
> relevant, but I'd say the only performance number that's really
> meaningful is the end-to-end MB/s measure of how fast the function
> implementation as a whole can process data.

On arm64, kernel mode NEON is mostly used to gain access to AES and SHA
instructions, and only to a lesser degree to speed up ordinary
arithmetic, and so XOR is somewhat of an outlier here.

Given that Neoverse V1 apparently already carves up ordinary arithmetic
performed on 256-bit vectors and operates on 128 bits at a time, I am
rather skeptical that we're likely to see any SVE implementations of the
crypto extensions soon that are meaningfully faster, given that these
are presumably much costlier to implement in terms of gate count, and
therefore likely to be split up even on SVE implementations that can
perform ordinary arithmetic on 256+ bit vectors in a single cycle. Note
that even the arm64 SIMD accelerated CRC implementations rely heavily on
64x64->128 polynomial multiplication.

IOW, before we consider kernel mode SVE, I'd like to see some benchmarks
for other algorithms too.

> It's probably also worth checking whether the current NEON routines
> themselves are actually optimal for modern big CPUs - things have
> moved on quite a bit since Cortex-A57 (whose ASIMD performance could
> also be described as "esoteric" at the best of times...)
>

Some of those crypto routines could definitely be made faster, but it
highly depends on the context whether that actually helps: for instance,
there was a proposal a while ago to incorporate the AES-GCM code from
the OpenSSL project (authored by ARM) but at the time, it slightly
regressed the ~1500 byte case and only gave a substantial improvement
for much larger block sizes, which aren't that common in the kernel for
this particular algorithm.

IOW, any contributions that improve the existing code (or outright
replace it with something faster, for all I care) are highly
appreciated, but they should be motivated by benchmarks that reflect
the use cases that we actually consider important for the algorithm
in question.
